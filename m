Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3GHBNHM148066 for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 12:11:23 -0500
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48A143E6B01
	for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 10:14:46 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id zG4aRYIlbAXu7BZ0 for
	<xfs@oss.sgi.com>; Sat, 16 Apr 2011 10:14:46 -0700 (PDT)
Received: from grubbs.orbis-terrarum.net (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.gentoo.org (Postfix) with ESMTPS id E81441B4056
	for <xfs@oss.sgi.com>; Sat, 16 Apr 2011 17:14:45 +0000 (UTC)
Date: Sat, 16 Apr 2011 17:14:43 +0000
From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: xfs_perag_put NULL deference BUG
Message-ID: <robbat2-20110416T163639-343099416Z@orbis-terrarum.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, robbat2@gentoo.org

(Please CC, not subscribed)

I have an archival setup that makes heavy use of hardlinks, and recently, it
started needing inode64 (refused to create any more files until I remounted w/
inode64), and shortly thereafter it went really bad and now after making some
new files, I get this OOPS and write access to any XFS filesystem on the
machine stops.

xfs_check and xfs_repair claim the filesystem is fine, so I wonder if I've just
run into some corner-case.

Filesystem stats:
Approx 120K inodes, 6M files.
Allocated space: 900GiB (on LVM, single volume)
Actual size: 787GiB
Apparent size: 23.5TiB
Hardlink count per inode: mean 51, mode 116, median 33, max 595, min 1.

[ 5674.213688] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
[ 5674.214095] IP: [<ffffffff812391fc>] xfs_perag_put+0x14/0x6d
[ 5674.214305] PGD 229e7b000 
[ 5674.214506] Oops: 0002 [#1] SMP 
[ 5674.214708] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.4/0000:0d:00.0/net/eth0/broadcast
[ 5674.215108] CPU 0 
[ 5674.215113] Modules linked in: xt_comment sch_htb nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ipt_addrtype xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_hashlimit xt_conntrack xt_DSCP xt_NFQUEUE xt_mark xt_connmark nf_conntrack ip_tables ipv6 evdev tpm_tis i2c_i801 container tpm iTCO_wdt sg i2c_core tpm_bios processor thermal iTCO_vendor_support thermal_sys ghes hed i3200_edac hwmon button edac_core
[ 5674.216585] 
[ 5674.216782] Pid: 26699, comm: rsync Not tainted 2.6.36-hardened-r4-infra17 #3 X7SBi/X7SBi
[ 5674.217180] RIP: 0010:[<ffffffff812391fc>]  [<ffffffff812391fc>] xfs_perag_put+0x14/0x6d
[ 5674.217452] RSP: 0018:ffff8801a54556c8  EFLAGS: 00010292
[ 5674.217452] RAX: 00000000ffffffff RBX: ffff8801794498c8 RCX: 0000000000000000
[ 5674.217452] RDX: ffff8801a5455864 RSI: 0000000000000004 RDI: 0000000000000000
[ 5674.217452] RBP: ffff8801a54556f8 R08: ffff8801a54556f8 R09: 0000000000000000
[ 5674.217452] R10: ffffffff8123e232 R11: 0000000000000001 R12: ffff8801794497c0
[ 5674.217452] R13: 0000000000000000 R14: ffff8801a5455978 R15: ffff88022d62bc00
[ 5674.217452] FS:  000002a093f506f0(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
[ 5674.217452] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5674.217452] CR2: 000000000000000c CR3: 0000000001638000 CR4: 00000000000006f0
[ 5674.217452] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5674.217452] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5674.217452] Process rsync (pid: 26699, threadinfo ffff8801a5454000, task ffff88022960f570)
[ 5674.217452] Stack:
[ 5674.217452]  00000004a54556f8 ffff8801794498c8 ffff8801794497c0 0000000000000000
[ 5674.217452] <0> ffff8801a5455978 ffff88022d62bc00 ffff8801a5455788 ffffffff8120ef52
[ 5674.217452] <0> ffff8801a5455738 0000ffff810b6ebd ffff88022960fad8 ffff8801a5455864
[ 5674.217452] Call Trace:
[ 5674.217452]  [<ffffffff8120ef52>] xfs_bmap_btalloc_nullfb+0x20e/0x2b4
[ 5674.217452]  [<ffffffff810b77a5>] ? find_or_create_page+0x31/0x85
[ 5674.217452]  [<ffffffff8120f1e7>] xfs_bmap_btalloc+0x1ef/0x5b8
[ 5674.217452]  [<ffffffff8120abe5>] ? xfs_bmap_search_multi_extents+0x63/0xda
[ 5674.217452]  [<ffffffff8120f5b9>] xfs_bmap_alloc+0x9/0xb
[ 5674.217452]  [<ffffffff8121146f>] xfs_bmapi+0x6c2/0xd62
[ 5674.217452]  [<ffffffff812462b6>] ? xfs_buf_rele+0xe6/0xf2
[ 5674.217452]  [<ffffffff8121b965>] xfs_dir2_grow_inode+0x11d/0x32b
[ 5674.217452]  [<ffffffff8124d8f6>] ? xfs_setup_inode+0x244/0x24d
[ 5674.217452]  [<ffffffff81242a09>] ? kmem_free+0x26/0x2f
[ 5674.217452]  [<ffffffff812285ec>] ? xfs_idata_realloc+0x3f/0x109
[ 5674.217452]  [<ffffffff8121c538>] xfs_dir2_sf_to_block+0xda/0x5ae
[ 5674.217452]  [<ffffffff81613956>] ? _raw_spin_lock+0x9/0xd
[ 5674.217452]  [<ffffffff812234bb>] xfs_dir2_sf_addname+0x1d8/0x507
[ 5674.217452]  [<ffffffff810eb1cd>] ? kmem_cache_alloc+0x193/0x1fe
[ 5674.217452]  [<ffffffff8121c332>] xfs_dir_createname+0xee/0x15a
[ 5674.217452]  [<ffffffff81240203>] xfs_link+0x1f1/0x293
[ 5674.217452]  [<ffffffff8124d36f>] xfs_vn_link+0x3a/0x62
[ 5674.217452]  [<ffffffff810fce7f>] vfs_link+0xfd/0x186
[ 5674.217452]  [<ffffffff81100384>] sys_linkat+0x10a/0x183
[ 5674.217452]  [<ffffffff810f6b02>] ? sys_newlstat+0x2c/0x3b
[ 5674.217452]  [<ffffffff81100416>] sys_link+0x19/0x1b
[ 5674.217452]  [<ffffffff810035a7>] system_call_fastpath+0x16/0x1b
[ 5674.217452] Code: 0e 98 00 00 41 3b 5c 24 70 72 d0 5f 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 83 c8 ff 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <f0> 0f c1 47 0c 71 05 89 47 0c cd 04 83 3d 59 d6 84 00 00 44 8d 
[ 5674.217452] RIP  [<ffffffff812391fc>] xfs_perag_put+0x14/0x6d
[ 5674.217452]  RSP <ffff8801a54556c8>
[ 5674.217452] CR2: 000000000000000c
[ 5674.217452] ---[ end trace 9c6412348052de21 ]---

