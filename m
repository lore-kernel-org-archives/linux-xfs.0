Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAFFC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 20:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848F322C9D
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 20:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437702AbhARUDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437800AbhARUC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 15:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611000089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CRU3/z6+AU5PH5tPnFaH5EDbP82Ap0b58KhWRQdCdA4=;
        b=I+qyU8w/YgL3KjRmEzTPGetBmmom1W3HDZO7x2r7mh1A1KgBQ495awu3gMrDEI5s8JORBW
        y94ZTktEg5Uym+J3Zs/PjbxxAtF+iPIBp19Q2SA5PmgBKsulfxmNERN1VbRCDCwnK0bm5m
        onO2r3t+/SgOog9xMqcPU1US20JQauw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-bxiMWi4aPseGotF_UllEsw-1; Mon, 18 Jan 2021 15:01:27 -0500
X-MC-Unique: bxiMWi4aPseGotF_UllEsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 005F6192FDA2;
        Mon, 18 Jan 2021 20:01:26 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A41AE5E1A8;
        Mon, 18 Jan 2021 20:01:25 +0000 (UTC)
Date:   Mon, 18 Jan 2021 15:01:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: assertation failures in generic/388
Message-ID: <20210118200123.GA1537873@bfoster>
References: <20210118192547.GA3167248@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118192547.GA3167248@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 07:25:47PM +0000, Christoph Hellwig wrote:
> Hi all,
> 
> latest Linus' tree crashes every few runs for me when running on x86_64,
> 4k block size, virtio-blk, CONFIG_XFS_DEBUG enabled:
> 
> Dmesg:
> [   93.950923] XFS: Assertion failed: percpu_counter_compare(&mp->m_ifree, 0) >5

This is likely fixed by the first patch [1] in my log covering rework
series. generic/388 was recently modified to reproduce.

Brian

[1] https://lore.kernel.org/linux-xfs/20210106174127.805660-2-bfoster@redhat.com/

> [   93.953038] ------------[ cut here ]------------
> [   93.953688] kernel BUG at fs/xfs/xfs_message.c:110!
> [   93.954960] invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [   93.955765] CPU: 2 PID: 5064 Comm: fsstress Not tainted 5.11.0-rc4 #445
> [   93.956857] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.144
> [   93.958310] RIP: 0010:assfail+0x1e/0x23
> [   93.958912] Code: a0 87 04 83 e8 85 fc ff ff 0f 0b c3 41 89 c8 48 89 d1 48 84
> [   93.962114] RSP: 0018:ffffc90002dc3a40 EFLAGS: 00010202
> [   93.962828] RAX: 0000000000000000 RBX: ffff88810ce39000 RCX: 0000000000000000
> [   93.963809] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82fb4471
> [   93.964799] RBP: ffff88810d7d0258 R08: 0000000000000000 R09: 000000000000000a
> [   93.965764] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
> [   93.966698] R13: ffff88810ce39520 R14: ffffffffffffffff R15: ffff88810d7d0310
> [   93.967593] FS:  00007fd84a28db80(0000) GS:ffff88813bd00000(0000) knlGS:00000
> [   93.968605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   93.969354] CR2: 00007fd84a492000 CR3: 000000010d7da000 CR4: 00000000000006e0
> [   93.970290] Call Trace:
> [   93.970607]  xfs_trans_unreserve_and_mod_sb+0x1ed/0x270
> [   93.971423]  xfs_log_commit_cil+0x598/0xac0
> [   93.972222]  __xfs_trans_commit+0xbe/0x3e0
> [   93.972820]  xfs_create+0x551/0x630
> [   93.973333]  xfs_generic_create+0x240/0x320
> [   93.973941]  ? d_splice_alias+0x169/0x490
> [   93.974473]  lookup_open.isra.0+0x2da/0x610
> [   93.975011]  path_openat+0x261/0x920
> [   93.975466]  do_filp_open+0x83/0x130
> [   93.975922]  ? _raw_spin_unlock+0x24/0x40
> [   93.976434]  ? alloc_fd+0xf1/0x1e0
> [   93.976917]  do_sys_openat2+0x92/0x150
> [   93.977558]  __x64_sys_creat+0x44/0x60
> [   93.978125]  do_syscall_64+0x33/0x40
> [   93.978585]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   93.979241] RIP: 0033:0x7fd84a379cc4
> [   93.979717] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 4c
> [   93.982051] RSP: 002b:00007ffe6f490268 EFLAGS: 00000246 ORIG_RAX: 00000000005
> [   93.983068] RAX: ffffffffffffffda RBX: 0000000000000047 RCX: 00007fd84a379cc4
> [   93.984079] RDX: 0000000000000000 RSI: 00000000000001b6 RDI: 0000559463b37ff0
> [   93.984993] RBP: 00007ffe6f4903d0 R08: fefefefefefefeff R09: fefeff36ff603365
> [   93.985916] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000001b6
> [   93.986935] R13: 0000000000000001 R14: 00007ffe6f490470 R15: 00005594625041c0
> [   93.987971] Modules linked in:
> 

