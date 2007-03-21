Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Mar 2007 18:16:38 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2L1GT6p008334
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2007 18:16:31 -0700
Subject: Re: XFS bug???
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <87y7lrmnra.wl%peterc@chubb.wattle.id.au>
References: <87y7lrmnra.wl%peterc@chubb.wattle.id.au>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 12:17:01 +1100
Message-Id: <1174439821.5051.314.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: xfs@oss.sgi.com

On Wed, 2007-03-21 at 11:41 +1100, Peter Chubb wrote:
> Hi Nathan,
> 	Our main backup machine is showing XFS errors.  Any ideas how
> to fix?  

Hi Peter,

I don't have as much time to spend on XFS as I used to, so better to
contact the list at SGI (CC'd).  What kernel version are you running
there?  Looks like a corrupt directory - was this machine exposed to
the 2.6.17 corruption issue perhaps?

cheers.

> Mar 20 08:12:29 bitburger kernel: Filesystem "dm-0": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xf91d5d60
> Mar 20 08:12:29 bitburger kernel:  [pg0+953910291/1069454336] xfs_trans_cancel+0x103/0x140 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+953945440/1069454336] xfs_create+0x3d0/0x780 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+953945440/1069454336] xfs_create+0x3d0/0x780 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+954000638/1069454336] xfs_vn_mknod+0x3ae/0x4b0 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+953977031/1069454336] xfs_buf_free+0x47/0xc0 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+953722066/1069454336] xfs_da_state_free+0x52/0x70 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+953759517/1069454336] xfs_dir2_node_lookup+0x9d/0xd0 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [pg0+953724888/1069454336] xfs_dir_lookup+0x138/0x160 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [__link_path_walk+3778/3808] __link_path_walk+0xec2/0xee0
> Mar 20 08:12:29 bitburger kernel:  [_atomic_dec_and_lock+43/80] _atomic_dec_and_lock+0x2b/0x50
> Mar 20 08:12:29 bitburger kernel:  [mntput_no_expire+35/208] mntput_no_expire+0x23/0xd0
> Mar 20 08:12:29 bitburger kernel:  [pg0+953918840/1069454336] xfs_dir_lookup_int+0x48/0x130 [xfs]
> Mar 20 08:12:29 bitburger kernel:  [permission+211/272] permission+0xd3/0x110
> Mar 20 08:12:29 bitburger kernel:  [vfs_create+210/384] vfs_create+0xd2/0x180
> Mar 20 08:12:29 bitburger kernel:  [open_namei+1806/1904] open_namei+0x70e/0x770
> Mar 20 08:12:29 bitburger kernel:  [netif_receive_skb+651/880] netif_receive_skb+0x28b/0x370
> Mar 20 08:12:29 bitburger kernel:  [do_filp_open+64/96] do_filp_open+0x40/0x60
> Mar 20 08:12:29 bitburger kernel:  [get_unused_fd+168/240] get_unused_fd+0xa8/0xf0
> Mar 20 08:12:29 bitburger kernel:  [do_sys_open+87/240] do_sys_open+0x57/0xf0
> Mar 20 08:12:29 bitburger kernel:  [sys_open+39/48] sys_open+0x27/0x30
> Mar 20 08:12:29 bitburger kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
> Mar 20 08:12:29 bitburger kernel: Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down filesystem: dm-0
> Mar 20 08:12:29 bitburger kernel: Please umount the filesystem, and rectify the 
> problem(s)
> 
> 
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
-- 
Nathan
