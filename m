Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC980EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 02:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjGQCpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Jul 2023 22:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjGQCpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jul 2023 22:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36C1187
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jul 2023 19:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689561860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NOj0vsKsl3u2Rg6rXhXRJSlLzLQxJPk9fHS372s2t34=;
        b=fFqMwXhZSjWjMjuFjuUB8tGanhYQ3IZ1a55Chpc/3hrFuPdLCEBrLj4EbRbiun7DAY1oRk
        b8PkG55RAn28vI587MvujJWqk/M+VQASuDu4Aiebwl40UXHzgJ5inHPNX7FCk9BpWxoZsN
        3ztRCAcR5c+VUzeaEateVOwggWtk+AA=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-DuSVu-OcO92xqAs9jrBX9A-1; Sun, 16 Jul 2023 22:44:19 -0400
X-MC-Unique: DuSVu-OcO92xqAs9jrBX9A-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-55e16833517so5383337eaf.1
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jul 2023 19:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689561858; x=1692153858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOj0vsKsl3u2Rg6rXhXRJSlLzLQxJPk9fHS372s2t34=;
        b=R5MsaKiv/sWKb6weoEXoLUJ0TC9qfRCpRZ9qgeqH601r0UtXuZJcIVCN2PeWMw2wjY
         Jx7+7w/w32SEx0ZeD5rzX74yXU9u8nd000P1jewrjaGkvXSxL6ebt7Oq2Aa/DjOxxmAx
         SfMo1+Nwt3B8UwaybGK1ze/fwt/5F2bwCOjDc+NDWe52im4J5jiGGsm0cmFsTD/tRGm1
         LHcQhgck65979MiUJ9XSx2oYJoVtis+cNBgcw01UuUYx3DzLXNMn9p91jGp03Tb37Uz4
         qiRWiqj923GbytdS6GwM6NCSpHX8Rxj2V/291hz8cQg+Iu38e/8Pf3Dp79pHyeOnbkj6
         tvGg==
X-Gm-Message-State: ABy/qLZYCXXjxJt9BrgshIo6mtNKRpO1Zf7aFLjYnp/z6+bCNMcAHLXF
        y1+n89ql1kVW+tRPZv8+nNR324Srh7cqd/5z/IgdD95eMXlFNmNmEYD+eXzy/o7QDew0WjQSJq9
        QIdABaVKf2Wdj0iLAj61c2tff49SSABk=
X-Received: by 2002:a05:6358:5209:b0:134:d4b6:1c47 with SMTP id b9-20020a056358520900b00134d4b61c47mr9444237rwa.22.1689561858020;
        Sun, 16 Jul 2023 19:44:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGEkeaYL0pKBEFQp0LfDHjd09Zj7YA7OAIUaVh2ARuIYhsmMNbDNH4sLs0DaLJ8PfDmglt0fQ==
X-Received: by 2002:a05:6358:5209:b0:134:d4b6:1c47 with SMTP id b9-20020a056358520900b00134d4b61c47mr9444205rwa.22.1689561857408;
        Sun, 16 Jul 2023 19:44:17 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g13-20020a62e30d000000b00682bec0b680sm10797905pfh.89.2023.07.16.19.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jul 2023 19:44:17 -0700 (PDT)
Date:   Mon, 17 Jul 2023 10:44:13 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a couple more tests for ascii-ci problems
Message-ID: <20230717024413.p3lpqfqb3hq6lkij@zlang-mailbox>
References: <20230711202528.GB11442@frogsfrogsfrogs>
 <20230714145705.GK11442@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714145705.GK11442@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 07:57:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some tests to make sure that userspace and the kernel actually
> agree on how to do ascii case-insensitive directory lookups, and that
> metadump can actually obfuscate such filesystems.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: cleanup cruft and dont mess with LANG= per zlang
> ---

This version looks good to me, just one question, the xfs/860 hit below error [1]
when I tried to run it on my Fedora system ( with 6.5-rc1 kernel and latest
upstream xfsprogs). Is that as expected?

Due to I only saw a xfsprogs known issue you marked in xfs/860, but this error is
from kernel.

Thanks,
Zorro

