Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2804bFB243713 for <xfs@oss.sgi.com>; Sun, 7 Mar 2010 18:04:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DA9A14017B3
	for <xfs@oss.sgi.com>; Sun,  7 Mar 2010 16:06:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	jg0Y0PtH6fTb2sSo for <xfs@oss.sgi.com>;
	Sun, 07 Mar 2010 16:06:05 -0800 (PST)
Date: Mon, 8 Mar 2010 11:06:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang during xfs_fsr run
Message-ID: <20100308000601.GF28189@discord.disaster>
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
	<4B8FA2CD.6010904@dermichi.com>
	<20100304131511.GH14317@discord.disaster>
	<20100304134641.GA26871@infradead.org>
	<4B8FC1B7.3070505@dermichi.com>
	<20100304222611.GK14317@discord.disaster>
	<4B92C71C.5010003@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B92C71C.5010003@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 10:20:28PM +0100, Michael Weissenbacher wrote:
> > If xfs_fsr hung before it checked the nodefrag flag, then there's
> > only a few things it could get stuck on:
> > 
> > 	1. fsync() of the file
> > 	2. file lock checks
> > 	3. statvfs64()
> > 	4. ioctl(XFS_IOC_FSGETXATTR)
> > 
> > A trace would tell us which one it was....
> > 
> Got another one, this time with ksyms enabled:
> [192115.749003] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000018
> [192115.749197] IP: [<ffffffff811ad69d>] xfs_trans_find_item+0x1/0xa
...
> [192115.749332] Call Trace:
> [192115.749338]  [<ffffffff811ad5c0>] ? xfs_trans_log_inode+0x22/0x4c
> [192115.749344]  [<ffffffff81180554>] xfs_bunmapi+0x9ec/0xa36
> [192115.749350]  [<ffffffff8119a452>] xfs_itruncate_finish+0x188/0x2db
> [192115.749355]  [<ffffffff811b0d41>] xfs_inactive+0x218/0x435
> [192115.749360]  [<ffffffff81364338>] ? __mutex_lock_slowpath+0x22d/0x23c
> [192115.749365]  [<ffffffff811bb096>] xfs_fs_clear_inode+0xb3/0xb8
> [192115.749371]  [<ffffffff810df28a>] clear_inode+0x78/0xd1
> [192115.749375]  [<ffffffff810df9f8>] generic_delete_inode+0xf6/0x16b
> [192115.749379]  [<ffffffff810dfa84>] generic_drop_inode+0x17/0x62
> [192115.749382]  [<ffffffff810deace>] iput+0x61/0x65
> [192115.749386]  [<ffffffff810dbf25>] dentry_iput+0xb5/0xc5
> [192115.749389]  [<ffffffff810dc00f>] d_kill+0x43/0x63
> [192115.749393]  [<ffffffff810dc75f>] dput+0x148/0x155
> [192115.749398]  [<ffffffff810cda56>] __fput+0x196/0x1bb
> [192115.749401]  [<ffffffff810cda93>] fput+0x18/0x1a
> [192115.749405]  [<ffffffff810cac36>] filp_close+0x67/0x72
> [192115.749409]  [<ffffffff810cacda>] sys_close+0x99/0xd2
> [192115.749415]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b

That's ... unexpected. That implies that ip->i_temp == NULL after it
has been joined to a transaction. I can't see how that could occur
there.  Can you recompile the kernel with CONFIG_XFS_DEBUG and
re-run the test as that option includes all sorts of sanity checks
for ip->i_temp?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
