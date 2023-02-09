Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4328EC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBIInV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBIInT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:43:19 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F462C666
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:43:14 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m14so953879wrg.13
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 00:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5WqRsXshMpg+HOoaI0zSoNdrCFquvJqvv+7JBk33T74=;
        b=tbnwC1vZQBffybVxzm6jiQfDIhsQYqBSY9Gr4eSIpDDN/SgnNu85iLmGLJZA5Ij4j+
         M1SovKb+evuWyGgpYItcTTIBaPDjbSsirXD2dZ3uxDIhTNEC8+gvK0NmXVoAedSCg5Po
         ND66EzE+MCyvqqghnXWrajjlYF6BCsZHqfmBjYPcfscD7DeQJQ8ty/0PXYg3ZjS36Sc+
         GB8U133/E25vefecDb/2FLOYWe8zxbgklyMp20gEJehG7b+OuZeO6B7No8hNwcV0uaeO
         mRgaD0PqfjaYuY7pQ9i7Ko3DCC9AIFtJTKlzTdHgntFv+rR3bRvH4RW8Smln67Truen2
         Jp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WqRsXshMpg+HOoaI0zSoNdrCFquvJqvv+7JBk33T74=;
        b=Xgl3Dh+xlDudiT6ezlSpb947cbdfBsh1lk5oNwsKVk8jYRIqHrLXIl8p8OBMHsLySO
         sC+BlXsiWlvRolIphkygNvBKJK66KyBSizdeRr8VTz5tORW8AnavUCxruU98JdG1R6VN
         4LPFIThDtUehpOsPp0HF17hNbDuIe+uO3QyhB/v60PGsAsj1SDB14wdjP5f24fTbAifD
         g52KxNan9Pxi1Wf4vOc2OtEgHW1aWDZ6u0I0whiF0W2B+N2HYuHnARteVBEosCyxOx84
         wN0M72oIsAOgbkol8EVcVCAhp78zKDNSZBFdM7Y9tu5Qy4v0hiUYxq9jz4OqzJy2Y8TL
         wvRw==
X-Gm-Message-State: AO0yUKWnOu5KZRdW1FhaW0Tm4aZQWD7L6tWgX72iH4iTcvPou1O+wuJi
        RUj3jvWJynakAA/T+a/ApJct3ny5wYKGE/4Yfq5C09n2ka3/E6eFo5mj56jdp58vCu/YeB0HKdi
        5ueadr62KXZdr0DDng5+jufjvkVleqVKY0QdqkDWryp9pY7liDbfL97UZP3e0XeAXltDd9ue/BX
        JG/BbL30eKHgiGwI3wC9N0er5hXWg8mV3baBdYpZ+PAaqXYohZ2XHT
X-Google-Smtp-Source: AK7set+rnKITKUu+e9SuOQ+5H6JtjLfsrNOmt1mNxcIxXzICrHl8yEhVX67q2BJU5mmDz9Va+yoSzQ==
X-Received: by 2002:adf:df83:0:b0:2bf:f027:3c30 with SMTP id z3-20020adfdf83000000b002bff0273c30mr9874541wrl.56.1675932192827;
        Thu, 09 Feb 2023 00:43:12 -0800 (PST)
Received: from [10.0.0.6] (bzq-79-181-202-158.red.bezeqint.net. [79.181.202.158])
        by smtp.gmail.com with ESMTPSA id o16-20020adfe810000000b002c3e698d7a4sm701332wrm.24.2023.02.09.00.43.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 00:43:12 -0800 (PST)
Message-ID: <412ef57499e8ad13c815516f11cd00479a35587a.camel@scylladb.com>
Subject: BUG: kernel NULL pointer dereference, address: 0000000000000042
From:   Avi Kivity <avi@scylladb.com>
To:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Feb 2023 10:43:10 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Workload: compilation and running unit tests. The task that crashed is
a unit test.

Kernel: 6.1.8-200.fc37.x86_64

Previously known stable on 5.8.9-200.fc32.x86_64. Two crashes seen so
far.


