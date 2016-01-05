Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 513B07F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 10:31:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CA078F804B
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 08:31:00 -0800 (PST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id ESGWF8BlqVSPGHw2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 08:30:57 -0800 (PST)
Received: by mail-wm0-f48.google.com with SMTP id f206so37386495wmf.0
	for <xfs@oss.sgi.com>; Tue, 05 Jan 2016 08:30:57 -0800 (PST)
Date: Tue, 5 Jan 2016 17:30:55 +0100
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20160105163055.GA18111@glen>
References: <20151214180048.GA15690@glen> <20151214195422.GM26718@dastard>
	<20151214201526.GA25152@glen> <20151214212220.GO26718@dastard>
	<20151215091145.GA19282@glen> <20160103204758.GW19802@dastard>
MIME-Version: 1.0
In-Reply-To: <20160103204758.GW19802@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9183989191785648979=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--===============9183989191785648979==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 04, 2016 at 07:47:58AM +1100, Dave Chinner wrote:
> > I'm recompiling, to try it again.
> > Maybe, in the meanwhile, you can do something with my files. You can find 'em here:
> > http://mail.gelma.net/xfs_kasan
>
> Any update on this problem, Andrea?

Here we are!
Reproduced right now.

So, just to avoid confusion:
a) it's a vanilla kernel 4.4.0-rc8
b) plus some btrfs patches
c) plus some dri/intel/i915 patches
d) at the same URL above you can find git_files.txt.gz, where you have each commit I
   applied above vanilla kernel (anyway, nothing related to vfs/xfs of course)
e) at the same URL you find the kernel binaries I used
f) to catch it, I had to copy a few gigs of files on my /home partition (xfs over Luks)

Anyway, here what you asked me for:

