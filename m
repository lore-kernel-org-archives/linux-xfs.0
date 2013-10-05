Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C4967F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 19:52:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45F7E8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 17:52:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TADJFhEZvmvg9hEV for
	<xfs@oss.sgi.com>; Fri, 04 Oct 2013 17:52:19 -0700 (PDT)
Date: Fri, 4 Oct 2013 20:52:10 -0400
From: Dave Jones <davej@redhat.com>
Subject: fs/attr.c:notify_change locking warning.
Message-ID: <20131005005210.GA25773@redhat.com>
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
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

WARNING: CPU: 3 PID: 26128 at fs/attr.c:178 notify_change+0x34d/0x360()
Modules linked in: dlci 8021q garp sctp snd_seq_dummy bridge stp tun fuse rfcomm hidp ipt_ULOG nfc caif_socket caif af_802154 phonet af_rxrpc bnep bluetooth rfkill can_bcm can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds scsi_transport_iscsi nfnetlink af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_hdmi xfs snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc libcrc32c snd_timer crct10dif_pclmul crc32c_intel snd ghash_clmulni_intel e1000e microcode usb_debug serio_raw pcspkr ptp soundcore pps_core shpchp
CPU: 3 PID: 26128 Comm: trinity-child57 Not tainted 3.12.0-rc3+ #93 
 ffffffff81a3e2ec ffff880071d71bb8 ffffffff8172a763 0000000000000000
 ffff880071d71bf0 ffffffff810552cd 0000000000000a00 ffff88023d6e8b90
 0000000000008ad0 ffff880071d71c50 ffff8802392882c8 ffff880071d71c00
Call Trace:
 [<ffffffff8172a763>] dump_stack+0x4e/0x82
 [<ffffffff810552cd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff810553aa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811e388d>] notify_change+0x34d/0x360
 [<ffffffff811e18e7>] file_remove_suid+0x87/0xa0
 [<ffffffff811e9019>] ? __mnt_drop_write+0x29/0x50
 [<ffffffff811e90a2>] ? __mnt_drop_write_file+0x12/0x20
 [<ffffffff811e1e6a>] ? file_update_time+0x8a/0xd0
 [<ffffffffa01a4e7a>] xfs_file_aio_write_checks+0xea/0xf0 [xfs]
 [<ffffffffa01a4f50>] xfs_file_dio_aio_write+0xd0/0x3e0 [xfs]
 [<ffffffffa01a5629>] xfs_file_aio_write+0x129/0x130 [xfs]
 [<ffffffff811c45dc>] do_sync_readv_writev+0x4c/0x80
 [<ffffffff811c5aab>] do_readv_writev+0xbb/0x240
 [<ffffffffa01a5500>] ? xfs_file_buffered_aio_write+0x2a0/0x2a0 [xfs]
 [<ffffffff811c4500>] ? do_sync_read+0x90/0x90
 [<ffffffff81734721>] ? _raw_spin_unlock+0x31/0x60
 [<ffffffff810c9a86>] ? trace_hardirqs_on_caller+0x16/0x1e0
 [<ffffffff811c5cc8>] vfs_writev+0x38/0x60
 [<ffffffff811c5e10>] SyS_writev+0x50/0xd0
 [<ffffffff8173d8e4>] tracesys+0xdd/0xe2
---[ end trace 201843ae71ab5a7c ]---


177 
178         WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
179 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
