Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH1oojg149970 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 19:50:50 -0600
Received: from server42.dayanadns.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42AD91C4CB1C
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 17:52:22 -0800 (PST)
Received: from server42.dayanadns.com (server42.dayanadns.com [209.5.159.9])
	by cuda.sgi.com with ESMTP id Cf9xnakoAFdxUpVl for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 17:52:22 -0800 (PST)
Received: from mn-10k-dhcp1-3536.dsl.hickorytech.net ([69.24.173.208]:55148
	helo=[10.0.0.7])
	by server42.dayanadns.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <jeffrey.hundstad@mnsu.edu>)
	id 1PIXC7-0000B4-0C
	for xfs@oss.sgi.com; Tue, 16 Nov 2010 17:52:20 -0800
Message-ID: <4CE33550.1040302@mnsu.edu>
Date: Tue, 16 Nov 2010 19:52:16 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: WARNING: at fs/xfs/linux-2.6/xfs_aops.c:1289
	xfs_vm_releasepage+0x32/0x41()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I'm not sure if this is interesting at all.  Let me know if it is, I can 
do bisects if needed, let me know which config additions you need for 
debugging.

The warning happens during a Debian/Sid "aptitude update."  It doesn't 
happen on linux-2.6.34.6 but it does on linux-2.6.36 and linux-2.6.37-rc2.


Here's the WARNING.  Config, and full dmesg at:
http://krypton.mnsu.edu/~j3gum/linux-error-20101116/

------------[ cut here ]------------
WARNING: at fs/xfs/linux-2.6/xfs_aops.c:1289 xfs_vm_releasepage+0x32/0x41()
Hardware name: OptiPlex GX110
Modules linked in: nf_conntrack_ftp ipt_MASQUERADE iptable_nat ip_tables 
nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 microcode 
8250_pnp rtc_cmos e100 8250 rtc_core floppy serial_core processor 
rtc_lib mii button
Pid: 234, comm: kswapd0 Not tainted 2.6.37-rc2 #1
Call Trace:
  [<c1019687>] ? warn_slowpath_common+0x7c/0x8f
  [<c10dbdcc>] ? xfs_vm_releasepage+0x32/0x41
  [<c10dbdcc>] ? xfs_vm_releasepage+0x32/0x41
  [<c10196b5>] ? warn_slowpath_null+0x1b/0x1e
  [<c10dbdcc>] ? xfs_vm_releasepage+0x32/0x41
  [<c1046672>] ? try_to_release_page+0x2c/0x3c
  [<c104fc12>] ? shrink_page_list+0x47d/0x5e3
  [<c104ea7a>] ? isolate_lru_pages+0x64/0x1cf
  [<c104fee4>] ? shrink_inactive_list+0x16c/0x1f3
  [<c1050272>] ? shrink_zone+0x307/0x3af
  [<c10506c6>] ? kswapd+0x3ac/0x574
  [<c102b335>] ? autoremove_wake_function+0x0/0x31
  [<c105031a>] ? kswapd+0x0/0x574
  [<c102b15f>] ? kthread+0x62/0x67
  [<c102b0fd>] ? kthread+0x0/0x67
  [<c1002b16>] ? kernel_thread_helper+0x6/0x10
---[ end trace 8b9e3e1349c73905 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
