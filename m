Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6SGeexW260508 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 11:40:40 -0500
Subject: Re: XFS Master Branch Rebase
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100727232719.GR7362@dastard>
References: <1280247366.2002.111.camel@doink> <20100727232719.GR7362@dastard>
Date: Wed, 28 Jul 2010 11:43:43 -0500
Message-ID: <1280335423.2238.195.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-07-28 at 09:27 +1000, Dave Chinner wrote:
> On Tue, Jul 27, 2010 at 11:16:06AM -0500, Alex Elder wrote:
> > Some recent commits have resulted in changes to
> > the XFS master branch that result in non-trivial
> > merges, which are not something we want to have in
> > our git history.  (I didn't realize this when I
> > pushed my last set of updates out, unfortunately.)
> > 
> > To remedy this, I'm have re-based the XFS master
> > branch on oss.sgi.com against v2.6.35-rc6.
> 
> <groan>
> 
> Alex, this is a bit annoying. Rebases are a real pain for anyone
> downstream that is using git in non-trivial ways. I'll give you an
> idea of what this means to me - for the xfs tree directly:

I'm not going to argue, I know it's bad.  I'll try to offer
a little explanation though.

Christoph told me that Linus dislikes non-trivial merges,
and suggested I re-base the tree.  I have been trying to
avoid having this sort of effect on people using the
repository.  But I opted in this case to upset them
(and you) rather than Linus, and went to work re-basing
things.

. . .
> > If you have a different branch checked out, you
> > can do this instead to force the re-based commits
> > to land in your "xfs-master" branch:
> >     git pull git://oss.sgi.com/xfs/xfs.git +master:xfs-master
> 
> You don't want to do this - the forced merge causes a branch in
> history in the local repository and hence it's no longer an
> identical copy of the upstream repository any more. I got caught by
> this on a previous rebase when I started pushing commits back out
> and people tried to pull them...

The "+" in the refspec on the command above is there
intentionally, to make the local branch "xfs-master"
to be updated to match the remote *without* doing a merge.
If my local "xfs-master" branch is at the previous head
for "master", it works for me.

With that refspec, the "git fetch" part of the pull
does the forced update; the "git merge" part of the
pull should then find the branch "Already up-to-date."

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
