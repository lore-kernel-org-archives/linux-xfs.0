Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AAEC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C6D22C9D
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437379AbhARTxD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393978AbhART0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 14:26:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF0C061575
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 11:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ZQUZg4Jg2jJSYaPpR2okT0s1Ov2qMwjDEurE576L6OE=; b=o2moRX+ek9MbE3etaTibaLMdXJ
        n4OP0RKS9v0afoSsojR5hx21zc7A8Id0fkDeJ+2wA8QGRkKIxJuMexlIUEwC5SAzrKCNTtX4K0yIR
        bRt82k73hf4065nHaVAM3HCSO26LwIbLXIxpvkHb813AKDtYxYO0ArzvPYy54BY5/asTDXeWHPxa0
        A4tVq9TwqS8pe0PHfb/nI4uRZ95mC5gLpmhr0FzqdDAJEd9m5Xwc7+aZh9VoVl8l8FqrHm0JcnlIB
        SsB+bX/gqGQJoXySRIvvDmGDay5+armeAy+QRO3/q3JbXKMBYS6Dl3RSZSjndgJUXibC5euHkso1j
        hmiYgPIA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1a9r-00DIB2-Km
        for linux-xfs@vger.kernel.org; Mon, 18 Jan 2021 19:25:47 +0000
Date:   Mon, 18 Jan 2021 19:25:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     linux-xfs@vger.kernel.org
Subject: assertation failures in generic/388
Message-ID: <20210118192547.GA3167248@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

latest Linus' tree crashes every few runs for me when running on x86_64,
4k block size, virtio-blk, CONFIG_XFS_DEBUG enabled:

Dmesg:
[   93.950923] XFS: Assertion failed: percpu_counter_compare(&mp->m_ifree, 0) >5
[   93.953038] ------------[ cut here ]------------
[   93.953688] kernel BUG at fs/xfs/xfs_message.c:110!
[   93.954960] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[   93.955765] CPU: 2 PID: 5064 Comm: fsstress Not tainted 5.11.0-rc4 #445
[   93.956857] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.144
[   93.958310] RIP: 0010:assfail+0x1e/0x23
[   93.958912] Code: a0 87 04 83 e8 85 fc ff ff 0f 0b c3 41 89 c8 48 89 d1 48 84
[   93.962114] RSP: 0018:ffffc90002dc3a40 EFLAGS: 00010202
[   93.962828] RAX: 0000000000000000 RBX: ffff88810ce39000 RCX: 0000000000000000
[   93.963809] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82fb4471
[   93.964799] RBP: ffff88810d7d0258 R08: 0000000000000000 R09: 000000000000000a
[   93.965764] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
[   93.966698] R13: ffff88810ce39520 R14: ffffffffffffffff R15: ffff88810d7d0310
[   93.967593] FS:  00007fd84a28db80(0000) GS:ffff88813bd00000(0000) knlGS:00000
[   93.968605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.969354] CR2: 00007fd84a492000 CR3: 000000010d7da000 CR4: 00000000000006e0
[   93.970290] Call Trace:
[   93.970607]  xfs_trans_unreserve_and_mod_sb+0x1ed/0x270
[   93.971423]  xfs_log_commit_cil+0x598/0xac0
[   93.972222]  __xfs_trans_commit+0xbe/0x3e0
[   93.972820]  xfs_create+0x551/0x630
[   93.973333]  xfs_generic_create+0x240/0x320
[   93.973941]  ? d_splice_alias+0x169/0x490
[   93.974473]  lookup_open.isra.0+0x2da/0x610
[   93.975011]  path_openat+0x261/0x920
[   93.975466]  do_filp_open+0x83/0x130
[   93.975922]  ? _raw_spin_unlock+0x24/0x40
[   93.976434]  ? alloc_fd+0xf1/0x1e0
[   93.976917]  do_sys_openat2+0x92/0x150
[   93.977558]  __x64_sys_creat+0x44/0x60
[   93.978125]  do_syscall_64+0x33/0x40
[   93.978585]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   93.979241] RIP: 0033:0x7fd84a379cc4
[   93.979717] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 4c
[   93.982051] RSP: 002b:00007ffe6f490268 EFLAGS: 00000246 ORIG_RAX: 00000000005
[   93.983068] RAX: ffffffffffffffda RBX: 0000000000000047 RCX: 00007fd84a379cc4
[   93.984079] RDX: 0000000000000000 RSI: 00000000000001b6 RDI: 0000559463b37ff0
[   93.984993] RBP: 00007ffe6f4903d0 R08: fefefefefefefeff R09: fefeff36ff603365
[   93.985916] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000001b6
[   93.986935] R13: 0000000000000001 R14: 00007ffe6f490470 R15: 00005594625041c0
[   93.987971] Modules linked in:

