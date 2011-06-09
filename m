Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59LHZ0g201179 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 16:17:36 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC27C1665C50
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 14:17:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ulBJlZkdlUZBozNE for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2011 14:17:34 -0700 (PDT)
Date: Fri, 10 Jun 2011 07:17:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110609211731.GT32466@dastard>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
	<20110609012907.GR32466@dastard>
	<20110609134811.GI28625@pyre.virge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110609134811.GI28625@pyre.virge.net>
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
To: Norbert Veber <nveber@pyre.virge.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Thu, Jun 09, 2011 at 09:48:11AM -0400, Norbert Veber wrote:
> On Thu, Jun 09, 2011 at 11:29:07AM +1000, Dave Chinner wrote:
> > Those mount options are ignored if the filesystem doesn't have the
> > superblock feature bit set for aligned allocations. A filesystem
> > with 0/0 for sunit/swidth does not have the superblock bit set....
> 
> Oh man!  I thought I saw some improvement with iometer benchmarks before
> and after the mount options, but I dont see any significant difference
> while timing the untar and rm -rf I've been doing.
> 
> All the documentation I came across including the man page and XFS faq
> entry imply that the mount options can be used to perform alignment..

The mount options are only there to cahnge the alignment that
already exists, and there are significant limitations on those
changes.

You can't just apply alignment to a filesystem with no alignment
becaue XFS makes certain assumptions about how aligned filesystems
are laid out (e.g. AGs always start aligned to a sunit). If the
filesystem is created without alignment, there is a pretty good
chance that it is simply not possible to post-apply alignment to it.

> In these kinds of cases maybe there should be an error logged instead of
> just silently ignoring them?

It does log errors if you already have alignment set and your change
is invalid. If you don't have alignemnt, then they are no-ops and so
are ignored.

> Is there any way to change the superblock?  Eg. soething like the ext*
> command:

You can do it with xfs_db, but see above for why it's a bad idea.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
