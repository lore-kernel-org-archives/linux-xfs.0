Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9O2drHH001545 for <xfs@oss.sgi.com>; Fri, 23 Oct 2009 21:39:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A9A317C0AC3
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2009 19:41:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	Tx8zUBbyilRMN2mH for <xfs@oss.sgi.com>;
	Fri, 23 Oct 2009 19:41:27 -0700 (PDT)
Date: Sat, 24 Oct 2009 13:41:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS in a XFS locks up in xfs_ilock
Message-ID: <20091024024124.GF9464@discord.disaster>
References: <alpine.LSU.2.00.0910231957570.5688@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910231957570.5688@obet.zrqbmnf.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Fri, Oct 23, 2009 at 08:02:08PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> it seems that somewhere, locking is afoul in XFS so that having a 
> loopback XFS on an XFS causes a deadlock, first on the subvolume, then 
> on the real one. Sometimes that happens within writing a few MB to the 
> subvolume (the loop one), sometimes nothing happens and it can be used 
> for many months.
> 
> Suggested testcase:
> 
> Starting out with $HOME being on xfs (truncate is coreutils 7+):
> $ >disk
> $ truncate --size=$[3*1048576*1024] disk
> So it's actually sparse(!)
> $ mkfs.xfs disk
> # mount disk mnt -oloop
> 
> Start filling it with data, preferably something like installing a bunch 
> of rpm/debs into mnt, and hopefully soon enough, the thing will lock up.
> xfs_ilock I got from `ps xaf -o wchan` while a box was shortly before 
> dying - processes were stuck in D state. Not sure if this is related to 
> the sparseness of the file, but I would bet it's part of the problem.

Can you provide the output of sysrq-w (echo w > /proc/sysrq-trigger)
so we can see stacks of the threads stuck in D state?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