[ 1579.216692] run fstests xfs/860 at 2023-07-17 10:35:29
[ 1579.764224] XFS (sda5): Mounting V5 Filesystem de80b0bc-dfa9-4e15-80f1-2a72ead79a81
[ 1579.814136] XFS (sda5): Ending clean mount
[ 1579.983363] XFS (sda3): Mounting V5 Filesystem 6d0a233b-7f98-43c1-a6a2-9e1218623ec6
[ 1580.010365] XFS (sda3): Ending clean mount
[ 1580.167032] ------------[ cut here ]------------
[ 1580.167683] memcpy: detected field-spanning write (size 250) of single field "(char *)name_loc->nameval" at fs/xfs/libxfs/xfs_attr_leaf.c:1559 (size 1)
[ 1580.168457] WARNING: CPU: 8 PID: 4187 at fs/xfs/libxfs/xfs_attr_leaf.c:1559 xfs_attr3_leaf_add_work+0x4ee/0x530 [xfs]
[ 1580.169385] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set rfkill nf_tables nfnetlink qrtr intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel ipmi_ssif kvm pktcdvd nd_pmem irqbypass iTCO_wdt rapl intel_cstate acpi_ipmi ipmi_si intel_uncore nd_btt intel_pmc_bxt iTCO_vendor_support ipmi_devintf ioatdma dax_pmem ipmi_msghandler lpc_ich hpilo acpi_power_meter dca loop fuse zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel polyval_clmulni nd_e820 polyval_generic libnvdimm ghash_clmulni_intel sha512_ssse3 hpsa serio_raw tg3 mgag200 i2c_algo_bit hpwdt scsi_transport_sas ata_generic pata_acpi scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_multipath
[ 1580.173667] CPU: 8 PID: 4187 Comm: setfattr Tainted: G S        I       -------  ---  6.5.0-0.rc1.20230711git3f01e9fed845.12.fc39.x86_64 #1
[ 1580.174327] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
[ 1580.174712] RIP: 0010:xfs_attr3_leaf_add_work+0x4ee/0x530 [xfs]
[ 1580.175938] Code: fe ff ff b9 01 00 00 00 4c 89 fe 48 c7 c2 08 27 ba c0 48 c7 c7 50 27 ba c0 48 89 44 24 08 c6 05 d4 d5 10 00 01 e8 d2 c6 75 cf <0f> 0b 48 8b 44 24 08 e9 88 fe ff ff 80 3d bb d5 10 00 00 0f 85 bd
[ 1580.177664] RSP: 0018:ffffb61ec631f820 EFLAGS: 00010282
[ 1580.177967] RAX: 0000000000000000 RBX: ffffb61ec631f8f0 RCX: 0000000000000000
[ 1580.178741] RDX: ffff906e7162e580 RSI: ffff906e71621540 RDI: ffff906e71621540
[ 1580.179551] RBP: ffffb61ec631f884 R08: 0000000000000000 R09: ffffb61ec631f6b0
[ 1580.180343] R10: 0000000000000003 R11: ffff906e7ff45128 R12: ffff906b286bc050
[ 1580.181156] R13: ffff906b286bc000 R14: ffff906b286bcf00 R15: 00000000000000fa
[ 1580.181969] FS:  00007f7fe6b11680(0000) GS:ffff906e71600000(0000) knlGS:0000000000000000
[ 1580.182407] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1580.183132] CR2: 00007f7fe6a27a50 CR3: 00000004c2e22001 CR4: 00000000001706e0
[ 1580.183896] Call Trace:
[ 1580.239654]  <TASK>
[ 1580.284489]  ? xfs_attr3_leaf_add_work+0x4ee/0x530 [xfs]
[ 1580.285103]  ? __warn+0x81/0x130
[ 1580.285663]  ? xfs_attr3_leaf_add_work+0x4ee/0x530 [xfs]
[ 1580.286276]  ? report_bug+0x171/0x1a0
[ 1580.286515]  ? prb_read_valid+0x1b/0x30
[ 1580.286731]  ? handle_bug+0x3c/0x80
[ 1580.287289]  ? exc_invalid_op+0x17/0x70
[ 1580.287493]  ? asm_exc_invalid_op+0x1a/0x20
[ 1580.287707]  ? xfs_attr3_leaf_add_work+0x4ee/0x530 [xfs]
[ 1580.288320]  xfs_attr3_leaf_add+0x1a3/0x210 [xfs]
[ 1580.289267]  xfs_attr_shortform_to_leaf+0x23f/0x250 [xfs]
[ 1580.289883]  xfs_attr_set_iter+0x772/0x910 [xfs]
[ 1580.290829]  xfs_xattri_finish_update+0x18/0x50 [xfs]
[ 1580.291475]  xfs_attr_finish_item+0x1e/0xb0 [xfs]
[ 1580.292430]  xfs_defer_finish_noroll+0x196/0x6e0 [xfs]
[ 1580.321763]  __xfs_trans_commit+0x242/0x360 [xfs]
[ 1580.463165]  xfs_attr_set+0x48a/0x6a0 [xfs]
[ 1580.575201]  xfs_xattr_set+0x8d/0xe0 [xfs]
[ 1580.687468]  __vfs_setxattr+0x99/0xd0
[ 1580.693573]  __vfs_setxattr_noperm+0x77/0x1d0
[ 1580.694224]  vfs_setxattr+0x9f/0x180
[ 1580.694449]  setxattr+0x9e/0xc0
[ 1580.695211]  path_setxattr+0xd9/0xf0
[ 1580.695616]  __x64_sys_setxattr+0x2b/0x40
[ 1580.695857]  do_syscall_64+0x60/0x90
[ 1580.696060]  ? handle_mm_fault+0x9e/0x350
[ 1580.696268]  ? do_user_addr_fault+0x225/0x640
[ 1580.696924]  ? exc_page_fault+0x7f/0x180
[ 1580.697161]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[ 1580.697449] RIP: 0033:0x7f7fe6a3edde
[ 1580.697696] Code: 48 8b 0d 2d 70 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fa 6f 0c 00 f7 d8 64 89 01 48
[ 1580.699044] RSP: 002b:00007ffd07e29b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
[ 1580.699839] RAX: ffffffffffffffda RBX: 000055bdac5a62f0 RCX: 00007f7fe6a3edde
[ 1580.700631] RDX: 000055bdac5a62f0 RSI: 00007ffd07e2be79 RDI: 00007ffd07e2bf7e
[ 1580.701417] RBP: 00007ffd07e29be0 R08: 0000000000000000 R09: 0000000000000001
[ 1580.786259] R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffd07e2bf7e
[ 1580.981664] R13: 000055bdac5a62f1 R14: 00007ffd07e2be79 R15: 0000000000000100
[ 1581.177424]  </TASK>
[ 1581.202206] ---[ end trace 0000000000000000 ]---
[ 1581.307610] XFS (sda3): Unmounting Filesystem 6d0a233b-7f98-43c1-a6a2-9e1218623ec6
[ 1588.032401] XFS (sda3): Mounting V5 Filesystem 6d0a233b-7f98-43c1-a6a2-9e1218623ec6
[ 1588.054500] XFS (sda3): Ending clean mount
[ 1588.078504] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at your own risk!
[ 1588.102942] ------------[ cut here ]------------
...
...
[ 1588.103598] memcpy: detected field-spanning write (size 250) of single field "aep->a_name" at fs/xfs/xfs_ioctl.c:343 (size 1)
[ 1588.104700] WARNING: CPU: 22 PID: 4300 at fs/xfs/xfs_ioctl.c:343 xfs_ioc_attr_put_listent+0x176/0x180 [xfs]
[ 1588.105551] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set rfkill nf_tables nfnetlink qrtr intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel ipmi_ssif kvm pktcdvd nd_pmem irqbypass iTCO_wdt rapl intel_cstate acpi_ipmi ipmi_si intel_uncore nd_btt intel_pmc_bxt iTCO_vendor_support ipmi_devintf ioatdma dax_pmem ipmi_msghandler lpc_ich hpilo acpi_power_meter dca loop fuse zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel polyval_clmulni nd_e820 polyval_generic libnvdimm ghash_clmulni_intel sha512_ssse3 hpsa serio_raw tg3 mgag200 i2c_algo_bit hpwdt scsi_transport_sas ata_generic pata_acpi scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_multipath
[ 1588.110098] CPU: 22 PID: 4300 Comm: xfs_scrub Tainted: G S      W I       -------  ---  6.5.0-0.rc1.20230711git3f01e9fed845.12.fc39.x86_64 #1
[ 1588.111378] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
[ 1588.111743] RIP: 0010:xfs_ioc_attr_put_listent+0x176/0x180 [xfs]
[ 1588.112815] Code: 00 00 0f 85 0e ff ff ff b9 01 00 00 00 48 c7 c2 48 46 ba c0 4c 89 f6 48 c7 c7 78 46 ba c0 c6 05 1f 9e 0a 00 01 e8 1a 8f 6f cf <0f> 0b e9 e5 fe ff ff 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90
[ 1588.114203] RSP: 0018:ffffb61ecf11fb20 EFLAGS: 00010282
[ 1588.114498] RAX: 0000000000000000 RBX: ffffb61ecf11fc68 RCX: 0000000000000000
[ 1588.115265] RDX: ffff9066fa7ae580 RSI: ffff9066fa7a1540 RDI: ffff9066fa7a1540
[ 1588.116230] RBP: ffff90666adeff00 R08: 0000000000000000 R09: ffffb61ecf11f9b0
[ 1588.117052] R10: 0000000000000003 R11: ffff906e7ff45128 R12: ffff906649fe3f03
[ 1588.117855] R13: ffff90666ade0000 R14: 00000000000000fa R15: ffff90666adeff04
[ 1588.118678] FS:  00007f5e70701900(0000) GS:ffff9066fa780000(0000) knlGS:0000000000000000
[ 1588.204720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1588.219762] CR2: 00007ffddc8e8000 CR3: 000000000b2ba002 CR4: 00000000001706e0
[ 1588.220543] Call Trace:
[ 1588.220688]  <TASK>
[ 1588.221163]  ? xfs_ioc_attr_put_listent+0x176/0x180 [xfs]
[ 1588.221661]  ? __warn+0x81/0x130
[ 1588.222222]  ? xfs_ioc_attr_put_listent+0x176/0x180 [xfs]
[ 1588.222724]  ? report_bug+0x171/0x1a0
[ 1588.222942]  ? prb_read_valid+0x1b/0x30
[ 1588.223184]  ? handle_bug+0x3c/0x80
[ 1588.223728]  ? exc_invalid_op+0x17/0x70
[ 1588.223939]  ? asm_exc_invalid_op+0x1a/0x20
[ 1588.224181]  ? xfs_ioc_attr_put_listent+0x176/0x180 [xfs]
[ 1588.224678]  xfs_attr3_leaf_list_int+0x18c/0x370 [xfs]
[ 1588.225172]  xfs_attr_node_list+0x104/0x300 [xfs]
[ 1588.226019]  xfs_attr_list+0x7a/0xa0 [xfs]
[ 1588.226463]  xfs_ioc_attr_list+0x129/0x1c0 [xfs]
[ 1588.227302]  ? __pfx_xfs_ioc_attr_put_listent+0x10/0x10 [xfs]
[ 1588.228211]  xfs_attrlist_by_handle+0x91/0xe0 [xfs]
[ 1588.229053]  xfs_file_ioctl+0x499/0xd60 [xfs]
[ 1588.229915]  ? ioctl_has_perm.constprop.0.isra.0+0xda/0x130
[ 1588.230237]  __x64_sys_ioctl+0x97/0xd0
[ 1588.312830]  do_syscall_64+0x60/0x90
[ 1588.422274]  ? exc_page_fault+0x7f/0x180
[ 1588.531007]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[ 1588.630650] RIP: 0033:0x7f5e70812cbd
[ 1588.630898] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 
48 2b 04 25 28 00 00 00
[ 1588.632258] RSP: 002b:00007ffddc8dd3e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1588.633062] RAX: ffffffffffffffda RBX: 00007ffddc8dd4d0 RCX: 00007f5e70812cbd
[ 1588.634069] RDX: 00007ffddc8dd440 RSI: 000000004058587a RDI: 0000000000000004
[ 1588.635128] RBP: 00007ffddc8dd430 R08: 0000000000000000 R09: 00007ffddc8dd4d0
[ 1588.635974] R10: 00007ffddc8ed6c0 R11: 0000000000000246 R12: 0000000000414a80
[ 1588.636768] R13: 00007ffddc8edd70 R14: 00007ffddc8ed620 R15: 00007ffddc8edabf
[ 1588.637591]  </TASK>
[ 1588.637742] ---[ end trace 0000000000000000 ]---
[ 1588.784337] XFS (sda3): Unmounting Filesystem 6d0a233b-7f98-43c1-a6a2-9e1218623ec6
[ 1588.926686] XFS (sda3): Mounting V5 Filesystem 6d0a233b-7f98-43c1-a6a2-9e1218623ec6
[ 1588.948787] XFS (sda3): Ending clean mount
...
...

