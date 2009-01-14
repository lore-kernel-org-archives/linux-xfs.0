Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0EJilGf026573 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 13:44:49 -0600
Received: from eazy.amigager.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0D088AEF8
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 11:44:46 -0800 (PST)
Received: from eazy.amigager.de (eazy.amigager.de [213.239.192.238]) by
	cuda.sgi.com with ESMTP id gYFv5FuQ66fPkGRg for
	<xfs@oss.sgi.com>; Wed, 14 Jan 2009 11:44:46 -0800 (PST)
Date: Wed, 14 Jan 2009 20:44:09 +0100
From: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090114194409.GB4509@dose.home.local>
References: <20090107165218.GA11132@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107165218.GA11132@dth.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

[added CC:]

On Wed, Jan 07, 2009 at 17:52:18 +0100, dth wrote:
> Am running low-power motherboard (via epia5000 c3) as a storage (samba/nfs)
> server. (uses about 20 watts when both storage drives are in powersave mode)
> 
> OS = debian lenny
> 
> Pimairy drive (60gig 2.5" pata disk using libata = sda)
>  512MB ext3 partition as /boot
>  swap, rest of the drive is XFS root file system.
> 
> storage:
> 2 x 750GB drives on a sata controller (FastTrak S150 TX2plus)
> sdb & sdc which have 1 big XFS partition.
> 
> Any kernel i try to boot after 2.6.28-git2 (i tried git4-9) 
> sooner or later gives me an XFS error:

[...]

> Anyone else bitten by the same problem ?
y
Hi,

I get the same on a Mac mini Core Duo using 2.6.29-rc1. I just booted,
started firefox and my /home died.

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file linux-2.6/fs/xfs/xfs_btree.c.  Caller 0xc022e9c6
Pid: 4937, comm: firefox-bin Not tainted 2.6.29-rc1-00224-ga652504 #11
Call Trace:
 [<c022e6d9>] xfs_btree_delrec+0xbd9/0xea0
 [<c022e9c6>] xfs_btree_delete+0x26/0x90
 [<c022b355>] xfs_btree_lookup_get_block+0xa5/0xe0
 [<c022933a>] xfs_bmbt_init_key_from_rec+0xa/0x20
 [<c022c6ba>] xfs_btree_lookup+0x21a/0x460
 [<c022e9c6>] xfs_btree_delete+0x26/0x90
 [<c02255ff>] xfs_bmap_del_extent+0x64f/0xb70
 [<c02262ea>] xfs_bunmapi+0x65a/0xb30
 [<c0244f6b>] xfs_itruncate_finish+0x1ab/0x3e0
 [<c026115d>] xfs_inactive+0x3cd/0x4f0
 [<c019113c>] clear_inode+0x5c/0x100
 [<c01917fe>] generic_delete_inode+0xce/0xe0
 [<c0190b24>] iput+0x44/0x50
 [<c01898a0>] do_unlinkat+0xe0/0x160
 [<c0188180>] lock_rename+0x0/0xa0
 [<c01033c5>] sysenter_do_call+0x12/0x25
Filesystem "dm-1": XFS internal error xfs_trans_cancel at line 1164 of file linux-2.6/fs/xfs/xfs_trans.c. 
Caller 0xc0261173

Pid: 4937, comm: firefox-bin Not tainted 2.6.29-rc1-00224-ga652504 #11
Call Trace:
 [<c025a54b>] xfs_trans_cancel+0xcb/0xf0
 [<c0261173>] xfs_inactive+0x3e3/0x4f0
 [<c0261173>] xfs_inactive+0x3e3/0x4f0
 [<c019113c>] clear_inode+0x5c/0x100
 [<c01917fe>] generic_delete_inode+0xce/0xe0
 [<c0190b24>] iput+0x44/0x50
 [<c01898a0>] do_unlinkat+0xe0/0x160
 [<c0188180>] lock_rename+0x0/0xa0
 [<c01033c5>] sysenter_do_call+0x12/0x25
xfs_force_shutdown(dm-1,0x8) called from line 1165 of file linux-2.6/fs/xfs/xfs_trans.c.  Return address = 0xc025a563
Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down filesystem: dm-1
Please umount the filesystem, and rectify the problem(s)

Regards,
Tino

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