The following are the only changes to XFS in the hardened kernel patchset. I
don't think they should cause any problems. But I wanted to be clear as to what
code I was running.

diff -Nuar linux-2.6.36.4/fs/xfs/linux-2.6/xfs_ioctl.c linux-2.6.36-hardened-r4/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.36.4/fs/xfs/linux-2.6/xfs_ioctl.c	2010-10-20 20:30:22.000000000 +0000
+++ linux-2.6.36-hardened-r4/fs/xfs/linux-2.6/xfs_ioctl.c	2010-12-02 19:32:15.000000000 +0000
@@ -127,7 +127,7 @@
 	}
 
 	error = -EFAULT;
-	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
+	if (hsize > sizeof(handle) || copy_to_user(hreq->ohandle, &handle, hsize) ||
 	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32)))
 		goto out_put;
 
@@ -416,7 +416,7 @@
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
+	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
 	if (!kbuf)
 		goto out_dput;
 
diff -Nuar linux-2.6.36.4/fs/xfs/linux-2.6/xfs_iops.c linux-2.6.36-hardened-r4/fs/xfs/linux-2.6/xfs_iops.c
--- linux-2.6.36.4/fs/xfs/linux-2.6/xfs_iops.c	2010-10-20 20:30:22.000000000 +0000
+++ linux-2.6.36-hardened-r4/fs/xfs/linux-2.6/xfs_iops.c	2010-12-02 19:32:15.000000000 +0000
@@ -472,7 +472,7 @@
 	struct nameidata *nd,
 	void		*p)
 {
-	char		*s = nd_get_link(nd);
+	const char	*s = nd_get_link(nd);
 
 	if (!IS_ERR(s))
 		kfree(s);
diff -Nuar linux-2.6.36.4/fs/xfs/xfs_bmap.c linux-2.6.36-hardened-r4/fs/xfs/xfs_bmap.c
--- linux-2.6.36.4/fs/xfs/xfs_bmap.c	2010-10-20 20:30:22.000000000 +0000
+++ linux-2.6.36-hardened-r4/fs/xfs/xfs_bmap.c	2010-12-02 19:32:15.000000000 +0000
@@ -287,7 +287,7 @@
 	int			nmap,
 	int			ret_nmap);
 #else
-#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
+#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap) do {} while (0)
 #endif /* DEBUG */
 
 STATIC int


-- 
Robin Hugh Johnson
Gentoo Linux: Developer, Trustee & Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
