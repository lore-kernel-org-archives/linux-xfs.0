Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E27D97F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 09:07:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62D8BAC004
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 07:07:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0G9qilMpayx4JQPB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 07:07:07 -0700 (PDT)
Date: Sun, 12 Oct 2014 10:07:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: dmesg error in xfs_aops.c on kernel 3.14.21
Message-ID: <20141012140704.GA35667@bfoster.bfoster>
References: <54397E0F.2050700@sbcglobal.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54397E0F.2050700@sbcglobal.net>
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
To: BillStuff <billstuff2001@sbcglobal.net>
Cc: xfs@oss.sgi.com

On Sat, Oct 11, 2014 at 01:59:27PM -0500, BillStuff wrote:
> Hi,
> 
> I'm running 3.14.21, and got these traces in dmesg; they appear to be from
> xfs:
> 
> [56180.816526] ------------[ cut here ]------------
> [56180.816550] WARNING: CPU: 5 PID: 67 at fs/xfs/xfs_aops.c:1172


	if (WARN_ON(delalloc))
		return 0;

So this generally looks like stale delalloc blocks on a page that is
reclaimed/invalidated or otherwise expected to be clean. We've been
seeing this a lot over the past few kernel releases and there have been
a variety of fixes in error paths and such so it's hard to say precisely
what might be causing this. Some examples:

aad3f375 xfs: xfs_vm_write_end truncates too much on failure
72ab70a1 xfs: write failure beyond EOF truncates too much data
4ab9ed57 xfs: kill buffers over failed write ranges properly

It looks like those are in the stable tree as of 3.15, so you could give
that a try and see if it helps. Otherwise, can you post xfs_info for the
filesytem? Do you have particular workloads or sequences of operations
that tend to reproduce this?

Brian