(gdb) l *(xfs_iflush_cluster+0xb73/0xc10)
0xffffffff8184c550 is in xfs_iflush_cluster (fs/xfs/xfs_inode.c:3182).
3177
3178    STATIC int
3179    xfs_iflush_cluster(
3180            xfs_inode_t     *ip,
3181            xfs_buf_t       *bp)
3182    {
3183            xfs_mount_t             *mp = ip->i_mount;
3184            struct xfs_perag        *pag;
3185            unsigned long           first_index, mask;
3186            unsigned long           inodes_per_cluster;
(gdb)

Thanks a lot for your patience,
Dave

[mar gen  5 16:58:19 2016] ==================================================================
[mar gen  5 16:58:19 2016] BUG: KASAN: use-after-free in xfs_iflush_cluster+0xb73/0xc10 at addr ffff880364721d10
[mar gen  5 16:58:19 2016] Read of size 4 by task xfsaild/dm-0/329
[mar gen  5 16:58:19 2016] =============================================================================
[mar gen  5 16:58:19 2016] BUG xfs_ili (Tainted: G        W      ): kasan: bad access detected
[mar gen  5 16:58:19 2016] -----------------------------------------------------------------------------

[mar gen  5 16:58:19 2016] Disabling lock debugging due to kernel taint
[mar gen  5 16:58:19 2016] INFO: Allocated in kmem_zone_alloc+0x7c/0x180 age=496908 cpu=1 pid=6496
[mar gen  5 16:58:19 2016] 	___slab_alloc.constprop.27+0x383/0x490
[mar gen  5 16:58:19 2016] 	__slab_alloc.isra.24.constprop.26+0x50/0xa0
[mar gen  5 16:58:19 2016] 	kmem_cache_alloc+0x174/0x1b0
[mar gen  5 16:58:19 2016] 	kmem_zone_alloc+0x7c/0x180
[mar gen  5 16:58:19 2016] 	xfs_inode_item_init+0x22/0xb0
[mar gen  5 16:58:19 2016] 	xfs_trans_ijoin+0xa4/0x110
[mar gen  5 16:58:19 2016] 	xfs_ialloc+0x9f9/0x1390
[mar gen  5 16:58:19 2016] 	xfs_dir_ialloc+0x106/0x670
[mar gen  5 16:58:19 2016] 	xfs_create+0x67e/0x1080
[mar gen  5 16:58:19 2016] 	xfs_generic_create+0x375/0x500
[mar gen  5 16:58:19 2016] 	xfs_vn_mknod+0xf/0x20
[mar gen  5 16:58:19 2016] 	xfs_vn_create+0xe/0x10
[mar gen  5 16:58:19 2016] 	vfs_create+0x1ff/0x390
[mar gen  5 16:58:19 2016] 	do_last+0x29a7/0x3900
[mar gen  5 16:58:19 2016] 	path_openat+0x15b/0x730
[mar gen  5 16:58:19 2016] 	do_filp_open+0x170/0x230
[mar gen  5 16:58:19 2016] INFO: Freed in xfs_inode_item_destroy+0x39/0x50 age=0 cpu=3 pid=38
[mar gen  5 16:58:19 2016] 	__slab_free+0x36d/0x510
[mar gen  5 16:58:19 2016] 	kmem_cache_free+0x1ef/0x200
[mar gen  5 16:58:19 2016] 	xfs_inode_item_destroy+0x39/0x50
[mar gen  5 16:58:19 2016] 	xfs_inode_free+0xcd/0x360
[mar gen  5 16:58:19 2016] 	xfs_reclaim_inode+0x54b/0x890
[mar gen  5 16:58:19 2016] 	xfs_reclaim_inodes_ag+0x3e9/0x840
[mar gen  5 16:58:19 2016] 	xfs_reclaim_inodes_nr+0x49/0x60
[mar gen  5 16:58:19 2016] 	xfs_fs_free_cached_objects+0x55/0x80
[mar gen  5 16:58:19 2016] 	super_cache_scan+0x329/0x410
[mar gen  5 16:58:19 2016] 	shrink_slab.part.7+0x2f2/0x530
[mar gen  5 16:58:19 2016] 	shrink_zone+0x7a0/0xae0
[mar gen  5 16:58:19 2016] 	kswapd+0x9ad/0x1110
[mar gen  5 16:58:19 2016] 	kthread+0x218/0x2e0
[mar gen  5 16:58:19 2016] 	ret_from_fork+0x3f/0x70
[mar gen  5 16:58:19 2016] INFO: Slab 0xffffea000d91c800 objects=35 used=29 fp=0xffff880364721c80 flags=0x8000000000004080
[mar gen  5 16:58:19 2016] INFO: Object 0xffff880364721c80 @offset=7296 fp=0xffff880364721560

[mar gen  5 16:58:19 2016] Bytes b4 ffff880364721c70: 03 00 00 00 3f 34 00 00 b8 51 cd 00 01 00 00 00  ....?4...Q......
[mar gen  5 16:58:19 2016] Object ffff880364721c80: 60 15 72 64 03 88 ff ff 00 02 00 00 00 00 ad de  `.rd............
[mar gen  5 16:58:19 2016] Object ffff880364721c90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[mar gen  5 16:58:19 2016] Object ffff880364721ca0: 00 00 3d 5e 03 88 ff ff 60 04 92 5d 03 88 ff ff  ..=^....`..]....
[mar gen  5 16:58:19 2016] Object ffff880364721cb0: 3b 12 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ;...............
[mar gen  5 16:58:19 2016] Object ffff880364721cc0: 30 84 88 86 ff ff ff ff 60 17 6f 87 ff ff ff ff  0.......`.o.....
[mar gen  5 16:58:19 2016] Object ffff880364721cd0: d0 1c 72 64 03 88 ff ff d0 1c 72 64 03 88 ff ff  ..rd......rd....
[mar gen  5 16:58:19 2016] Object ffff880364721ce0: 00 00 00 00 00 00 00 00 68 76 00 00 00 00 00 00  ........hv......
[mar gen  5 16:58:19 2016] Object ffff880364721cf0: 80 6c 40 3e 01 88 ff ff db 4a 00 00 e2 00 00 00  .l@>.....J......
[mar gen  5 16:58:19 2016] Object ffff880364721d00: d6 79 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .y..............
[mar gen  5 16:58:19 2016] Object ffff880364721d10: 00 00 00 00 00 00 00 00                          ........
[mar gen  5 16:58:19 2016] CPU: 0 PID: 329 Comm: xfsaild/dm-0 Tainted: G    B   W       4.4.0-rc8-KASan-01354-g3041cce #6
[mar gen  5 16:58:19 2016] Hardware name: LENOVO 2356LRG/2356LRG, BIOS G7ETA4WW (2.64 ) 10/08/2015
[mar gen  5 16:58:19 2016]  ffff880364720000 ffff88035f2ef968 ffffffff86a2adea ffff88035f498480
[mar gen  5 16:58:19 2016]  ffff88035f2ef998 ffffffff86423ab4 ffff88035f498480 ffffea000d91c800
[mar gen  5 16:58:19 2016]  ffff880364721c80 ffff88013e406c80 ffff88035f2ef9c0 ffffffff86428edf
[mar gen  5 16:58:19 2016] Call Trace:
[mar gen  5 16:58:19 2016]  [<ffffffff86a2adea>] dump_stack+0x4e/0x84
[mar gen  5 16:58:19 2016]  [<ffffffff86423ab4>] print_trailer+0xf4/0x150
[mar gen  5 16:58:19 2016]  [<ffffffff86428edf>] object_err+0x2f/0x40
[mar gen  5 16:58:19 2016]  [<ffffffff8642ab87>] kasan_report_error+0x207/0x530
[mar gen  5 16:58:19 2016]  [<ffffffff8642af6e>] __asan_report_load4_noabort+0x3e/0x40
[mar gen  5 16:58:19 2016]  [<ffffffff87585d00>] ? _raw_spin_lock_irqsave_nested+0x50/0x70
[mar gen  5 16:58:19 2016]  [<ffffffff8684d0c3>] ? xfs_iflush_cluster+0xb73/0xc10
[mar gen  5 16:58:19 2016]  [<ffffffff8684d0c3>] xfs_iflush_cluster+0xb73/0xc10
[mar gen  5 16:58:19 2016]  [<ffffffff8684c760>] ? xfs_iflush_cluster+0x210/0xc10
[mar gen  5 16:58:19 2016]  [<ffffffff86855eda>] xfs_iflush+0x37a/0x5b0
[mar gen  5 16:58:19 2016]  [<ffffffff86855b60>] ? xfs_rename+0xe70/0xe70
[mar gen  5 16:58:19 2016]  [<ffffffff868881ca>] xfs_inode_item_push+0x25a/0x390
[mar gen  5 16:58:19 2016]  [<ffffffff86887f70>] ? xfs_inode_item_unlock+0x80/0x80
[mar gen  5 16:58:19 2016]  [<ffffffff861d28e8>] ? up+0x68/0xb0
[mar gen  5 16:58:19 2016]  [<ffffffff8681c6dd>] ? xfs_buf_unlock+0xd/0x10
[mar gen  5 16:58:19 2016]  [<ffffffff8689fa4b>] xfsaild+0x8fb/0x1500
[mar gen  5 16:58:19 2016]  [<ffffffff861ddbac>] ? trace_hardirqs_on_caller+0x28c/0x5e0
[mar gen  5 16:58:19 2016]  [<ffffffff8689f150>] ? xfs_trans_ail_cursor_first+0x1a0/0x1a0
[mar gen  5 16:58:19 2016]  [<ffffffff8689f150>] ? xfs_trans_ail_cursor_first+0x1a0/0x1a0
[mar gen  5 16:58:19 2016]  [<ffffffff8615f3b8>] kthread+0x218/0x2e0
[mar gen  5 16:58:19 2016]  [<ffffffff8615f1a0>] ? kthread_create_on_node+0x460/0x460
[mar gen  5 16:58:19 2016]  [<ffffffff8615f1a0>] ? kthread_create_on_node+0x460/0x460
[mar gen  5 16:58:19 2016]  [<ffffffff87586c2f>] ret_from_fork+0x3f/0x70
[mar gen  5 16:58:19 2016]  [<ffffffff8615f1a0>] ? kthread_create_on_node+0x460/0x460
[mar gen  5 16:58:19 2016] Memory state around the buggy address:
[mar gen  5 16:58:19 2016]  ffff880364721c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[mar gen  5 16:58:19 2016]  ffff880364721c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[mar gen  5 16:58:19 2016] >ffff880364721d00: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
[mar gen  5 16:58:19 2016]                          ^
[mar gen  5 16:58:19 2016]  ffff880364721d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[mar gen  5 16:58:19 2016]  ffff880364721e00: fc fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb
[mar gen  5 16:58:19 2016] ==================================================================


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQJ8BAEBCgBmBQJWi++/XxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQTQyRTkzNjBCNzVERDZFODMyNTQ3RjdB
NDMwOTA3NUYwNTk2MEY2AAoJEKQwkHXwWWD27ugP/iUDMhh2eDeuCMr8PUk25kIO
oJVwB7Z2pFSpR97J8W6/fwzDUrZJyiKYDG6pDVaet3mzXqvrbj5wLXcd7UNM4bdU
R6KbhzHUUgpXBOXKsEJXGvqN012fdgb9LbS9EoQLnu926VIvdnnbahJtqU2aj5nB
95zQCA7K//Lc72Z7tbiWtKlb9V5SzhFwSFKAazhHJWuQxNvGRgFNOq7uYLPpnHRK
Vl5Agsnd7EMRQgTLShd+k9FokkXuk1JqKrPm7xfXWG7TVbMla4Now3KvgicdZ3UQ
/vp2O4SeS8EJ2FVyxIYvEIVmxmlzJWvix7BzDo9b3rNVt+SOAJLuyJa9ESZ7bID2
EqIrFKiWCQ2A9N+646E5EFWyHK7Hyj3x5PAppmO14gHWakiaPIkmrOpkydx8Be+r
l2toPev8wEiVQwIlvterKOZRnliTCk1LRq3pPm3sy+Cd+eb1erwDGFU0yAuJ/Y7U
HoQtgBWnC+j+yZpWrmxIFwpwfFTKmpoeT3Tx3gFuuSexQ9nPYPPqcmMmLFvN5fUS
ZuUXn6bX2ZPFQY339ekS6MMXZDU9mHGbr0krVf9AltjONC+G41D6rgeeUD6dgSUX
ECDvXhGli56ZmQ5LrOoa/9L8EeG+FahhcWAC/9CVF0OXyXaKWX0oMqKVc9bHcEcO
fVlrxZ2Q3kr6ubvDOa51
=g97u
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--


--===============9183989191785648979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9183989191785648979==--
