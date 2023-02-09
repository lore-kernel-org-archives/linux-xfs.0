Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E0EC636D6
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 21:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjBIVaL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 16:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjBIVaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 16:30:10 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B1B6B350
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 13:30:06 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so7723708pjq.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 13:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JEQfuq5g1/tveL0xGFMOApB6S5VxrgDemNQxKsZ+ys=;
        b=hWe8SAjwZVrAUkmV8ToL8RadWuYrytK5P9If8b0gwHEFnVvhlLy1yNK5LMm+3YL00S
         dJ+AqQwdX/ook5TMkJhpmzVZKULOhkRzMiRPHDcAGnlFocHJXriWvAGrEqe3gmOsAPNn
         s7Pf0wJpdO79lFUU8X56sap9+50IJNFLAeaYpw15N4B1XwFiHMZWi/zNS4Up3eQ8fASg
         Ca+fDg9F7N7ICcSY2Qu+VP2GTgW1OH7S2ZtUvbV/DklpAMcNCH+kVBMQi5QdIO0c5b+w
         USI71tXrBs7hsNNeU5+TdKjIVhbr1F50hLRNpryFGlyY2pNd6l9yPfxNZSYHci9zGVpz
         Sunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JEQfuq5g1/tveL0xGFMOApB6S5VxrgDemNQxKsZ+ys=;
        b=Xm5RA04yeGPfhv+BYKQpmSp25TfiRrTm03Z5zUlXyGF3g3MhTrV0vxgaOJGQsCmR0/
         VhWCzQYPJf8v8O4hz7AZuJ48gv9sp/uFa3tnnHgIq9ULmRdKohxW0o40GdVgyBdUyh1U
         4qsklWW2PxEmzax08JPFe+2ZmrvAhk27RfwTq2qCVVx6IpGI1C090PxZnqp1FBY2FUQk
         3QSYIgc6Pur0Hn+kg+3EjEAXOBBbe21PaqtW4QzeQKhw5R2U42/+KnvHeZ/l2fGAN7ZS
         OaiISX7T/uF+5LFQdtqN6NDQcijhcC0+YY5knBCzkDOxjp4v1LkUCnDXlMkQ7Xixeap+
         4IlA==
X-Gm-Message-State: AO0yUKUOPt6hj+AgeXQdrcKy4RKxVxaTE2YdFs95JKM/na4qw3If/PiV
        KJUZTs2wm7x21XF+LDxhRES79Q==
X-Google-Smtp-Source: AK7set9q1qQF4hi8aVcruNxRfQWocGFjWU6iwvDenG6EfCK15PnWuizvf75vFBUfSjJqgrzssRvtdw==
X-Received: by 2002:a17:903:1107:b0:196:89c9:20f4 with SMTP id n7-20020a170903110700b0019689c920f4mr14736583plh.7.1675978206078;
        Thu, 09 Feb 2023 13:30:06 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id a21-20020a170902ee9500b00199190b00efsm1973190pld.97.2023.02.09.13.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:30:05 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pQEUU-00DNoZ-5S; Fri, 10 Feb 2023 08:30:02 +1100
Date:   Fri, 10 Feb 2023 08:30:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Avi Kivity <avi@scylladb.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000042
Message-ID: <20230209213002.GF360264@dread.disaster.area>
References: <412ef57499e8ad13c815516f11cd00479a35587a.camel@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412ef57499e8ad13c815516f11cd00479a35587a.camel@scylladb.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc willy, linux-mm, as it crashed walking the page cache in the
generic fault code]