> xfs_vm_releasepage+0x9e/0xb0 [xfs]()
> [56180.816551] Modules linked in: bsd_comp ppp_synctty ppp_async crc_ccitt
> ppp_generic slhc nvidia(PO) nct6775 hwmon_vid nfsd ipv6 ipt_MASQUERADE
> xt_conntrack iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack iptable_filter ip_tables x_tables pcmcia pcmcia_core nls_utf8
> isofs agpgart fuse or51132 snd_usb_audio snd_usbmidi_lib cx88_dvb
> videobuf_dvb dvb_core cx88_vp3054_i2c snd_hwdep snd_pcm ir_mce_kbd_decoder
> ir_lirc_codec lirc_dev ir_sony_decoder ir_nec_decoder ir_sanyo_decoder
> ir_rc6_decoder ir_rc5_decoder ir_jvc_decoder snd_rawmidi rc_hauppauge
> tuner_simple tuner_types tda9887 tda8290 tuner snd_seq_device
> x86_pkg_temp_thermal snd_timer coretemp cx8800 kvm_intel cx8802 cx88xx
> tveeprom btcx_risc videobuf_dma_sg videobuf_core snd i2c_algo_bit rc_core
> kvm crc32c_intel v4l2_common i2c_dev usb_storage r8169 videodev i2c_i801
> processor microcode soundcore thermal_sys i2c_core mii lpc_ich hwmon
> mfd_core evdev mxm_wmi wmi button loop hid_generic xhci_hcd uhci_hcd
> ohci_hcd ehci_pci ehci_hcd usbhid hid pata_jmicron xfs ext3 jbd ext2 mbcache
> raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor
> async_tx [last unloaded: nvidia]
> [56180.816581] CPU: 5 PID: 67 Comm: kswapd0 Tainted: P           O
> 3.14.21be-dirty #1
> [56180.816582] Hardware name: System manufacturer System Product
> Name/SABERTOOTH X79, BIOS 4608 12/24/2013
> [56180.816583]  00000000 00000000 e8ff5d48 c14d69b3 00000000 e8ff5d78
> c104348e c15d9f44
> [56180.816586]  00000005 00000043 f3b72e77 00000494 f3afbdbe f3afbdbe
> f3afbd20 00000000
> [56180.816588]  edcd43c0 e8ff5d88 c1043552 00000009 00000000 e8ff5db0
> f3afbdbe 00000000
> [56180.816590] Call Trace:
> [56180.816594]  [<c14d69b3>] dump_stack+0x41/0x52
> [56180.816597]  [<c104348e>] warn_slowpath_common+0x7e/0xa0
> [56180.816604]  [<f3afbdbe>] ? xfs_vm_releasepage+0x9e/0xb0 [xfs]
> [56180.816609]  [<f3afbdbe>] ? xfs_vm_releasepage+0x9e/0xb0 [xfs]
> [56180.816615]  [<f3afbd20>] ? xfs_count_page_state+0x60/0x60 [xfs]
> [56180.816616]  [<c1043552>] warn_slowpath_null+0x22/0x30
> [56180.816621]  [<f3afbdbe>] xfs_vm_releasepage+0x9e/0xb0 [xfs]
> [56180.816627]  [<f3afbd20>] ? xfs_count_page_state+0x60/0x60 [xfs]
> [56180.816629]  [<c10ebdd3>] try_to_release_page+0x33/0x50
> [56180.816632]  [<c10fbfca>] shrink_active_list+0x28a/0x290
> [56180.816634]  [<c10fc453>] shrink_zone+0x483/0x6f0
> [56180.816636]  [<c10f8f49>] ? zone_balanced+0x29/0x70
> [56180.816637]  [<c10fcfae>] kswapd+0x3fe/0x890
> [56180.816639]  [<c10fcbb0>] ? try_to_free_pages+0x4f0/0x4f0
> [56180.816642]  [<c1060121>] kthread+0xa1/0xc0
> [56180.816644]  [<c14dd137>] ret_from_kernel_thread+0x1b/0x28
> [56180.816646]  [<c1060080>] ? kthread_create_on_node+0x110/0x110
> [56180.816647] ---[ end trace f7821664f1bc8f4b ]---
> [56180.821101] ------------[ cut here ]------------
> [56180.821109] WARNING: CPU: 5 PID: 67 at fs/xfs/xfs_aops.c:1172
> xfs_vm_releasepage+0x9e/0xb0 [xfs]()
> [56180.821110] Modules linked in: bsd_comp ppp_synctty ppp_async crc_ccitt
> ppp_generic slhc nvidia(PO) nct6775 hwmon_vid nfsd ipv6 ipt_MASQUERADE
> xt_conntrack iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack iptable_filter ip_tables x_tables pcmcia pcmcia_core nls_utf8
> isofs agpgart fuse or51132 snd_usb_audio snd_usbmidi_lib cx88_dvb
> videobuf_dvb dvb_core cx88_vp3054_i2c snd_hwdep snd_pcm ir_mce_kbd_decoder
> ir_lirc_codec lirc_dev ir_sony_decoder ir_nec_decoder ir_sanyo_decoder
> ir_rc6_decoder ir_rc5_decoder ir_jvc_decoder snd_rawmidi rc_hauppauge
> tuner_simple tuner_types tda9887 tda8290 tuner snd_seq_device
> x86_pkg_temp_thermal snd_timer coretemp cx8800 kvm_intel cx8802 cx88xx
> tveeprom btcx_risc videobuf_dma_sg videobuf_core snd i2c_algo_bit rc_core
> kvm crc32c_intel v4l2_common i2c_dev usb_storage r8169 videodev i2c_i801
> processor microcode soundcore thermal_sys i2c_core mii lpc_ich hwmon
> mfd_core evdev mxm_wmi wmi button loop hid_generic xhci_hcd uhci_hcd
> ohci_hcd ehci_pci ehci_hcd usbhid hid pata_jmicron xfs ext3 jbd ext2 mbcache
> raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor
> async_tx [last unloaded: nvidia]
> [56180.821137] CPU: 5 PID: 67 Comm: kswapd0 Tainted: P        W  O
> 3.14.21be-dirty #1
> [56180.821138] Hardware name: System manufacturer System Product
> Name/SABERTOOTH X79, BIOS 4608 12/24/2013
> [56180.821138]  00000000 00000000 e8ff5d48 c14d69b3 00000000 e8ff5d78
> c104348e c15d9f44
> [56180.821140]  00000005 00000043 f3b72e77 00000494 f3afbdbe f3afbdbe
> f3afbd20 00000000
> [56180.821143]  f07f2660 e8ff5d88 c1043552 00000009 00000000 e8ff5db0
> f3afbdbe 00000000
> [56180.821145] Call Trace:
> [56180.821146]  [<c14d69b3>] dump_stack+0x41/0x52
> [56180.821148]  [<c104348e>] warn_slowpath_common+0x7e/0xa0
> [56180.821154]  [<f3afbdbe>] ? xfs_vm_releasepage+0x9e/0xb0 [xfs]
> [56180.821160]  [<f3afbdbe>] ? xfs_vm_releasepage+0x9e/0xb0 [xfs]
> [56180.821165]  [<f3afbd20>] ? xfs_count_page_state+0x60/0x60 [xfs]
> [56180.821167]  [<c1043552>] warn_slowpath_null+0x22/0x30
> [56180.821172]  [<f3afbdbe>] xfs_vm_releasepage+0x9e/0xb0 [xfs]
> [56180.821177]  [<f3afbd20>] ? xfs_count_page_state+0x60/0x60 [xfs]
> [56180.821179]  [<c10ebdd3>] try_to_release_page+0x33/0x50
> [56180.821181]  [<c10fbfca>] shrink_active_list+0x28a/0x290
> [56180.821182]  [<c10fc453>] shrink_zone+0x483/0x6f0
> [56180.821184]  [<c10f8f49>] ? zone_balanced+0x29/0x70
> [56180.821186]  [<c10fcfae>] kswapd+0x3fe/0x890
> [56180.821188]  [<c10fcbb0>] ? try_to_free_pages+0x4f0/0x4f0
> [56180.821189]  [<c1060121>] kthread+0xa1/0xc0
> [56180.821191]  [<c14dd137>] ret_from_kernel_thread+0x1b/0x28
> [56180.821192]  [<c1060080>] ? kthread_create_on_node+0x110/0x110
> [56180.821193] ---[ end trace f7821664f1bc8f4c ]---
> 
> Can anyone tell me what these mean and if they might be bad?
> 
> thanks,
> Bill
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
