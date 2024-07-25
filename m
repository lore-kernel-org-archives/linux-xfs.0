Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990343BBC2
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 23:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721951779; cv=none; b=Qu9EJlV2+5XbOXcXc+fmcrxkFs/mWTDLYz9Z8c8KCXRx029BeyCSBTV3EMpf/pNS+jxKPYvbJyEVMnPARdIjmZFuct3o3UFOJ1dmZxlnIJBZKwwJXBEGhm7D7UJqLU+JBqWbCVDv9KqdwJ0ZKAgmDjlEPkdXlPAaFjwYkHQqxe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721951779; c=relaxed/simple;
	bh=ekbz6pqPDln03VIcCmuUHo5E6zQCC20MU+aiFMj7AgQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cBn2Sx5DFPmH+WkQXS2gyTeF+W//Q4JRJmoAa5xUhgeGj960VPK5YO/BQeHcK8FpcTPZShfAl9306lDhQUbPKjXJPN9RPlxFhuJ701EnGdOhCvsCie+6rU0z0ZWyBOsmgYVnotPyKNvF4/JpqYJnE2DfCR6vOzR4AJfonCN8s3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ess5c1Og; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ess5c1Og"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-36844375001so831148f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 16:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721951774; x=1722556574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0F2gh5PJh2Oegyehs6PNMuS+QGVtid8bRvr8mmR77Fs=;
        b=ess5c1OgWsvykfy+VJwRg4SJp8y8e1TEb8jMtUOuapHbGc0yI3yY0rTF82uR6vfVy+
         PHUnMK1ard60a24ju1TC1aN7XcRhjS1ndIUBakeIAIxrKVAkHgfTwBDfozutfUFTIZ7y
         TRfbcMYdPrIMUHJHaaF6FpUAWRJ3j+sHg4yfwGTSXKDgU9Ge6kduJ1Vp1NSejF/W3e2Z
         2jsJEraa5levrfc57R1odfRzbEqt8XNiCjpjCU1f4spz1io6qJ7El4AsWRgFIjsngTEV
         0WujKX32NTmGO8DMrG8kiE9Rv3Q98yILRulkOf2xdpIhW1AHF2Hym6nSaZaX87aBjv7O
         JYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721951774; x=1722556574;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0F2gh5PJh2Oegyehs6PNMuS+QGVtid8bRvr8mmR77Fs=;
        b=SZqzwMGFkT1BGqPAHkrR2YxAOXtopTvb5o5+Wh2na0z78DEMHmug+XhNOeyJXRlX8V
         DxajJG2M1W8s4gzNDEXOxC/1RYxt6dyrNFcX075Fy2ANMAHLbM5jV/EY8ouHIE8m1W9K
         B1OhdCUzR6L/QfYF1QYV896A6WT0fX8kQUujrHHGRxTcj76ZnreqrwzrF+/LGEMgONFr
         KRHqdtctlLkWklxq6Kkz6iwZzWQpWMFBXGnTqOv+63iE3iF8clsEnkHIm3TmkLz4/hkG
         +mAp75hOb4Ato5nZtJgrTNuoqL2dI48rabHL3nMmzcIvteC2kRVDlkdcnnJH/6Rbz6sD
         o6OA==
X-Gm-Message-State: AOJu0YxHs5LHIhuOOcj20MX52cRBaLP1AqiCV4yUtg7K9ORo3PtaDHFp
	20m49iWHmv9ynQw4sYoPYRAiGcxFk0naM3YtLwkd3Dih0wzlvg4ITWVoZZFj
X-Google-Smtp-Source: AGHT+IH369M+GbWh90cqj5bxyyi8HZqLgXcun8LPFtRDK+hAUvAoewXFCYLGUMlZ1vLnqAog/dceAw==
X-Received: by 2002:a5d:4d07:0:b0:368:7edd:cd80 with SMTP id ffacd0b85a97d-36b319e6b25mr3219633f8f.20.1721951774131;
        Thu, 25 Jul 2024 16:56:14 -0700 (PDT)