>  tests/xfs/859     |   56 +++++++++++++++++++++++++++++
>  tests/xfs/859.out |   24 +++++++++++++
>  tests/xfs/860     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/860.out |    9 +++++
>  tests/xfs/861     |   91 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/861.out |    2 +
>  6 files changed, 283 insertions(+)
>  create mode 100755 tests/xfs/859
>  create mode 100644 tests/xfs/859.out
>  create mode 100755 tests/xfs/860
>  create mode 100644 tests/xfs/860.out
>  create mode 100755 tests/xfs/861
>  create mode 100644 tests/xfs/861.out
> 
> diff --git a/tests/xfs/859 b/tests/xfs/859
> new file mode 100755
> index 0000000000..14f645310d
> --- /dev/null
> +++ b/tests/xfs/859
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 859
> +#
> +# Make sure that the kernel and userspace agree on which byte sequences are
> +# ASCII uppercase letters, and how to convert them.
> +#
> +. ./common/preamble
> +_begin_fstest auto ci dir
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_fixed_by_kernel_commit a9248538facc \
> +	"xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation"
> +_fixed_by_kernel_commit 9dceccc5822f \
> +	"xfs: use the directory name hash function for dir scrubbing"
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_mkfs_ciname
> +
> +_scratch_mkfs -n version=ci > $seqres.full
> +_scratch_mount
> +
> +# Create a two-block directory to force leaf format
> +mkdir "$SCRATCH_MNT/lol"
> +touch "$SCRATCH_MNT/lol/autoexec.bat"
> +i=0
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> +nr_dirents=$((dblksz * 2 / 256))
> +
> +for ((i = 0; i < nr_dirents; i++)); do
> +	name="$(printf "y%0254d" $i)"
> +	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name"
> +done
> +
> +dirsz=$(stat -c '%s' $SCRATCH_MNT/lol)
> +test $dirsz -gt $dblksz || echo "dir size $dirsz, expected at least $dblksz?"
> +stat $SCRATCH_MNT/lol >> $seqres.full
> +
> +# Create names with extended ascii characters in them to exploit the fact
> +# that the Linux kernel will transform extended ASCII uppercase characters
> +# but libc won't.  Need to force LANG=C here so that awk doesn't spit out utf8
> +# sequences.
> +test "$LANG" = "C" || _notrun "LANG=C required"
> +awk 'END { for (i = 192; i < 247; i++) printf("%c\n", i); }' < /dev/null | while read name; do
> +	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name" 2>&1 | _filter_scratch
> +done
> +
> +# Now just let repair run
> +
> +status=0
> +exit
> diff --git a/tests/xfs/859.out b/tests/xfs/859.out
> new file mode 100644
> index 0000000000..a4939ba670
> --- /dev/null
> +++ b/tests/xfs/859.out
> @@ -0,0 +1,24 @@
> +QA output created by 859
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\340': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\341': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\342': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\343': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\344': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\345': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\346': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\347': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\350': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\351': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\352': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\353': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\354': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\355': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\356': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\357': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\360': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\361': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\362': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\363': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\364': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\365': File exists
> +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\366': File exists
> diff --git a/tests/xfs/860 b/tests/xfs/860
> new file mode 100755
> index 0000000000..9a934bb33d
> --- /dev/null
> +++ b/tests/xfs/860
> @@ -0,0 +1,101 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 860
> +#
> +# Make sure that metadump obfuscation works for filesystems with ascii-ci
> +# enabled.
> +#
> +. ./common/preamble
> +_begin_fstest auto dir ci
> +
> +_cleanup()
> +{
> +      cd /
> +      rm -r -f $tmp.* $testdir
> +}
> +
> +_fixed_by_git_commit xfsprogs 10a01bcd \
> +	"xfs_db: fix metadump name obfuscation for ascii-ci filesystems"
> +
> +_supported_fs xfs
> +_require_test
> +_require_scratch
> +_require_xfs_mkfs_ciname
> +
> +_scratch_mkfs -n version=ci > $seqres.full
> +_scratch_mount
> +
> +# Create a two-block directory to force leaf format
> +mkdir "$SCRATCH_MNT/lol"
> +touch "$SCRATCH_MNT/lol/autoexec.bat"
> +i=0
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> +nr_dirents=$((dblksz * 2 / 256))
> +
> +for ((i = 0; i < nr_dirents; i++)); do
> +	name="$(printf "y%0254d" $i)"
> +	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name"
> +done
> +
> +dirsz=$(stat -c '%s' $SCRATCH_MNT/lol)
> +test $dirsz -gt $dblksz || echo "dir size $dirsz, expected at least $dblksz?"
> +stat $SCRATCH_MNT/lol >> $seqres.full
> +
> +# Create a two-block attr to force leaf format
> +i=0
> +for ((i = 0; i < nr_dirents; i++)); do
> +	name="$(printf "user.%0250d" $i)"
> +	$SETFATTR_PROG -n "$name" -v 1 "$SCRATCH_MNT/lol/autoexec.bat"
> +done
> +stat $SCRATCH_MNT/lol/autoexec.bat >> $seqres.full
> +
> +_scratch_unmount
> +
> +testdir=$TEST_DIR/$seq.metadumps
> +mkdir -p $testdir
> +metadump_file=$testdir/scratch.md
> +metadump_file_a=${metadump_file}.a
> +metadump_file_o=${metadump_file}.o
> +metadump_file_ao=${metadump_file}.ao
> +
> +echo metadump
> +_scratch_xfs_metadump $metadump_file >> $seqres.full
> +
> +echo metadump a
> +_scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
> +
> +echo metadump o
> +_scratch_xfs_metadump $metadump_file_o -o >> $seqres.full
> +
> +echo metadump ao
> +_scratch_xfs_metadump $metadump_file_ao -a -o >> $seqres.full
> +
> +echo mdrestore
> +_scratch_xfs_mdrestore $metadump_file
> +_scratch_mount
> +_check_scratch_fs
> +_scratch_unmount
> +
> +echo mdrestore a
> +_scratch_xfs_mdrestore $metadump_file_a
> +_scratch_mount
> +_check_scratch_fs
> +_scratch_unmount
> +
> +echo mdrestore o
> +_scratch_xfs_mdrestore $metadump_file_o
> +_scratch_mount
> +_check_scratch_fs
> +_scratch_unmount
> +
> +echo mdrestore ao
> +_scratch_xfs_mdrestore $metadump_file_ao
> +_scratch_mount
> +_check_scratch_fs
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/860.out b/tests/xfs/860.out
> new file mode 100644
> index 0000000000..136fc5f7d6
> --- /dev/null
> +++ b/tests/xfs/860.out
> @@ -0,0 +1,9 @@
> +QA output created by 860
> +metadump
> +metadump a
> +metadump o
> +metadump ao
> +mdrestore
> +mdrestore a
> +mdrestore o
> +mdrestore ao
> diff --git a/tests/xfs/861 b/tests/xfs/861
> new file mode 100755
> index 0000000000..d692719697
> --- /dev/null
> +++ b/tests/xfs/861
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 861
> +#
> +# Make sure that the kernel and utilities can handle large numbers of dirhash
> +# collisions in both the directory and extended attribute structures.
> +#
> +# This started as a regression test for the new 'hashcoll' function in xfs_db,
> +# but became a regression test for an xfs_repair bug affecting hashval checks
> +# applied to the second and higher node levels of a dabtree.
> +#
> +. ./common/preamble
> +_begin_fstest auto dir
> +
> +_fixed_by_git_commit xfsprogs b7b81f336ac \
> +	"xfs_repair: fix incorrect dabtree hashval comparison"
> +
> +_supported_fs xfs
> +_require_xfs_db_command "hashcoll"
> +_require_xfs_db_command "path"
> +_require_scratch
> +
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +
> +crash_dir=$SCRATCH_MNT/lol/
> +crash_attrs=$SCRATCH_MNT/hah
> +
> +mkdir -p "$crash_dir"
> +touch "$crash_attrs"
> +
> +# Create enough dirents to fill two dabtree node blocks with names that all
> +# hash to the same value.  Each dirent gets its own record in the dabtree,
> +# so we must create enough dirents to get a dabtree of at least height 2.
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> +
> +da_records_per_block=$((dblksz / 8))	# 32-bit hash and 32-bit before
> +nr_dirents=$((da_records_per_block * 2))
> +
> +longname="$(mktemp --dry-run "$(perl -e 'print "X" x 255;')" | tr ' ' 'X')"
> +echo "creating $nr_dirents dirents from '$longname'" >> $seqres.full
> +_scratch_xfs_db -r -c "hashcoll -n $nr_dirents -p $crash_dir $longname"
> +
> +# Create enough xattrs to fill two dabtree nodes.  Each attribute leaf block
> +# gets its own record in the dabtree, so we have to create enough attr blocks
> +# (each full of attrs) to get a dabtree of at least height 2.
> +blksz=$(_get_block_size "$SCRATCH_MNT")
> +
> +attr_records_per_block=$((blksz / 255))
> +da_records_per_block=$((blksz / 8))	# 32-bit hash and 32-bit before
> +nr_attrs=$((da_records_per_block * attr_records_per_block * 2))
> +
> +longname="$(mktemp --dry-run "$(perl -e 'print "X" x 249;')" | tr ' ' 'X')"
> +echo "creating $nr_attrs attrs from '$longname'" >> $seqres.full
> +_scratch_xfs_db -r -c "hashcoll -a -n $nr_attrs -p $crash_attrs $longname"
> +
> +_scratch_unmount
> +
> +# Make sure that there's one hash value dominating the dabtree block.
> +# We don't require 100% because directories create dabtree records for dot
> +# and dotdot.
> +filter_hashvals() {
> +	uniq -c | awk -v seqres_full="$seqres.full" \
> +		'{print $0 >> seqres_full; tot += $1; if ($1 > biggest) biggest = $1;} END {if (biggest >= (tot - 2)) exit(0); exit(1);}'
> +	test "${PIPESTATUS[1]}" -eq 0 || \
> +		echo "Scattered dabtree hashes?  See seqres.full"
> +}
> +
> +# Did we actually get a two-level dabtree for the directory?  Does it contain a
> +# long run of hashes?
> +echo "dir check" >> $seqres.full
> +da_node_block_offset=$(( (2 ** 35) / blksz ))
> +dir_db_args=(-c 'path /lol/' -c "dblock $da_node_block_offset" -c 'addr nbtree[0].before')
> +dir_count="$(_scratch_xfs_db "${dir_db_args[@]}" -c 'print lhdr.count' | awk '{print $3}')"
> +_scratch_xfs_db "${dir_db_args[@]}" -c "print lents[0-$((dir_count - 1))].hashval" | sed -e 's/lents\[[0-9]*\]/lents[NN]/g' | filter_hashvals
> +
> +# Did we actually get a two-level dabtree for the attrs?  Does it contain a
> +# long run of hashes?
> +echo "attr check" >> $seqres.full
> +attr_db_args=(-c 'path /hah' -c "ablock 0" -c 'addr btree[0].before')
> +attr_count="$(_scratch_xfs_db "${attr_db_args[@]}" -c 'print hdr.count' | awk '{print $3}')"
> +_scratch_xfs_db "${attr_db_args[@]}" -c "print btree[0-$((attr_count - 1))].hashval" | sed -e 's/btree\[[0-9]*\]/btree[NN]/g' | filter_hashvals
> +
> +# Remount to get some coverage of xfs_scrub before seeing if xfs_repair
> +# will trip over the large dabtrees.
> +echo Silence is golden
> +_scratch_mount
> +status=0
> +exit
> diff --git a/tests/xfs/861.out b/tests/xfs/861.out
> new file mode 100644
> index 0000000000..d11b76c82e
> --- /dev/null
> +++ b/tests/xfs/861.out
> @@ -0,0 +1,2 @@
> +QA output created by 861
> +Silence is golden
> 

