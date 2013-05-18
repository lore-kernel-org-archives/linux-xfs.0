Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 016EC7F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 01:27:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D72F98F8052
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 23:27:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZpfjACLDyJlvLVHh for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 23:27:21 -0700 (PDT)
Date: Sat, 18 May 2013 16:27:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/30] xfsprogs: Initial CRC support
Message-ID: <20130518062718.GD6495@dastard>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<51969917.2080209@gmail.com> <20130518032507.GA6495@dastard>
	<51971457.7060903@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51971457.7060903@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, May 18, 2013 at 01:40:39AM -0400, Michael L. Semon wrote:
> On 05/17/2013 11:25 PM, Dave Chinner wrote:
> >On Fri, May 17, 2013 at 04:54:47PM -0400, Michael L. Semon wrote:
> >>On 05/17/2013 07:12 AM, Dave Chinner wrote:
> >>>Hi Folks,
> >>>
> >>>This is the first real "works ok" CRC patchset for xfsprogs. It
> >>>provides full support for mkfs.xfs and xfs_repair, and partial
> >>>read-only support for xfs_db.
....
> >>OK.  The basics look good so far.  The patchset applied without need
> >>for additional work with vi and patch.  Whitespace errors were
> >>reported for Patches 8, 14, 16, 17, 24, 25, and 27.  xfsprogs built
> >>with no additional errors over a normal xfsprogs build.
> >
> >Can you send me the output indicating where the whitespace errors
> >are? I don't get any warnings from guilt about them when I apply the
> >patchset here...
> 
> If it makes any difference at all, I'm saving these patches using
> Thunderbird...

It shouldn't.

> The pre-patchset xfsprogs has been saved as a tarball, so I can
> provide a non-git patch session if necessary.  Sorry so vague last
> time:  I was overjoyed that everything went through git so cleanly.
> 
> This is the result of the patches about which `git am` complained:
> 
> PATCH 08:

....

Thanks, i'll have a look at them on monday...

> >>What I'm trying to state is that a lot is in there, but the PC is
> >>spinning like a top, and xfstests results are really good right now.
> >>However, if I feel the need to provide a fresh environment, patch
> >>management is taking some time.
> >
> >How are you managing patches right now? When taking in a new
> >patchset from a mailing list, I save them all in a mbox file,
> >then use git-am to apply them to a temporary git branch. I then move
> >to my real working branch, and do a 'guilt import-commit x..y' to
> >convert the commits in the temporary branch to a set of guilt
> >patches, and then go from there....
> 
> The patches themselves are stored as individual files, in case they
> need to be applied again.  Separate git branches are used for kernel
> patches, but for the XFS suite, I keep backup tarballs and work
> directly off of master.
> 
> A new branch is started at strategic points.  If you mention "this
> is based on 3.9.2 + xfsdev", kernel 3.9.2 is checked out into a new
> branch, xfs-oss/master is updated and merged, and the patches are
> reapplied.  It takes time but is the best way, until I can find the
> `git --backout-this-patch-cleanly --i-really-mean-it-this-time
> --do-not-bother-to-suggest-git-am-resolved-if-it-cannot-be-done`
> command.

Being able to add and remove patches and reorder them easily is
exactly why I use guilt. The raw git workflow is, well, less than
optimal IMO.

> The trick is to remember which patches to apply, so I might have a
> directory that has five great patches and one that no longer
> applies.
> 
> >The worst step for me is, by far, the git-am step. Resolving patch
> >conflicts is painful because you have to manually apply the patch,
> >then remember to git add all the files modified by the patch, etc.
> 
> I don't know how to use git to properly back out a patch that was
> made at some time in the past.  Disaster management in particular
> has left me to backup at strategic points.  On these older PCs,
> restore operations can be much faster than git recovery attempts.

So, once I've have a patch series imported into git as a guilt
stack, it's managed as a series of patches rather than as individual
patches or commits. The order is kept in a series file. So, updating
the underlying release for a specific patch set is effectively:

$ guilt checkout working	# go to base tree branch
$ guilt pop -a			# remove all patches in the branch
$ git reset --hard v3.10-rc1	# reset branch to known clean state
$ git remote update
$ git merge origin/master	# linus tree
$ git merge xfs-oss/master	# xfs tree
$ guilt push -a			# push all local patches back into branch

At this point I have an up-to-date linus + xfs + local patches
branch.

Say now I want add a new patchset in from the list. I save it as an
mbox file "saved-patches". Then I create a new branch from the xfs
tree so I know that it will apply cleanly:

$ git checkout -b imports xfs-oss/master
				# create a new branch from the xfs tree
$ git am saved-patches
.....

Now all patches are applied to the imports branch. Get all the
commit ids, switch back to the working branch, and import them into
guilt to track them as patches:

$ git log --oneline -n <number of patches in the seriesi + 2>
yyyy last commit
....
xxxx commit prior to first in new series
$ git checkout working
$ guilt import-commit xxxx..yyyy # import the commits onto the tail
				 # of the current patch series
$ guilt push -a			 # apply the patchset to the current branch
$ git branch -D imports		 # remove the temp import branch.

At this point, all the patches in the series you just pulled down
from the list are applied to your tree. You can now push and pop
them out of the tree, reorder them, etc as though you are just
managing a series of patches....

If any of the patches in the inew series fail to apply, then guilt
won't apply it. If you force apply it, guilt outputs the result of
applying the patch, same as if you ran patch. The difference is that
for all the modified files and  the files that need to be editted to
fix conflicts, you don't need to git add them. just "guilt refresh"
and you're ready to push the next patch in the series onto the
stack...

> `git am` is hard because that diagnostic "Patch does not apply" is
> not helpful, and the --ignore-whitespace option can cause trouble
> very quickly.

Right, so you have to go to .git/rebase-apply/patchNNNN to find the
patch that didn't apply, and run:

$ patch --dry-run -p1 < .git/rebase-apply/patchNNNN

to find out why it didn't apply.

> Any patches that don't apply by `git am` are reduced from E-mail to
> ordinary diffs and sent through `git apply`.  If that doesn't work,
> they go through patch; vimdiff is used to help splice the patches in
> by hand.  `git add` is then used to add the files.

Yes, it's painful, isn't it? That's why I try to apply the patches
to an otherwise unmodified tree so I can avoid this pain and use
guilt to resolve any conflicts.

However, if you do have git-am failures, skipping straight to the
above patch that git has already stripped from the email will make
it a bit faster for you.  It's still annoying having to manually use
git add, though.

> >>[ 6188.126012] XFS: Assertion failed: first <= last && last <
> >>BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 569
> >
> >Hmmm - that seems familiar - I thought I'd already fixed a bug like
> >that previously...
> 
> You may have fixed it already.  If there's a patch, either I don't
> have it, or it's stuck on my main xfstests PC at home.  Was this the
> issue that was triggered easily by xfstests xfs/017?

Might have been. It was a while back. If it's still there once I've
got it through xfstests here and you've applied the patches I send
out to get that far then I'll need to look deeper...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