On Thu, Feb 09, 2023 at 10:43:10AM +0200, Avi Kivity wrote:
> Workload: compilation and running unit tests. The task that crashed is
> a unit test.
> 
> Kernel: 6.1.8-200.fc37.x86_64
> 
> Previously known stable on 5.8.9-200.fc32.x86_64. Two crashes seen so
> far.
> 
> 
> Feb  7 17:19:33 localhost kernel: BUG: kernel NULL pointer dereference,
> address: 0000000000000042
> Feb  7 17:19:33 localhost kernel: #PF: supervisor read access in kernel
> mode
> Feb  7 17:19:33 localhost kernel: #PF: error_code(0x0000) - not-present
> page
> Feb  7 17:19:33 localhost kernel: PGD 80000001cbb1f067 P4D
> 80000001cbb1f067 PUD 9cbb75067 PMD 0 
> Feb  7 17:19:33 localhost kernel: Oops: 0000 [#1] PREEMPT SMP PTI
> Feb  7 17:19:33 localhost kernel: CPU: 24 PID: 3718328 Comm:
> transport_test Tainted: G S                 6.1.8-200.fc37.x86_64 #1
> Feb  7 17:19:33 localhost kernel: Hardware name: Dell Inc. PowerEdge
> R730/0599V5, BIOS 2.9.1 12/04/2018
> Feb  7 17:19:33 localhost kernel: RIP:
> 0010:next_uptodate_page+0x46/0x200
> Feb  7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81 ff 06
> 04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00 40 f6
> c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47 34 85
> c0 0f 84 86 00 00 00
> Feb  7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8 EFLAGS:
> 00010246
> Feb  7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
> ffffa83e4ed67e00 RCX: 000000000000146e
> Feb  7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
> ffff94a9046316b0 RDI: 0000000000000042
> Feb  7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
> 000000000000146e R09: 0000000000dfd000
> Feb  7 17:19:33 localhost kernel: R10: 000000000000145f R11:
> ffff94978b85960c R12: ffff94a9046316b0
> Feb  7 17:19:33 localhost kernel: R13: 000000000000146e R14:
> ffff94a9046316b0 R15: ffff948f8bb1f000
> Feb  7 17:19:33 localhost kernel: FS:  00007fd68fcb9d40(0000)
> GS:ffff949dffd00000(0000) knlGS:0000000000000000
> Feb  7 17:19:33 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Feb  7 17:19:33 localhost kernel: CR2: 0000000000000042 CR3:
> 00000001dc1be005 CR4: 00000000001706e0
> Feb  7 17:19:33 localhost kernel: Call Trace:
> Feb  7 17:19:33 localhost kernel: <TASK>
> Feb  7 17:19:33 localhost kernel: filemap_map_pages+0x9f/0x7b0
> Feb  7 17:19:33 localhost kernel: xfs_filemap_map_pages+0x41/0x60 [xfs]
> Feb  7 17:19:33 localhost kernel: do_fault+0x1bf/0x430
> Feb  7 17:19:33 localhost kernel: __handle_mm_fault+0x63d/0xe40
> Feb  7 17:19:33 localhost kernel: ? do_sigaction+0x11a/0x240
> Feb  7 17:19:33 localhost kernel: handle_mm_fault+0xdb/0x2d0
> Feb  7 17:19:33 localhost kernel: do_user_addr_fault+0x1cd/0x690
> Feb  7 17:19:33 localhost kernel: exc_page_fault+0x70/0x170
> Feb  7 17:19:33 localhost kernel: asm_exc_page_fault+0x22/0x30
> Feb  7 17:19:33 localhost kernel: RIP: 0033:0x1666350
> Feb  7 17:19:33 localhost kernel: Code: Unable to access opcode bytes
> at 0x1666326.
> Feb  7 17:19:33 localhost kernel: RSP: 002b:00007ffde7fa86d8 EFLAGS:
> 00010212
> Feb  7 17:19:33 localhost kernel: RAX: 0000000000000000 RBX:
> 00007ffde7fa8748 RCX: 0000000002ed4468
> Feb  7 17:19:33 localhost kernel: RDX: 00006000000c4f50 RSI:
> 00007ffde7fa8748 RDI: 0000000000000012
> Feb  7 17:19:33 localhost kernel: RBP: 0000000000000012 R08:
> 0000000000000001 R09: 0000000002f46860
> Feb  7 17:19:33 localhost kernel: R10: 00007fd69219cac0 R11:
> 00007fd69224e670 R12: 0000000000000000
> Feb  7 17:19:33 localhost kernel: R13: 00006000000c4f50 R14:
> 0000000002ed4470 R15: 00007fd693be0000
> Feb  7 17:19:33 localhost kernel: </TASK>
> Feb  7 17:19:33 localhost kernel: Modules linked in: xsk_diag veth tls
> xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt_addrtype nft_compat
> br_netfilter bridge stp llc intel_rapl_msr dell_wmi iTCO_wdt
> dell_smbios intel_pmc_bxt iTCO_vendor_support dell_wmi_descriptor
> ledtrig_audio sparse_keymap video dcdbas intel_rapl_common sb_edac
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif
> irqbypass rapl intel_cstate intel_uncore ipmi_si ipmi_devintf
> ipmi_msghandler nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
> nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
> nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill
> overlay ip_set nf_tables nfnetlink qrtr acpi_power_meter mxm_wmi mei_me
> mei lpc_ich auth_rpcgss ip6_tables ip_tables sunrpc zram xfs
> crct10dif_pclmul crc32_pclmul nvme crc32c_intel polyval_clmulni
> polyval_generic ixgbe ghash_clmulni_intel nvme_core sha512_ssse3
> megaraid_sas tg3 mgag200 mdio nvme_common dca wmi scsi_dh_rdac
> scsi_dh_emc scsi_dh_alua
> Feb  7 17:19:33 localhost kernel: dm_multipath fuse
> Feb  7 17:19:33 localhost kernel: CR2: 0000000000000042
> Feb  7 17:19:33 localhost kernel: ---[ end trace 0000000000000000 ]---
> Feb  7 17:19:33 localhost kernel: RIP:
> 0010:next_uptodate_page+0x46/0x200
> Feb  7 17:19:33 localhost kernel: Code: 0f 84 3f 01 00 00 48 81 ff 06
> 04 00 00 0f 84 b3 00 00 00 48 81 ff 02 04 00 00 0f 84 37 01 00 00 40 f6
> c7 01 0f 85 9c 00 00 00 <48> 8b 07 a8 01 0f 85 91 00 00 00 8b 47 34 85
> c0 0f 84 86 00 00 00
> Feb  7 17:19:33 localhost kernel: RSP: 0000:ffffa83e4ed67cc8 EFLAGS:
> 00010246
> Feb  7 17:19:33 localhost kernel: RAX: 0000000000000042 RBX:
> ffffa83e4ed67e00 RCX: 000000000000146e
> Feb  7 17:19:33 localhost kernel: RDX: ffffa83e4ed67d20 RSI:
> ffff94a9046316b0 RDI: 0000000000000042
> Feb  7 17:19:33 localhost kernel: RBP: ffffa83e4ed67d20 R08:
> 000000000000146e R09: 0000000000dfd000
> Feb  7 17:19:33 localhost kernel: R10: 000000000000145f R11:
> ffff94978b85960c R12: ffff94a9046316b0
> Feb  7 17:19:33 localhost kernel: R13: 000000000000146e R14:
> ffff94a9046316b0 R15: ffff948f8bb1f000
> Feb  7 17:19:33 localhost kernel: FS:  00007fd68fcb9d40(0000)
> GS:ffff949dffd00000(0000) knlGS:0000000000000000
> 

-- 
Dave Chinner
david@fromorbit.com
