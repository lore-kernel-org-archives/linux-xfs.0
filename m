Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RBeNZR089524 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 06:40:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E4C82CC94
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 04:40:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	0kBBCnK1nFIpaLz3 for <xfs@oss.sgi.com>;
	Fri, 27 Aug 2010 04:40:58 -0700 (PDT)
Date: Fri, 27 Aug 2010 21:40:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: xfsdump-3.0.4 problems
Message-ID: <20100827114055.GI705@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
	<20100817090534.GP10429@dastard> <20100817114550.GQ10429@dastard>
	<20100827111820.GA9837@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100827111820.GA9837@teal.hq.k1024.org>
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
To: Mario Bachmann <mbachman@stud.uni-frankfurt.de>, xfs@oss.sgi.com

On Fri, Aug 27, 2010 at 01:18:20PM +0200, Iustin Pop wrote:
> On Tue, Aug 17, 2010 at 09:45:50PM +1000, Dave Chinner wrote:
> > My fault. I screwed up the btree lookup for the inode validation.
> > Can you test the patch below?
> 
> I just see that 2.6.35.4 has been released, but it doesn't include this
> fix (as far as I can see). Could it be send for inclusion into the next
> stable please (yes, it fixes the issue for me too).

The commit is now upstream, it had a "cc: stable@kernel.org" in it,
so it should get automatically queued for inclusion in the next
stable kernel release. If I don't see it appear in Greg's stable
queue once he starts processing the commits for the next stable
release, I'll chase it up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
