Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBSNLN91079519 for <xfs@oss.sgi.com>; Mon, 28 Dec 2009 17:21:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 354661C1E2C5
	for <xfs@oss.sgi.com>; Mon, 28 Dec 2009 15:22:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	SdrH0WPy5lITzni6 for <xfs@oss.sgi.com>;
	Mon, 28 Dec 2009 15:22:08 -0800 (PST)
Date: Tue, 29 Dec 2009 10:22:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs 2.6.31.9 error
Message-ID: <20091228232204.GB7613@discord.disaster>
References: <20091228151048.GA24031@bob.dscon.sk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091228151048.GA24031@bob.dscon.sk>
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
To: DS <xfs@bob.dscon.sk>
Cc: xfs@oss.sgi.com

On Mon, Dec 28, 2009 at 04:10:48PM +0100, DS wrote:
> Hello,
> 
> after upgrade from Debian etch -> Debian lenny with custom kernel
> 2.6.31.9 (before 2.6.28.1) I see this error and server is
> resetting sometimes..
> 
> Filesystem was creating far far away (about 4years ago).
> 
> XFS internal error XFS_WANT_CORRUPTED_RETURN at line 366 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff81169ae3

Any errors in the log before this (e.g. IO errors)?

> Pid: 4022, comm: procmail Not tainted 2.6.31.9 #3
> Call Trace:
>  [<ffffffff8118edfe>] xfs_error_report+0x3e/0x40
>  [<ffffffff811680fa>] xfs_alloc_fixup_trees+0x2ba/0x340
>  [<ffffffff81167de9>] ? xfs_alloc_get_rec+0x29/0x60
>  [<ffffffff81169ae3>] xfs_alloc_ag_vextent_near+0x3f3/0x940
>  [<ffffffff8116a105>] xfs_alloc_ag_vextent+0xd5/0x130
>  [<ffffffff8116aa68>] xfs_alloc_vextent+0x3a8/0x4f0
.....

Looks like a corrupted free space tree - that could have happened a
long time ago and only now are you tripping over it. I'd run
xfs_repair on the filesystem to fix up the problem. If it happens
again then we'll have to look deeper.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
