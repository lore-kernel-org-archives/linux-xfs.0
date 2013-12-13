Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33AC77F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 12:56:31 -0600 (CST)
Date: Fri, 13 Dec 2013 12:56:18 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131213185618.GJ1935@sgi.com>
References: <20131213053611.GQ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213053611.GQ10988@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Fri, Dec 13, 2013 at 04:36:11PM +1100, Dave Chinner wrote:
> I'd like to make a proposal and see what people think abou tit for
> managing patch series that I have been reviewed.
> 
> What I'd like to do is publish the reviewed and signed-off topic
> branches that I built as in my local git tree as part of the review
> and test process. For example, I currently have two such branches
> right now - one for Christoph's log format changes, and another for
> Jeff's icluster cleanups.
> 
> That is:
> 
> $ git shortlog xfs-oss/master..guilt/tip-log-format
> Christoph Hellwig (10):
>       xfs: remove duplicate code in xlog_cil_insert_format_items
>       xfs: refactor xfs_buf_item_format_segment
>       xfs: refactor xfs_inode_item_size
>       xfs: refactor xfs_inode_item_format
>       xfs: introduce xlog_copy_iovec
>       xfs: format log items write directly into the linear CIL buffer
>       xfs: format logged extents directly into the CIL
>       xfs: remove the inode log format from the inode log item
>       xfs: remove the dquot log format from the dquot log item
>       xfs: remove the quotaoff log format from the quotaoff log item
> 
> $ git shortlog xfs-oss/master..guilt/tip-icluster-factor 
> Jie Liu (8):
>       xfs: get rid of XFS_IALLOC_INODES macros
>       xfs: get rid of XFS_INODE_CLUSTER_SIZE macros
>       xfs: get rid of XFS_IALLOC_BLOCKS macros
>       xfs: introduce a common helper xfs_icluster_size_fsb
>       xfs: use xfs_icluster_size_fsb in xfs_bulkstat
>       xfs: use xfs_icluster_size_fsb in xfs_ialloc_inode_init
>       xfs: use xfs_icluster_size_fsb in xfs_ifree_cluster
>       xfs: use xfs_icluster_size_fsb in xfs_imap
> 
> These branches are all based on the master branch as it currently
> stands. They have had each patch individually compile tested, they
> have been individually tested, and they've been merged into a test
> tree and tested along with every other branch I'm currently working
> on.
> 
> What I'd like to do is publish each of the reviewed branch in the
> XFS git repos on oss.sgi.com as completed and ready-to-go code. This
> is a bit different to what we do now - normally Ben would come along
> and merge the series straight into the master branch, then update
> the for-next branch to point at it.

Yes, normally I'd merge those series right about now.  ;)

> The issue with this is that it then makes our lives more difficult
> when we get a bug fix that has to go into the master branch and be
> sent to linus for an -rc kernel before all the development code that
> is already checked into the master branch.

Yeah, that's the same issue we have during the merge window.  You can't pull
stuff into the master branch until after Linus has pulled and you've pulled
back if you want a fast-forward merge the next time around.  If you do pull
stuff in during the window you get a merge commit that screws up the history
graph.  The workaround in later -rc requests is to cherry-pick (AKA rebase) the
bugfixes back onto the latest commit that Linus has pulled, and then there are
duplicate commits that we pull back from mainline after the next merge window
closes.  It's not the prettiest thing, but better than screwing up the graph.

> What I propose is that the xfs-oss/master branch tracks the Linus
> -rc1 releases, and we never check code directly into the master
> branch except in exceptional circumstances. i.e.  we try to only
> ever pull back down from Linus into it. Exceptional circumstances
> would be work that causes widespread rebasing, like all of the
> structural rework that we've done recently. The structural work
> would go into the master branch immediately after a -rc1 update, and
> the next cycle's work and topic branches then based on top of that.
> 
> What this means is that the "for-next" branch is no longer based
> on the master branch - it becomes the development branch we work on,
> and is effectively a merge of all the topic branches. i.e like the
> -next tree, it is a branch that can be rebased without impacting the
> history of the code in the topic branches because it's just a merge
> target.
> 
> What this means is that development can be done against the master
> branch without fear of conflicting with other changes that are being
> done. Testing, however, can target the for-next branch, and local
> integration testing can be done simply by merging a local topic
> branch into a local for-next branch....

