Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUNbsLH074748 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 17:37:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98182DA2D82
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 15:38:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	YqCHAllmS4u2Vse8 for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2009 15:38:21 -0800 (PST)
Date: Tue, 1 Dec 2009 10:38:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31.6: XFS DEBUG: Assertions cause kernel OOPS.
Message-ID: <20091130233818.GE30608@discord.disaster>
References: <alpine.DEB.2.00.0911300819010.20343@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911300819010.20343@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 30, 2009 at 08:22:03AM -0500, Justin Piszcz wrote:
> Hi,
>
> I wanted to compile my kernel with DEBUG for XFS and also kernel frame pointers
> to catch any issues.
>
> However, DEBUG for XFS does more harm than good?

DEBUG is there for developers, not end users. Often the debug code
will assert fail or panic where the situation is not fatal but
indicative of some problem that should be looked into further.

> I tried to install bonnie++:
> # apt-get install -y bonnie++
>
> And then this happened:
>
> [ 1578.768558] Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4846
....
> [ 1578.769252]  [<ffffffff811eb916>] xfs_bmapi+0x66/0x1940
> [ 1578.769252]  [<ffffffff81260c51>] ? __up_read+0x91/0xb0
> [ 1578.769252]  [<ffffffff8123a0a7>] ? xfs_buf_free+0xc7/0x110
> [ 1578.769252]  [<ffffffff8123a1e6>] ? xfs_buf_rele+0xf6/0x130
> [ 1578.769252]  [<ffffffff8122e70a>] ? xfs_trans_brelse+0x19a/0x2a0
> [ 1578.769252]  [<ffffffff811f7ac7>] ? xfs_da_brelse+0x77/0x120
> [ 1578.769252]  [<ffffffff810bf63d>] ? filldir+0x9d/0xe0
> [ 1578.769252]  [<ffffffff8120225a>] xfs_dir2_leaf_getdents+0x61a/0x780
> [ 1578.769252]  [<ffffffff810bf5a0>] ? filldir+0x0/0xe0
> [ 1578.769252]  [<ffffffff810bf5a0>] ? filldir+0x0/0xe0
> [ 1578.769252]  [<ffffffff811fc6ec>] xfs_readdir+0x10c/0x110
> [ 1578.769252]  [<ffffffff810bf5a0>] ? filldir+0x0/0xe0
> [ 1578.769252]  [<ffffffff8123b4f4>] xfs_file_readdir+0x34/0x50
> [ 1578.769252]  [<ffffffff810bf7f8>] vfs_readdir+0xa8/0xc0
> [ 1578.769252]  [<ffffffff810bf963>] sys_getdents+0x83/0xe0
> [ 1578.769252]  [<ffffffff8102d1ab>] system_call_fastpath+0x16/0x1b

That is indicative of trying to map more blocks that we can fit
in the block map array during directory leaf readahead. That is
definitely not a problem for production systems, but definitely
indicates that the readahead loop termination has a bug in it
somewhere.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
