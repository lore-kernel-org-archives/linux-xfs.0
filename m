Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE39A7F37
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 10:38:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 586B9AC009
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 08:38:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uKDCw6uatnIrMHVU for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 08:38:10 -0700 (PDT)
Date: Mon, 8 Jul 2013 17:38:07 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130708153807.GC12743@quack.suse.cz>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
	<20130708135953.GF5988@quack.suse.cz> <51DAD943.6050703@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51DAD943.6050703@gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Mon 08-07-13 17:22:43, Marco Stornelli wrote:
> Il 08/07/2013 15:59, Jan Kara ha scritto:
> >On Mon 08-07-13 22:44:53, Dave Chinner wrote:
> ><snipped some nice XFS results ;)>
> >>So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
> >>3.10-cil kernel I've been testing XFS on):
> >>
> >>	    create		 walk		unlink
> >>	 time(s)   rate		time(s)		time(s)
> >>xfs	  222	266k+-32k	  170		  295
> >>ext4	  978	 54k+- 2k	  325		 2053
> >>btrfs	 1223	 47k+- 8k	  366		12000(*)
> >>
> >>(*) Estimate based on a removal rate of 18.5 minutes for the first
> >>4.8 million inodes.
> >>
> >>Basically, neither btrfs or ext4 have any concurrency scaling to
> >>demonstrate, and unlinks on btrfs a just plain woeful.
> >   Thanks for posting the numbers. There isn't anyone seriously testing ext4
> >SMP scalability AFAIK so it's not surprising it sucks.
> 
> Funny, if I well remember Google guys switched android from yaffs2
> to ext4 due to its superiority on SMP :)
  Well, there's SMP and SMP. Ext4 is perfectly OK for desktop kind of SMP -
that's what lots of people use. When we speak of heavy IO load with 16 CPUs
on enterprise grade storage so that CPU (and not IO) bottlenecks are actually
visible, that's not so easily available and so we don't have serious
performance work in that direction...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
