Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q961U4mh148191 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 20:30:04 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	N7JLKSr64sPH8cV6 for <xfs@oss.sgi.com>;
	Fri, 05 Oct 2012 18:31:29 -0700 (PDT)
Date: Sat, 6 Oct 2012 11:31:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch v4 00/13] xfs: remove the xfssyncd mess
Message-ID: <20121006013122.GF23644@dastard>
References: <20121005171853.985930109@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121005171853.985930109@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 05, 2012 at 12:18:53PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> Here I am reposting your xfssyncd series.  I want to make sure that
> we're all on the same page.  In particular, are we all happy with patch
> 6, 'xfs: xfs_sync_data is redundant'?
> 
> Version 4:
> - updated 'xfs: xfs_sync_data is redundant' with cleanups to the 
>   xfs_flush_inodes interface as per Christoph's request,
> - updated 'xfs: xfs_sync_data is redundant', folding in changes from 
>   http://oss.sgi.com/archives/xfs/2012-10/msg00036.html 
> - fixed a minor typo in xfs: 'syncd workqueue is no more', renaming the 
>   log worker from 'xfs-reclaim' to 'xfs-log'.
> 
> I was going to rush this in for the 3.7 merge window.  However in the
> light of the issues with patch 6 and Linus's comment here:
> http://lkml.org/lkml/2012/9/30/152 and Stephen's comment here:
> https://lkml.org/lkml/2012/9/23/144, I think it wiser to behave.  3.7
> is stable without this series, so I will merge it for 3.8.
> 
> Once we have an agreement that patch 6 is ready I will pull this in to the
> master branch first thing after the 3.7-rc1 merge from upstream.

<sigh>

Seriously? Why am I only finding out that there needs to be more
rework to patches in this series after someone else reposted them?
And that this is the cause of it missing the merge window?

So, a week ago on IRC I said to you (Ben):

[27/09/12 09:42] <dchinner_> I'm not really surprised you missed me
[27/09/12 09:42] <dchinner_> in fact, that's what I wanted to talk about
[27/09/12 09:43] <dchinner_> I'm getting really frustrated by the 24-hour turnaround time for any sort of discussion with you and mark
[27/09/12 09:44] <dchinner_> You and mark only seem to respond to the mailing list in Eagan business hours (roughly 10am-4:30pm according to the time stamps on your emails)
[27/09/12 09:44] <dchinner_> and that corresponds pretty closely with the 7-8 hours I sleep every night.
[27/09/12 09:45] <dchinner_> I tend to check and respond to mailing list traffic over a 15-16 window each day, but even doing that I get zero overlap with your online times.
[27/09/12 09:45] <dchinner_> So discussions that should take an hour or 2 and be solved take a week or more
[27/09/12 09:49] <dchinner_> I can't lengthen my day any more than it already is to try to get some overlap with you and Mark....
[27/09/12 11:16] * dchinner_ suspects he's going to be waiting until tomorrow to get a response....

If I was frustrated by this communication problem a week ago....

If you simply said that there's more than just folding a fix into
the series, I could have done all the changes and had it turned
around in about 2 hours (modification, build and test cycle time),
and all these issues could have been shaken out several days ago.
If the first I hear that there is significant rework needed to one
of my patchsets is someone else reposting it with changes that need
discussion in it, then there's a serious comminucation breakdown
occurring.

Seriously, if there's more than one less-than-trivial problem with a
patch set, through it back to the owner of the patchset to fix.  The
maintainers job is to communicate and co-ordinate, not fix other
people's patch sets for them.  It just doesn't scale - push problems
back to the patch owner to deal with.

FWIW, I'll quote from another patchset description I posted yesterday
(allocation workqueue deadlock fixes) to point out that I'm not just
commenting on this patch set:

"This is a followup from the last conversation with Mark about this
deadlock. I haven't heard anything in the last couple of days, so I
figured I'd just write the patches that did what I thought is
needed."

The discussion of that patch series made 4-5 round trips between
Mark and myself over a period of more than 2 weeks, with me always
waiting on answers from Mark so that I could understand the problem
he was seeing and trying to fix. Realistically, it should have taken
2-3 days at most. And then when I don't get a response for 2-3 days
in the middle of a working week, I'm left to wonder WTF is going on.
I end up just doing the change instead of letting it get dropped on
the ground, without knowing whether I'm duplicating work that is
already being done by someone else.

As I said, I can't do any more than I already do to try to get lower
latency and more frequent communications, so there's little I can do
to reduce the amount of frustration I'm having. So I'm reduced to
making more public noise about the problem in the hope that we can
come up with a solution....

Not a happy camper.

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