Feb  7 17:19:33 localhost kernel: BUG: kernel NULL pointer dereference,
address: 0000000000000042
Feb  7 17:19:33 localhost kernel: #PF: supervisor read access in kernel
mode
Feb  7 17:19:33 localhost kernel: #PF: error_code(0x0000) - not-present
page
Feb  7 17:19:33 localhost kernel: PGD 80000001cbb1f067 P4D
80000001cbb1f067 PUD 9cbb75067 PMD 0=20
Feb  7 17:19:33 localhost kernel: Oops: 0000 [#1] PREEMPT SMP PTI
Feb  7 17:19:33 localhost kernel: CPU: 24 PID: 3718328 Comm:
transport_test Tainted: G S                 6.1.8-200.fc37.x86_64 #1
Feb  7 17:19:33 localhost kernel: Hardware name: Dell Inc. PowerEdge
R730/0599V5, BIOS 2.9.1 12/04/2018
Feb  7 17:19:33 localhost kernel: RIP:
0010:next_uptodate_page+0x46/0x200
Feb  7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81 ff 06
04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00 40 f6
c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47 34 85
c0 0f 84 86 00 00 00
Feb  7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8 EFLAGS:
00010246
Feb  7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
ffffa83e4ed67e00 RCX: 000000000000146e
Feb  7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
ffff94a9046316b0 RDI: 0000000000000042
Feb  7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
000000000000146e R09: 0000000000dfd000
Feb  7 17:19:33 localhost kernel: R10: 000000000000145f R11:
ffff94978b85960c R12: ffff94a9046316b0
Feb  7 17:19:33 localhost kernel: R13: 000000000000146e R14:
ffff94a9046316b0 R15: ffff948f8bb1f000
Feb  7 17:19:33 localhost kernel: FS:  00007fd68fcb9d40(0000)
GS:ffff949dffd00000(0000) knlGS:0000000000000000
Feb  7 17:19:33 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Feb  7 17:19:33 localhost kernel: CR2: 0000000000000042 CR3:
00000001dc1be005 CR4: 00000000001706e0
Feb  7 17:19:33 localhost kernel: Call Trace:
Feb  7 17:19:33 localhost kernel: <TASK>
Feb  7 17:19:33 localhost kernel: filemap_map_pages+0x9f/0x7b0
Feb  7 17:19:33 localhost kernel: xfs_filemap_map_pages+0x41/0x60 [xfs]
Feb  7 17:19:33 localhost kernel: do_fault+0x1bf/0x430
Feb  7 17:19:33 localhost kernel: __handle_mm_fault+0x63d/0xe40
Feb  7 17:19:33 localhost kernel: ? do_sigaction+0x11a/0x240
Feb  7 17:19:33 localhost kernel: handle_mm_fault+0xdb/0x2d0
Feb  7 17:19:33 localhost kernel: do_user_addr_fault+0x1cd/0x690
Feb  7 17:19:33 localhost kernel: exc_page_fault+0x70/0x170
Feb  7 17:19:33 localhost kernel: asm_exc_page_fault+0x22/0x30
Feb  7 17:19:33 localhost kernel: RIP: 0033:0x1666350
Feb  7 17:19:33 localhost kernel: Code: Unable to access opcode bytes
at 0x1666326.
Feb  7 17:19:33 localhost kernel: RSP: 002b:00007ffde7fa86d8 EFLAGS:
00010212
Feb  7 17:19:33 localhost kernel: RAX: 0000000000000000 RBX:
00007ffde7fa8748 RCX: 0000000002ed4468
Feb  7 17:19:33 localhost kernel: RDX: 00006000000c4f50 RSI:
00007ffde7fa8748 RDI: 0000000000000012
Feb  7 17:19:33 localhost kernel: RBP: 0000000000000012 R08:
0000000000000001 R09: 0000000002f46860
Feb  7 17:19:33 localhost kernel: R10: 00007fd69219cac0 R11:
00007fd69224e670 R12: 0000000000000000
Feb  7 17:19:33 localhost kernel: R13: 00006000000c4f50 R14:
0000000002ed4470 R15: 00007fd693be0000
Feb  7 17:19:33 localhost kernel: </TASK>
Feb  7 17:19:33 localhost kernel: Modules linked in: xsk_diag veth tls
xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt_addrtype nft_compat
br_netfilter bridge stp llc intel_rapl_msr dell_wmi iTCO_wdt
dell_smbios intel_pmc_bxt iTCO_vendor_support dell_wmi_descriptor
ledtrig_audio sparse_keymap video dcdbas intel_rapl_common sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif
irqbypass rapl intel_cstate intel_uncore ipmi_si ipmi_devintf
ipmi_msghandler nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill
overlay ip_set nf_tables nfnetlink qrtr acpi_power_meter mxm_wmi mei_me
mei lpc_ich auth_rpcgss ip6_tables ip_tables sunrpc zram xfs
crct10dif_pclmul crc32_pclmul nvme crc32c_intel polyval_clmulni
polyval_generic ixgbe ghash_clmulni_intel nvme_core sha512_ssse3
megaraid_sas tg3 mgag200 mdio nvme_common dca wmi scsi_dh_rdac
scsi_dh_emc scsi_dh_alua
Feb  7 17:19:33 localhost kernel: dm_multipath fuse
Feb  7 17:19:33 localhost kernel: CR2: 0000000000000042
Feb  7 17:19:33 localhost kernel: ---[ end trace 0000000000000000 ]---
Feb  7 17:19:33 localhost kernel: RIP:
0010:next_uptodate_page+0x46/0x200
Feb  7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81 ff 06
04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00 40 f6
c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47 34 85
c0 0f 84 86 00 00 00
Feb  7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8 EFLAGS:
00010246
Feb  7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
ffffa83e4ed67e00 RCX: 000000000000146e
Feb  7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
ffff94a9046316b0 RDI: 0000000000000042
Feb  7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
000000000000146e R09: 0000000000dfd000
Feb  7 17:19:33 localhost kernel: R10: 000000000000145f R11:
ffff94978b85960c R12: ffff94a9046316b0
Feb  7 17:19:33 localhost kernel: R13: 000000000000146e R14:
ffff94a9046316b0 R15: ffff948f8bb1f000
Feb  7 17:19:33 localhost kernel: FS:  00007fd68fcb9d40(0000)
GS:ffff949dffd00000(0000) knlGS:0000000000000000
