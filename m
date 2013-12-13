Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FD6329E04
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:43:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C6508F8066
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:43:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mE91G0YET5X8VcbL for
	<xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:43:30 -0800 (PST)
Message-ID: <52AB0EC1.4000500@redhat.com>
Date: Fri, 13 Dec 2013 08:42:25 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC] Handling of reviewed patch series
References: <20131213053611.GQ10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 12/13/2013 12:36 AM, Dave Chinner wrote:
> Hi folks,
> 
...
> What I'd like to do is publish each of the reviewed branch in the
> XFS git repos on oss.sgi.com as completed and ready-to-go code. This
> is a bit different to what we do now - normally Ben would come along
> and merge the series straight into the master branch, then update
> the for-next branch to point at it.
> 
> The issue with this is that it then makes our lives more difficult
> when we get a bug fix that has to go into the master branch and be
> sent to linus for an -rc kernel before all the development code that
> is already checked into the master branch.
> 
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

Is the merge of a topic branch into the for-next branch a maintainer
duty formality here, or another "phase" we're introducing into the
development process? IOW, a developer submits patches and said patches
are reviewed and merged into a topic branch. What/when/how is said topic
branch merged into the for-next for impending upstream merge?

I don't see the existence of such branches as a big issue. In fact, it
would be nice to see a sort of a high/feature level index of what kind
of things are outstanding for a release, or to be able to narrow down a
regression into a particular set, etc. A more granular workflow doesn't
necessarily hurt if the maintainer(s) see it as worth the extra steps.

On the flipside, topic branches alone make it harder for a
non-maintainer to actually test the whole of a release. Is it up to the
developer to merge all of the topic branches to actually test everything
and actively maintain that relationship as things change on the
maintainer end? Or are these patches pulled into a topic branch and
merged onto for-next at the same time?

Brian

> What this means is that development can be done against the master
> branch without fear of conflicting with other changes that are being
> done. Testing, however, can target the for-next branch, and local
> integration testing can be done simply by merging a local topic
> branch into a local for-next branch....
> 
> Lines of development that overlap will generate conflicts at
> the for-next branch merge, and at that point we can decide how to
> deal with the problem. e.g. turn the conflicting topic branches into
> a single, larger topic branch, live with it, etc.
> 
> When it comes to sending code upstream to Linus, we can either send
> a pull request per topic branch - Linus often likes to do merges
> himself - or we can merge them all into a single branch and ask
> Linus to pull that. The deciding factor may well be Linus himself...
> 
> However, what this structure means is that urgent bugs fixes canbe
> placed into their own topic branches - an "urgent-*" prefix is often
> used for these by other maintainers - and Linus can pull directly
> from the topic branch without us having to worry about
> cherry-picking out of the middle of the master branch and all the
> pain that entails.
> 
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
> 
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
> 
> Anyway, have a think and discuss - I'm going to push the branches I
> mentioned above....
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
