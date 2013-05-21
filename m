Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D2B5529DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:53:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C32BA304039
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:53:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ju0sd5cpxFIDCEh6 for
	<xfs@oss.sgi.com>; Tue, 21 May 2013 15:53:02 -0700 (PDT)
Date: Tue, 21 May 2013 18:52:57 -0400
From: Dave Jones <davej@redhat.com>
Subject: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130521225257.GA12713@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com

[  464.210598] XFS: Assertion failed: (mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID| ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 719
[  464.235108] ------------[ cut here ]------------
[  464.240898] kernel BUG at fs/xfs/xfs_message.c:108!
[  464.247024] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  464.254763] Modules linked in: hidp bnep af_key can_bcm caif_socket caif rose netrom phonet af_rxrpc rfcomm llc2 bluetooth can_raw pppoe can pppox ppp_generic slhc nfnetlink decnet scsi_transport_iscsi irda appletalk ipx crc_ccitt p8023 x25 nfc rds psnap p8022 llc rfkill ipt_ULOG atm ax25 nfsv3 nfs_acl nfs lockd sunrpc fscache xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq e1000e snd_seq_device snd_pcm ptp snd_page_alloc pps_core snd_timer snd soundcore i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[  464.320028] CPU: 3 PID: 26139 Comm: trinity-child3 Not tainted 3.10.0-rc2+ #1
[  464.348866] task: ffff880240858000 ti: ffff88020527e000 task.ti: ffff88020527e000
[  464.358249] RIP: 0010:[<ffffffffa02d4122>]  [<ffffffffa02d4122>] assfail+0x22/0x30 [xfs]
[  464.368418] RSP: 0018:ffff88020527fdd0  EFLAGS: 00010282
[  464.375069] RAX: 00000000000000cd RBX: ffff880215ff8840 RCX: 0000000000000006
[  464.384021] RDX: 00000000000044a0 RSI: ffff880240858758 RDI: ffff880240858000
[  464.392977] RBP: ffff88020527fdd0 R08: 0000000000000000 R09: 0000000000000000
[  464.401932] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88020527fe90
[  464.410877] R13: ffff880240bc0000 R14: 0000000000000000 R15: 0000000000000000
[  464.419829] FS:  00007ffec576d740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[  464.429972] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  464.437192] CR2: 00000000021c0ca8 CR3: 000000020326a000 CR4: 00000000001407e0
[  464.446124] DR0: 0000000041d84849 DR1: 0000000000000000 DR2: 0000000000000000
[  464.455072] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  464.464026] Stack:
[  464.466569]  ffff88020527fe30 ffffffffa02d2019 ffffffff8167ebb1 ffff880215ff8b00
[  464.475929]  ffff880200000a09 ffffffff00000a09 ffffffff811a7fb1 0000000000000a09
[  464.485304]  ffff8802124a4940 0000000000008bc7 ffff88020527fe90 ffff880215ff8b00
[  464.494646] Call Trace:
[  464.497724]  [<ffffffffa02d2019>] xfs_setattr_size+0xb9/0x5d0 [xfs]
[  464.505598]  [<ffffffff8167ebb1>] ? sub_preempt_count+0x71/0x100
[  464.514096]  [<ffffffff811a7fb1>] ? do_truncate+0x61/0xa0
[  464.521833]  [<ffffffffa02d2566>] xfs_vn_setattr+0x36/0x40 [xfs]
[  464.530331]  [<ffffffff811c6f1c>] notify_change+0x1dc/0x360
[  464.538268]  [<ffffffff811a7fbd>] do_truncate+0x6d/0xa0
[  464.545765]  [<ffffffff811a814c>] vfs_truncate+0x15c/0x180
[  464.553600]  [<ffffffff811a81dc>] do_sys_truncate+0x6c/0x90
[  464.561530]  [<ffffffff811a836e>] SyS_truncate+0xe/0x10
[  464.569033]  [<ffffffff81683094>] tracesys+0xdd/0xe2
[  464.576203] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 48 17 36 a0 31 ff 31 c0 e8 ce fb ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 
[  464.603000] RIP  [<ffffffffa02d4122>] assfail+0x22/0x30 [xfs]
[  464.611215]  RSP <ffff88020527fdd0>
[  464.620153] ---[ end trace 56da871d7d2d94aa ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