Received: from anton-latitude (c-67-166-97-155.hsd1.ut.comcast.net. [67.166.97.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42808f684d0sm29554245e9.6.2024.07.25.16.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 16:56:13 -0700 (PDT)
Date: Thu, 25 Jul 2024 17:56:10 -0600
From: Anton Eidelman <anton.eidelman@gmail.com>
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org
Subject: [BUG] xfs: soft lockup in xas_descend/xas_load/xas_next from
 filemap_get_read_batch (rclone) on 6.8 kernel
Message-ID: <20240725235610.GA1669344@anton-latitude>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

We observe a consistent soft lockup while running rclone from and XFS volum=
e.
The call trace (samples below) look identical the ones reported on 6.8.0 in
https://lore.kernel.org/linux-mm/ZcVH+FzS3NaCrsqe@dread.disaster.area/T/
We see in with ubuntu kernel 6.8.0-38-generic and 6.9.

The CPU seems to be spinning and the three samples below hit xas_descend, x=
as_load, and __xas_next.

This also looks just like the one reported here:
https://lore.kernel.org/linux-mm/ZRycfLxGP1CSd%2Fud@dread.disaster.area/T/
on 6.0 and 6.2, and the commit that was intended to fix this is present in
these 6.8 and above kernels (merged in 6.6):
	commit cbc02854331edc6dc22d8b77b6e22e38ebc7dd51
	Author: Matthew Wilcox (Oracle) <willy@infradead.org>
	Date:   Wed Jul 26 22:58:17 2023 -0400

	    XArray: Do not return sibling entries from xa_load()

Please, let me know if you have any suggestion or if I've missed any import=
ant details.

Thanks a lot,
Anton

Jul 23 16:01:16 k8-master kernel: watchdog: BUG: soft lockup - CPU#7 stuck =
for 108s! [rclone:102291]
Jul 23 16:01:16 k8-master kernel: Modules linked in: xfs nvme_tcp nvme_keyr=
ing nvme_fabrics nvme_core nvme_auth xt_statistic nf_conntrack_netlink xt_T=
PROXY nf_tproxy_ipv6 nf_tproxy_ipv4 ip_set xt_CT cls_bpf sch_ingress vxlan =
ip6_udp_tunnel udp_tunnel veth xt_socket nf_socket_ipv4 nf_socket_ipv6 ip6t=
able_filter ip6table_raw ip6table_mangle ip6_tables iptable_filter iptable_=
raw iptable_mangle iptable_nat xfrm_user xfrm_algo xt_addrtype xt_nat xt_MA=
SQUERADE xt_mark ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_chain_nat nf_nat x=
t_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compa=
t nf_tables qrtr intel_rapl_msr intel_rapl_common intel_uncore_frequency in=
tel_uncore_frequency_common sb_edac x86_pkg_temp_thermal intel_powerclamp c=
fg80211 coretemp kvm_intel binfmt_misc kvm irqbypass ipmi_ssif rapl intel_c=
state i2c_i801 i2c_smbus ast mei_me lpc_ich mei ioatdma ipmi_si acpi_power_=
meter acpi_ipmi ipmi_devintf ipmi_msghandler input_leds joydev acpi_pad mac=
_hid br_netfilter dm_multipath bridge stp llc overlay msr efi_pstore nfnetl=
ink
Jul 23 16:01:16 k8-master kernel:  dmi_sysfs ip_tables x_tables autofs4 btr=
fs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq a=
sync_xor async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macs=
ec ib_core uas usb_storage hid_generic usbhid hid mlx5_core crct10dif_pclmu=
l crc32_pclmul polyval_clmulni mlxfw polyval_generic igb psample ghash_clmu=
lni_intel sha256_ssse3 tls ahci sha1_ssse3 xhci_pci i2c_algo_bit libahci xh=
ci_pci_renesas pci_hyperv_intf wmi dca aesni_intel crypto_simd cryptd
Jul 23 16:01:16 k8-master kernel: CPU: 7 PID: 102291 Comm: rclone Tainted: =
G             L     6.8.0-38-generic #38-Ubuntu
Jul 23 16:01:16 k8-master kernel: Hardware name: Supermicro SYS-2028TR-HTR/=
X10DRT-H, BIOS 2.0b 08/12/2016
Jul 23 16:01:16 k8-master kernel: RIP: 0010:xas_descend+0x60/0xd0
Jul 23 16:01:16 k8-master kernel: Code: 4d 89 65 18 48 89 c2 83 e2 03 48 83=
 fa 02 75 08 48 3d fd 00 00 00 76 30 41 88 5d 12 48 83 c4 08 5b 41 5c 41 5d=
 41 5e 5d 31 d2 <31> c9 31 f6 31 ff c3 cc cc cc cc 48 83 fa 02 0f 94 c2 48 =
3d fd 00
Jul 23 16:01:16 k8-master kernel: RSP: 0018:ffffba1eee62f870 EFLAGS: 000002=
46
Jul 23 16:01:16 k8-master kernel: RAX: ffffde475fa91000 RBX: ffffba1eee62f8=
e8 RCX: 0000000000000000
Jul 23 16:01:16 k8-master kernel: RDX: 0000000000000000 RSI: ffff93df1faf69=
10 RDI: ffffba1eee62f8e8
Jul 23 16:01:16 k8-master kernel: RBP: ffffba1eee62f888 R08: 00000000000000=
00 R09: 0000000000000000
Jul 23 16:01:16 k8-master kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffff93df1faf6910
Jul 23 16:01:16 k8-master kernel: R13: 0000000000024047 R14: ffffba1eee62fc=
00 R15: ffffba1eee62fc00
Jul 23 16:01:16 k8-master kernel: FS:  000000c000d00098(0000) GS:ffff93e0ef=
a80000(0000) knlGS:0000000000000000
Jul 23 16:01:16 k8-master kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Jul 23 16:01:16 k8-master kernel: CR2: 000000c000f2b000 CR3: 00000008b4b4e0=
01 CR4: 00000000003706f0
Jul 23 16:01:16 k8-master kernel: DR0: 0000000000000000 DR1: 00000000000000=
00 DR2: 0000000000000000
Jul 23 16:01:16 k8-master kernel: DR3: 0000000000000000 DR6: 00000000fffe0f=
f0 DR7: 0000000000000400
Jul 23 16:01:16 k8-master kernel: Call Trace:
Jul 23 16:01:16 k8-master kernel:  <IRQ>
Jul 23 16:01:16 k8-master kernel:  ? show_regs+0x6d/0x80
Jul 23 16:01:16 k8-master kernel:  ? watchdog_timer_fn+0x206/0x290
Jul 23 16:01:16 k8-master kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
Jul 23 16:01:16 k8-master kernel:  ? __hrtimer_run_queues+0x112/0x2a0
Jul 23 16:01:16 k8-master kernel:  ? clockevents_program_event+0xc1/0x150
Jul 23 16:01:16 k8-master kernel:  ? hrtimer_interrupt+0xf6/0x250
Jul 23 16:01:16 k8-master kernel:  ? __sysvec_apic_timer_interrupt+0x51/0x1=
50
Jul 23 16:01:16 k8-master kernel:  ? sysvec_apic_timer_interrupt+0x8d/0xd0
Jul 23 16:01:16 k8-master kernel:  </IRQ>
Jul 23 16:01:16 k8-master kernel:  <TASK>
Jul 23 16:01:16 k8-master kernel:  ? asm_sysvec_apic_timer_interrupt+0x1b/0=
x20
Jul 23 16:01:16 k8-master kernel:  ? xas_descend+0x60/0xd0
Jul 23 16:01:16 k8-master kernel:  ? xas_load+0x4c/0x60
Jul 23 16:01:16 k8-master kernel:  __xas_next+0xa9/0x150
Jul 23 16:01:16 k8-master kernel:  filemap_get_read_batch+0x1a3/0x2e0
Jul 23 16:01:16 k8-master kernel:  ? __free_one_page+0x67/0x540
Jul 23 16:01:16 k8-master kernel:  filemap_get_pages+0xa9/0x3b0
Jul 23 16:01:16 k8-master kernel:  filemap_read+0xf7/0x470
Jul 23 16:01:16 k8-master kernel:  ? sk_reset_timer+0x18/0x70
Jul 23 16:01:16 k8-master kernel:  generic_file_read_iter+0xbb/0x110
Jul 23 16:01:16 k8-master kernel:  ? down_read+0x12/0xd0
Jul 23 16:01:16 k8-master kernel:  xfs_file_buffered_read+0x57/0xe0 [xfs]
Jul 23 16:01:16 k8-master kernel:  xfs_file_read_iter+0xb6/0x1c0 [xfs]
Jul 23 16:01:16 k8-master kernel:  vfs_read+0x258/0x390
Jul 23 16:01:16 k8-master kernel:  ksys_read+0x73/0x100
Jul 23 16:01:16 k8-master kernel:  __x64_sys_read+0x19/0x30
Jul 23 16:01:16 k8-master kernel:  x64_sys_call+0x1ada/0x25c0
Jul 23 16:01:16 k8-master kernel:  do_syscall_64+0x7f/0x180
Jul 23 16:01:16 k8-master kernel:  ? vfs_write+0x3d6/0x480
Jul 23 16:01:16 k8-master kernel:  ? ksys_write+0xe6/0x100
Jul 23 16:01:16 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:01:16 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:01:16 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:01:16 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:01:16 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:01:16 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:01:16 k8-master kernel:  ? restore_fpregs_from_fpstate+0x47/0xf0
Jul 23 16:01:16 k8-master kernel:  ? switch_fpu_return+0x55/0xf0
Jul 23 16:01:16 k8-master kernel:  ? irqentry_exit_to_user_mode+0x7e/0x260
Jul 23 16:01:16 k8-master kernel:  ? irqentry_exit+0x43/0x50
Jul 23 16:01:16 k8-master kernel:  entry_SYSCALL_64_after_hwframe+0x78/0x80
Jul 23 16:01:16 k8-master kernel: RIP: 0033:0x40708e
Jul 23 16:01:16 k8-master kernel: Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4=
 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce=
 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff =
ff ff 48
Jul 23 16:01:16 k8-master kernel: RSP: 002b:000000c00092e4f8 EFLAGS: 000002=
06 ORIG_RAX: 0000000000000000
Jul 23 16:01:16 k8-master kernel: RAX: ffffffffffffffda RBX: 00000000000000=
09 RCX: 000000000040708e
Jul 23 16:01:16 k8-master kernel: RDX: 0000000000008000 RSI: 000000c000e980=
00 RDI: 0000000000000009
Jul 23 16:01:16 k8-master kernel: RBP: 000000c00092e538 R08: 00000000000000=
00 R09: 0000000000000000
Jul 23 16:01:16 k8-master kernel: R10: 0000000000000000 R11: 00000000000002=
06 R12: 000000c00092e668
Jul 23 16:01:16 k8-master kernel: R13: 0000000000000000 R14: 000000c000ca25=
40 R15: 0000007fffffffff
Jul 23 16:01:16 k8-master kernel:  </TASK>


Jul 23 16:01:44 k8-master kernel: watchdog: BUG: soft lockup - CPU#7 stuck =
for 134s! [rclone:102291]
Jul 23 16:01:44 k8-master kernel: Modules linked in: xfs nvme_tcp nvme_keyr=
ing nvme_fabrics nvme_core nvme_auth xt_statistic nf_conntrack_netlink xt_T=
PROXY nf_tproxy_ipv6 nf_tproxy_ipv4 ip_set xt_CT cls_bpf sch_ingress vxlan =
ip6_udp_tunnel udp_tunnel veth xt_socket nf_socket_ipv4 nf_socket_ipv6 ip6t=
able_filter ip6table_raw ip6table_mangle ip6_tables iptable_filter iptable_=
raw iptable_mangle iptable_nat xfrm_user xfrm_algo xt_addrtype xt_nat xt_MA=
SQUERADE xt_mark ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_chain_nat nf_nat x=
t_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compa=
t nf_tables qrtr intel_rapl_msr intel_rapl_common intel_uncore_frequency in=
tel_uncore_frequency_common sb_edac x86_pkg_temp_thermal intel_powerclamp c=
fg80211 coretemp kvm_intel binfmt_misc kvm irqbypass ipmi_ssif rapl intel_c=
state i2c_i801 i2c_smbus ast mei_me lpc_ich mei ioatdma ipmi_si acpi_power_=
meter acpi_ipmi ipmi_devintf ipmi_msghandler input_leds joydev acpi_pad mac=
_hid br_netfilter dm_multipath bridge stp llc overlay msr efi_pstore nfnetl=
ink
Jul 23 16:01:44 k8-master kernel:  dmi_sysfs ip_tables x_tables autofs4 btr=
fs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq a=
sync_xor async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macs=
ec ib_core uas usb_storage hid_generic usbhid hid mlx5_core crct10dif_pclmu=
l crc32_pclmul polyval_clmulni mlxfw polyval_generic igb psample ghash_clmu=
lni_intel sha256_ssse3 tls ahci sha1_ssse3 xhci_pci i2c_algo_bit libahci xh=
ci_pci_renesas pci_hyperv_intf wmi dca aesni_intel crypto_simd cryptd
Jul 23 16:01:44 k8-master kernel: CPU: 7 PID: 102291 Comm: rclone Tainted: =
G             L     6.8.0-38-generic #38-Ubuntu
Jul 23 16:01:44 k8-master kernel: Hardware name: Supermicro SYS-2028TR-HTR/=
X10DRT-H, BIOS 2.0b 08/12/2016
Jul 23 16:01:44 k8-master kernel: RIP: 0010:xas_load+0x44/0x60
Jul 23 16:01:44 k8-master kernel: Code: 08 48 3d 00 10 00 00 77 11 5b 41 5c=
 5d 31 d2 31 c9 31 f6 31 ff c3 cc cc cc cc 0f b6 4b 10 4c 8d 60 fe 38 48 fe=
 72 e2 4c 89 e6 <48> 89 df e8 d4 fe ff ff 41 80 3c 24 00 75 bc eb ce 66 66 =
2e 0f 1f
Jul 23 16:01:44 k8-master kernel: RSP: 0018:ffffba1eee62f878 EFLAGS: 000002=
06
Jul 23 16:01:44 k8-master kernel: RAX: ffff93df1faf5b62 RBX: ffffba1eee62f8=
e8 RCX: 0000000000000000
Jul 23 16:01:44 k8-master kernel: RDX: 0000000000000002 RSI: ffff93df1faf5b=
60 RDI: 0000000000000000
Jul 23 16:01:44 k8-master kernel: RBP: ffffba1eee62f888 R08: 00000000000000=
00 R09: 0000000000000000
Jul 23 16:01:44 k8-master kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffff93df1faf5b60
Jul 23 16:01:44 k8-master kernel: R13: 0000000000024047 R14: ffffba1eee62fc=
00 R15: ffffba1eee62fc00
Jul 23 16:01:44 k8-master kernel: FS:  000000c000d00098(0000) GS:ffff93e0ef=
a80000(0000) knlGS:0000000000000000
Jul 23 16:01:44 k8-master kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Jul 23 16:01:44 k8-master kernel: CR2: 000000c000f2b000 CR3: 00000008b4b4e0=
01 CR4: 00000000003706f0
Jul 23 16:01:44 k8-master kernel: DR0: 0000000000000000 DR1: 00000000000000=
00 DR2: 0000000000000000
Jul 23 16:01:44 k8-master kernel: DR3: 0000000000000000 DR6: 00000000fffe0f=
f0 DR7: 0000000000000400
Jul 23 16:01:44 k8-master kernel: Call Trace:
Jul 23 16:01:44 k8-master kernel:  <IRQ>
Jul 23 16:01:44 k8-master kernel:  ? show_regs+0x6d/0x80
Jul 23 16:01:44 k8-master kernel:  ? watchdog_timer_fn+0x206/0x290
Jul 23 16:01:44 k8-master kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
Jul 23 16:01:44 k8-master kernel:  ? __hrtimer_run_queues+0x112/0x2a0
Jul 23 16:01:44 k8-master kernel:  ? clockevents_program_event+0xc1/0x150
Jul 23 16:01:44 k8-master kernel:  ? hrtimer_interrupt+0xf6/0x250
Jul 23 16:01:44 k8-master kernel:  ? __sysvec_apic_timer_interrupt+0x51/0x1=
50
Jul 23 16:01:44 k8-master kernel:  ? sysvec_apic_timer_interrupt+0x8d/0xd0
Jul 23 16:01:44 k8-master kernel:  </IRQ>
Jul 23 16:01:44 k8-master kernel:  <TASK>
Jul 23 16:01:44 k8-master kernel:  ? asm_sysvec_apic_timer_interrupt+0x1b/0=
x20
Jul 23 16:01:44 k8-master kernel:  ? xas_load+0x44/0x60
Jul 23 16:01:44 k8-master kernel:  ? xas_load+0x4c/0x60
Jul 23 16:01:44 k8-master kernel:  __xas_next+0xa9/0x150
Jul 23 16:01:44 k8-master kernel:  filemap_get_read_batch+0x1a3/0x2e0
Jul 23 16:01:44 k8-master kernel:  ? __free_one_page+0x67/0x540
Jul 23 16:01:44 k8-master kernel:  filemap_get_pages+0xa9/0x3b0
Jul 23 16:01:44 k8-master kernel:  filemap_read+0xf7/0x470
Jul 23 16:01:44 k8-master kernel:  ? sk_reset_timer+0x18/0x70
Jul 23 16:01:44 k8-master kernel:  generic_file_read_iter+0xbb/0x110
Jul 23 16:01:44 k8-master kernel:  ? down_read+0x12/0xd0
Jul 23 16:01:44 k8-master kernel:  xfs_file_buffered_read+0x57/0xe0 [xfs]
Jul 23 16:01:44 k8-master kernel:  xfs_file_read_iter+0xb6/0x1c0 [xfs]
Jul 23 16:01:44 k8-master kernel:  vfs_read+0x258/0x390
Jul 23 16:01:44 k8-master kernel:  ksys_read+0x73/0x100
Jul 23 16:01:44 k8-master kernel:  __x64_sys_read+0x19/0x30
Jul 23 16:01:44 k8-master kernel:  x64_sys_call+0x1ada/0x25c0
Jul 23 16:01:44 k8-master kernel:  do_syscall_64+0x7f/0x180
Jul 23 16:01:44 k8-master kernel:  ? vfs_write+0x3d6/0x480
Jul 23 16:01:44 k8-master kernel:  ? ksys_write+0xe6/0x100
Jul 23 16:01:44 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:01:44 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:01:44 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:01:44 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:01:44 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:01:44 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:01:44 k8-master kernel:  ? restore_fpregs_from_fpstate+0x47/0xf0
Jul 23 16:01:44 k8-master kernel:  ? switch_fpu_return+0x55/0xf0
Jul 23 16:01:44 k8-master kernel:  ? irqentry_exit_to_user_mode+0x7e/0x260
Jul 23 16:01:44 k8-master kernel:  ? irqentry_exit+0x43/0x50
Jul 23 16:01:44 k8-master kernel:  entry_SYSCALL_64_after_hwframe+0x78/0x80
Jul 23 16:01:44 k8-master kernel: RIP: 0033:0x40708e
Jul 23 16:01:44 k8-master kernel: Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4=
 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce=
 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff =
ff ff 48
Jul 23 16:01:44 k8-master kernel: RSP: 002b:000000c00092e4f8 EFLAGS: 000002=
06 ORIG_RAX: 0000000000000000
Jul 23 16:01:44 k8-master kernel: RAX: ffffffffffffffda RBX: 00000000000000=
09 RCX: 000000000040708e
Jul 23 16:01:44 k8-master kernel: RDX: 0000000000008000 RSI: 000000c000e980=
00 RDI: 0000000000000009
Jul 23 16:01:44 k8-master kernel: RBP: 000000c00092e538 R08: 00000000000000=
00 R09: 0000000000000000
Jul 23 16:01:44 k8-master kernel: R10: 0000000000000000 R11: 00000000000002=
06 R12: 000000c00092e668
Jul 23 16:01:44 k8-master kernel: R13: 0000000000000000 R14: 000000c000ca25=
40 R15: 0000007fffffffff
Jul 23 16:01:44 k8-master kernel:  </TASK>

Jul 23 16:02:12 k8-master kernel: watchdog: BUG: soft lockup - CPU#7 stuck =
for 160s! [rclone:102291]
Jul 23 16:02:12 k8-master kernel: Modules linked in: xfs nvme_tcp nvme_keyr=
ing nvme_fabrics nvme_core nvme_auth xt_statistic nf_conntrack_netlink xt_T=
PROXY nf_tproxy_ipv6 nf_tproxy_ipv4 ip_set xt_CT cls_bpf sch_ingress vxlan =
ip6_udp_tunnel udp_tunnel veth xt_socket nf_socket_ipv4 nf_socket_ipv6 ip6t=
able_filter ip6table_raw ip6table_mangle ip6_tables iptable_filter iptable_=
raw iptable_mangle iptable_nat xfrm_user xfrm_algo xt_addrtype xt_nat xt_MA=
SQUERADE xt_mark ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_chain_nat nf_nat x=
t_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compa=
t nf_tables qrtr intel_rapl_msr intel_rapl_common intel_uncore_frequency in=
tel_uncore_frequency_common sb_edac x86_pkg_temp_thermal intel_powerclamp c=
fg80211 coretemp kvm_intel binfmt_misc kvm irqbypass ipmi_ssif rapl intel_c=
state i2c_i801 i2c_smbus ast mei_me lpc_ich mei ioatdma ipmi_si acpi_power_=
meter acpi_ipmi ipmi_devintf ipmi_msghandler input_leds joydev acpi_pad mac=
_hid br_netfilter dm_multipath bridge stp llc overlay msr efi_pstore nfnetl=
ink
Jul 23 16:02:12 k8-master kernel:  dmi_sysfs ip_tables x_tables autofs4 btr=
fs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq a=
sync_xor async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macs=
ec ib_core uas usb_storage hid_generic usbhid hid mlx5_core crct10dif_pclmu=
l crc32_pclmul polyval_clmulni mlxfw polyval_generic igb psample ghash_clmu=
lni_intel sha256_ssse3 tls ahci sha1_ssse3 xhci_pci i2c_algo_bit libahci xh=
ci_pci_renesas pci_hyperv_intf wmi dca aesni_intel crypto_simd cryptd
Jul 23 16:02:12 k8-master kernel: CPU: 7 PID: 102291 Comm: rclone Tainted: =
G             L     6.8.0-38-generic #38-Ubuntu
Jul 23 16:02:12 k8-master kernel: Hardware name: Supermicro SYS-2028TR-HTR/=
X10DRT-H, BIOS 2.0b 08/12/2016
Jul 23 16:02:12 k8-master kernel: RIP: 0010:__xas_next+0x0/0x150
Jul 23 16:02:12 k8-master kernel: Code: e9 7c ff ff ff 4c 89 f6 48 c7 c7 60=
 73 1e bc e8 16 70 78 ff e9 b2 fe ff ff 90 90 90 90 90 90 90 90 90 90 90 90=
 90 90 90 90 90 <55> 48 89 e5 41 56 41 55 41 54 49 89 fc 53 48 83 ec 10 48 =
8b 5f 18
Jul 23 16:02:12 k8-master kernel: RSP: 0018:ffffba1eee62f8d0 EFLAGS: 000002=
46
Jul 23 16:02:12 k8-master kernel: RAX: 0000000000000000 RBX: ffffde475fa910=
00 RCX: 0000000000000000
Jul 23 16:02:12 k8-master kernel: RDX: 0000000000000000 RSI: 00000000000000=
00 RDI: ffffba1eee62f8e8
Jul 23 16:02:12 k8-master kernel: RBP: ffffba1eee62f950 R08: 00000000000000=
00 R09: 0000000000000000
Jul 23 16:02:12 k8-master kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffba1eee62fa60
Jul 23 16:02:12 k8-master kernel: R13: 0000000000024047 R14: ffffba1eee62fc=
00 R15: ffffba1eee62fc00
Jul 23 16:02:12 k8-master kernel: FS:  000000c000d00098(0000) GS:ffff93e0ef=
a80000(0000) knlGS:0000000000000000
Jul 23 16:02:12 k8-master kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Jul 23 16:02:12 k8-master kernel: CR2: 000000c000f2b000 CR3: 00000008b4b4e0=
01 CR4: 00000000003706f0
Jul 23 16:02:12 k8-master kernel: DR0: 0000000000000000 DR1: 00000000000000=
00 DR2: 0000000000000000
Jul 23 16:02:12 k8-master kernel: DR3: 0000000000000000 DR6: 00000000fffe0f=
f0 DR7: 0000000000000400
Jul 23 16:02:12 k8-master kernel: Call Trace:
Jul 23 16:02:12 k8-master kernel:  <IRQ>
Jul 23 16:02:12 k8-master kernel:  ? show_regs+0x6d/0x80
Jul 23 16:02:12 k8-master kernel:  ? watchdog_timer_fn+0x206/0x290
Jul 23 16:02:12 k8-master kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
Jul 23 16:02:12 k8-master kernel:  ? __hrtimer_run_queues+0x112/0x2a0
Jul 23 16:02:12 k8-master kernel:  ? clockevents_program_event+0xc1/0x150
Jul 23 16:02:12 k8-master kernel:  ? hrtimer_interrupt+0xf6/0x250
Jul 23 16:02:12 k8-master kernel:  ? __sysvec_apic_timer_interrupt+0x51/0x1=
50
Jul 23 16:02:12 k8-master kernel:  ? sysvec_apic_timer_interrupt+0x8d/0xd0
Jul 23 16:02:12 k8-master kernel:  </IRQ>
Jul 23 16:02:12 k8-master kernel:  <TASK>
Jul 23 16:02:12 k8-master kernel:  ? asm_sysvec_apic_timer_interrupt+0x1b/0=
x20
Jul 23 16:02:12 k8-master kernel:  ? __pfx___xas_next+0x10/0x10
Jul 23 16:02:12 k8-master kernel:  ? filemap_get_read_batch+0x1a3/0x2e0
Jul 23 16:02:12 k8-master kernel:  ? __free_one_page+0x67/0x540
Jul 23 16:02:12 k8-master kernel:  filemap_get_pages+0xa9/0x3b0
Jul 23 16:02:12 k8-master kernel:  filemap_read+0xf7/0x470
Jul 23 16:02:12 k8-master kernel:  ? sk_reset_timer+0x18/0x70
Jul 23 16:02:12 k8-master kernel:  generic_file_read_iter+0xbb/0x110
Jul 23 16:02:12 k8-master kernel:  ? down_read+0x12/0xd0
Jul 23 16:02:12 k8-master kernel:  xfs_file_buffered_read+0x57/0xe0 [xfs]
Jul 23 16:02:12 k8-master kernel:  xfs_file_read_iter+0xb6/0x1c0 [xfs]
Jul 23 16:02:12 k8-master kernel:  vfs_read+0x258/0x390
Jul 23 16:02:12 k8-master kernel:  ksys_read+0x73/0x100
Jul 23 16:02:12 k8-master kernel:  __x64_sys_read+0x19/0x30
Jul 23 16:02:12 k8-master kernel:  x64_sys_call+0x1ada/0x25c0
Jul 23 16:02:12 k8-master kernel:  do_syscall_64+0x7f/0x180
Jul 23 16:02:12 k8-master kernel:  ? vfs_write+0x3d6/0x480
Jul 23 16:02:12 k8-master kernel:  ? ksys_write+0xe6/0x100
Jul 23 16:02:12 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:02:12 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:02:12 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:02:12 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:02:12 k8-master kernel:  ? syscall_exit_to_user_mode+0x89/0x260
Jul 23 16:02:12 k8-master kernel:  ? do_syscall_64+0x8c/0x180
Jul 23 16:02:12 k8-master kernel:  ? restore_fpregs_from_fpstate+0x47/0xf0
Jul 23 16:02:12 k8-master kernel:  ? switch_fpu_return+0x55/0xf0
Jul 23 16:02:12 k8-master kernel:  ? irqentry_exit_to_user_mode+0x7e/0x260
Jul 23 16:02:12 k8-master kernel:  ? irqentry_exit+0x43/0x50
Jul 23 16:02:12 k8-master kernel:  entry_SYSCALL_64_after_hwframe+0x78/0x80
Jul 23 16:02:12 k8-master kernel: RIP: 0033:0x40708e
Jul 23 16:02:12 k8-master kernel: Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4=
 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce=
 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff =
ff ff 48
Jul 23 16:02:12 k8-master kernel: RSP: 002b:000000c00092e4f8 EFLAGS: 000002=
06 ORIG_RAX: 0000000000000000
Jul 23 16:02:12 k8-master kernel: RAX: ffffffffffffffda RBX: 00000000000000=
09 RCX: 000000000040708e
Jul 23 16:02:12 k8-master kernel: RDX: 0000000000008000 RSI: 000000c000e980=
00 RDI: 0000000000000009
Jul 23 16:02:12 k8-master kernel: RBP: 000000c00092e538 R08: 00000000000000=
00 R09: 0000000000000000
Jul 23 16:02:12 k8-master kernel: R10: 0000000000000000 R11: 00000000000002=
06 R12: 000000c00092e668
Jul 23 16:02:12 k8-master kernel: R13: 0000000000000000 R14: 000000c000ca25=
40 R15: 0000007fffffffff
Jul 23 16:02:12 k8-master kernel:  </TASK>

