Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o860pqMb142716 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 19:51:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F063CD907FE
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 18:03:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	u02ASWihmFeBDP8e for <xfs@oss.sgi.com>;
	Sun, 05 Sep 2010 18:03:32 -0700 (PDT)
Date: Mon, 6 Sep 2010 10:52:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs on armv5 still with erroneous log in kernel 2.6.35.4
Message-ID: <20100906005230.GX7362@dastard>
References: <4C835A34.9080008@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C835A34.9080008@googlemail.com>
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
To: Marcus Osdoba <marcus.osdoba@googlemail.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 05, 2010 at 10:52:04AM +0200, Marcus Osdoba wrote:
>  Hello XFS mailinglist,
> 
> On my armv5 device I like to use XFS for my simple home made nas,
> because I think it is ideal for low/medium performance CPUs.
> I searched the mailing archive about the usage of XFS on arm
> architecture. I figured out, that the patchset of James Bottomley
> was applied to the main line. So I expected xfs to run properly on
> arm. Unfortunatly I still run into this (known) error after writing
> some data on an xfs partition and remounting it:
> <mailto:xfs@oss.sgi.com>"
> SGI XFS with ACLs, security attributes, large block/inode numbers,
> no debug enabled
> SGI XFS Quota Management subsystem
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> "
>
> Am I still forced to use the "hammer" approach (flushing buffers in
> xfs_buf.c) which was proposed in January 2010? Or did I misinterpret
> the logfile of the xfs component in the kernel (so no arm fixing
> patches were applied)?

What kernel version are you running? The xfs-vipt branch was merged into
mainline in late February, so kernels from 2.6.34 onwards should be
OK.

If it isn't ok, then we need to know exactly what ARM CPU arch you
are using, and if the old brute-force cache flushing hack fix the
problem or not.

> Is xfs NOW be known to work on arm (e.g. armv5)? If so I like to
> complain. If not, I'm willing to test patches which might solve this
> issue.

I don't know of any outstanding XFS specific issues on ARM, but I
don't have any ARM machines here that I can test on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