I'm not too keen on rebasing a published branch, mostly because I tend to log
test results by commit id.  If there is a way to keep the initial commit id
stable and in the repo so it can be referenced later it would be better.  e.g.
In the [unlikely] event that the for-next branch does need to be rebased, tag
it first.

> Lines of development that overlap will generate conflicts at
> the for-next branch merge, and at that point we can decide how to
> deal with the problem. e.g. turn the conflicting topic branches into
> a single, larger topic branch, live with it, etc.
> 
> When it comes to sending code upstream to Linus, we can either send
> a pull request per topic branch - Linus often likes to do merges
> himself - or we can merge them all into a single branch and ask
> Linus to pull that. The deciding factor may well be Linus himself...

If you take a look at merges into mainline using gitweb they look like this:

Merge branch 'for-linus' of git://git./linux/kernel... 

I suggest that the topic branches start with xfs.

e.g. 'xfs-refactor-icluster-macros' would be better than 'tip-icluster-factor'.

> However, what this structure means is that urgent bugs fixes canbe
> placed into their own topic branches - an "urgent-*" prefix is often
> used for these by other maintainers - and Linus can pull directly
> from the topic branch without us having to worry about
> cherry-picking out of the middle of the master branch and all the
> pain that entails.

Cherry-picking is not all that painful, but a a 'misc' branch, or 'urgent'
seems fine to me too.  I do prefer an xfs- prefix and to send signed tags in
pull requests...
 
> It also allows us much more flexibility in managing the
> code and how it is send upstream. It also makes it possible to push
> code earlier for wider testing without being stuck with that code
> forever - it's trivial to drop a topic branch if it causes
> unexpected regressions or problems without leaving nasty reverts all
> over the history.
> 
> Yes, this is a bit of a change in the way we do things, but it
> aligns much more closely to the distributed nature of how we develop
> the code. I'm going to push the two topic branches I mentioned above
> into the oss repository so people can have a look at them and get a
> feel for how such a process might work and so we can reference them
> during the discussion.

Lets see if I understand correctly (and I'll take some of my own advice from
above).  I'll pull 'tip-icluster-factor' into a local branch named
'xfs-refactor-icluster-macros', and merge it into our for-next branch along
with the other series.  This will get them into -next, and we can still toss it
later if it's not what you had in mind.

> Essentially, I want to speed up the rate at which we get code
> integrated without the risk of making a big mess by committing to
> code too quickly. Keeping code in topic branches like this solves
> that problem, and the fact that it closely aligns to my normal
> workflow makes it very appealing to me as a Maintainer....
> 
> Keep in mind that I want to do the same thing for major pieces of
> work with xfstests and xfsprogs - keep work in topic branches until
> they are tested and ready to go, then merge everything into the master
> branch and cut a release. This would enable a much faster xfsprogs
> release schedule because we make a release at any point in time
> without having to worry about whether we have work in progress in
> the master branch that needs completing before a release is done...

Yeah, that's interesting in light of Christoph's suggestion for a 3.1.12
release.  Probably we should try this on the kernel repo for awhile to see how it
goes.

> Anyway, have a think and discuss - I'm going to push the branches I
> mentioned above....

I've been tracking message id and patchwork id in git notes along with commits
for awhile.  I'm hoping this will become useful later for cross referencing the
list, patchworks, and test results.  If you wouldn't mind also doing so I'd
appreciate it.  Maybe it could be done with a post-commit script or something.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
