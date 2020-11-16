Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,STOX_REPLY_TYPE,STOX_REPLY_TYPE_WITHOUT_QUOTES autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11082C63697
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 17:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF9FE22265
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 17:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="o3MS2ZJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbgKPRpv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733186AbgKPRpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 12:45:50 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA241C0613CF
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 09:45:50 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id d142so58876wmd.4
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 09:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:from:to:subject:date:mime-version
         :content-transfer-encoding:importance;
        bh=YwRQtBVUf3uBkWXzloCl0kvQWZO4XGlSKuh8J1GVydU=;
        b=o3MS2ZJNj4/LOODy+JfZvVZaNg98cPrsNXjNaAbenr2r3ymeag2sZfgTOh0crQSioM
         B16l63/TiBvjtbMSdFipbNm88prFg4oke0Y8zEEkTXABebWZBrP3gBg772rXuq3g2f7p
         mNRTcXfO3DPtuiLH4A1dLW5bR8ARjX2F/QwBcI8tWk8bypFMqi2hQuPzu4sClH0feCa+
         aIYDJG5gN6uI53i2FPSbynxipzcDND2DOoZdAVQ/iyt9Aj1ZmD4Ez5HmM7/RkirsHy6x
         7EOECWpkrz2ja5vfSOZVao/ZH0nUbxF+9AgO6O+J1nk8eCm2G78UHkLIEgaK6E46ibSe
         BqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:subject:date:mime-version
         :content-transfer-encoding:importance;
        bh=YwRQtBVUf3uBkWXzloCl0kvQWZO4XGlSKuh8J1GVydU=;
        b=PWiZ1vG92LdsGESNdnW/+68nwBVtg6vUk7T6Y5iVhJXF7OdUEvbhSq+TIdS09NAeHp
         Ld1fTMMqik8sHfhdPZhDyTm55JFnDB9+IdTJHGw21Uw/DPx2rrSMiERs+uv8NBOl6IJF
         jOmbNP/ATPFSXU0JR6NfarNayMOa3xhDAU8bzyX8i6LdMxE9NStvOX57S2Fhjm39jRk3
         Smd7ehe/MAA4Yi6yXnl92KzfZ5xwL6BNjqiKPgxLo32ihOAEjFHC4HelGZtEVOWkIJkm
         H3YZql2f4AFfoAUGDJN78oqvST5exrRq1H5m0/g46RZOD9Pvq0X6bi9EYep3V3LeGhJk
         wu2w==
X-Gm-Message-State: AOAM532M4ycWWHL8ONZG91VBys6onRbgNaGe5zOWP5MPYeXCwuer+rLp
        UbTQlZhlWSRJEpE3Zat2FviYo7NJgXjlDCaw
X-Google-Smtp-Source: ABdhPJy4SpBKH8tRGxgbImtsw9Ll//22A6nzRVhqNM1xLx12YsM8dwCFqVliatM7JIl8e2neoFj5hA==
X-Received: by 2002:a05:600c:288:: with SMTP id 8mr45811wmk.106.1605548748863;
        Mon, 16 Nov 2020 09:45:48 -0800 (PST)
Received: from alyakaslap ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id f11sm23358632wrs.70.2020.11.16.09.45.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 09:45:48 -0800 (PST)
Message-ID: <5582F682900B483C89460123ABE79292@alyakaslap>
From:   "Alex Lyakas" <alex@zadara.com>
To:     <linux-xfs@vger.kernel.org>
Subject: RCU stall in xfs_reclaim_inodes_ag
Date:   Mon, 16 Nov 2020 19:45:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Greetings XFS community,

We had an RCU stall [1]. According to the code, it happened in 
radix_tree_gang_lookup_tag():

rcu_read_lock();
nr_found = radix_tree_gang_lookup_tag(
        &pag->pag_ici_root,
        (void **)batch, first_index,
        XFS_LOOKUP_BATCH,
        XFS_ICI_RECLAIM_TAG);


This XFS system has over 100M files. So perhaps looping inside the radix 
tree took too long, and it was happening in RCU read-side critical seciton. 
This is one of the possible causes for RCU stall.

This happened in kernel 4.14.99, but looking at latest mainline code, code 
is still the same.

Can anyone please advise how to address that? It is not possible to put 
cond_resched() inside the radix tree code, because it can be used with 
spinlocks, and perhaps other contexts where sleeping is not allowed.

Thanks,
Alex.


[1]
Nov 16 12:33:15.314001 vsa-0000002a-vc-1 kernel: [78961.809221] INFO: 
rcu_preempt detected stalls on CPUs/tasks:
Nov 16 12:33:15.314031 vsa-0000002a-vc-1 kernel: [78961.810785]     Tasks 
blocked on level-0 rcu_node (CPUs 0-4): P8854
Nov 16 12:33:15.314033 vsa-0000002a-vc-1 kernel: [78961.812141] 
(detected by 3, t=60004 jiffies, g=18947673, c=18947672, q=110854)
Nov 16 12:33:15.314036 vsa-0000002a-vc-1 kernel: [78961.814050] python 
R  running task        0  8854   8792 0x00000000
Nov 16 12:33:15.314038 vsa-0000002a-vc-1 kernel: [78961.814054] Call Trace:
Nov 16 12:33:15.314040 vsa-0000002a-vc-1 kernel: [78961.814067]  ? 
__schedule+0x290/0x8a0
Nov 16 12:33:15.314041 vsa-0000002a-vc-1 kernel: [78961.814070] 
preempt_schedule_irq+0x37/0x60
Nov 16 12:33:15.314043 vsa-0000002a-vc-1 kernel: [78961.814074] 
retint_kernel+0x1b/0x1d
Nov 16 12:33:15.314044 vsa-0000002a-vc-1 kernel: [78961.814079] RIP: 
0010:radix_tree_next_chunk+0x111/0x320
Nov 16 12:33:15.314045 vsa-0000002a-vc-1 kernel: [78961.814080] RSP: 
0018:ffffb31f5fbab7d0 EFLAGS: 00000287 ORIG_RAX: ffffffffffffff10
Nov 16 12:33:15.314047 vsa-0000002a-vc-1 kernel: [78961.814082] RAX: 
0000000000000033 RBX: 0000000000000010 RCX: 000000000000000c
Nov 16 12:33:15.314049 vsa-0000002a-vc-1 kernel: [78961.814083] RDX: 
0000000000000000 RSI: ffffb31f5fbab818 RDI: 00000000000b3000
Nov 16 12:33:15.314051 vsa-0000002a-vc-1 kernel: [78961.814084] RBP: 
ffffa07dd6d80b48 R08: ffffa08079fe56d0 R09: ffffa08079fe6481
Nov 16 12:33:15.314052 vsa-0000002a-vc-1 kernel: [78961.814085] R10: 
000000000000000c R11: ffffa08079fe5890 R12: 000000000000000c
Nov 16 12:33:15.314054 vsa-0000002a-vc-1 kernel: [78961.814086] R13: 
0000000000000040 R14: 0000000000000228 R15: 0000000000033000
Nov 16 12:33:15.314055 vsa-0000002a-vc-1 kernel: [78961.814090] 
radix_tree_gang_lookup_tag+0xd6/0x160
Nov 16 12:33:15.314056 vsa-0000002a-vc-1 kernel: [78961.814152] 
xfs_reclaim_inodes_ag+0xd5/0x310 [xfs]
Nov 16 12:33:15.314058 vsa-0000002a-vc-1 kernel: [78961.814199] 
xfs_reclaim_inodes_nr+0x3c/0x50 [xfs]
Nov 16 12:33:15.314059 vsa-0000002a-vc-1 kernel: [78961.814204] 
super_cache_scan+0x156/0x1a0
Nov 16 12:33:15.314061 vsa-0000002a-vc-1 kernel: [78961.814210] 
shrink_slab.part.51+0x1e8/0x400
Nov 16 12:33:15.314062 vsa-0000002a-vc-1 kernel: [78961.814213] 
shrink_node+0x123/0x310
Nov 16 12:33:15.314063 vsa-0000002a-vc-1 kernel: [78961.814216] 
do_try_to_free_pages+0xc3/0x330
Nov 16 12:33:15.314064 vsa-0000002a-vc-1 kernel: [78961.814218] 
try_to_free_pages+0xf4/0x1f0
Nov 16 12:33:15.314065 vsa-0000002a-vc-1 kernel: [78961.814224] 
__alloc_pages_slowpath+0x3a5/0xd50
Nov 16 12:33:15.314067 vsa-0000002a-vc-1 kernel: [78961.814228] 
__alloc_pages_nodemask+0x2a7/0x2d0
Nov 16 12:33:15.314068 vsa-0000002a-vc-1 kernel: [78961.814232] 
alloc_pages_vma+0x7c/0x1e0
Nov 16 12:33:15.314070 vsa-0000002a-vc-1 kernel: [78961.814236] 
__handle_mm_fault+0x90c/0x12f0
Nov 16 12:33:15.314071 vsa-0000002a-vc-1 kernel: [78961.814239] 
handle_mm_fault+0xb1/0x1e0
Nov 16 12:33:15.314072 vsa-0000002a-vc-1 kernel: [78961.814244] 
__do_page_fault+0x278/0x530
Nov 16 12:33:15.314073 vsa-0000002a-vc-1 kernel: [78961.814247]  ? 
async_page_fault+0x2f/0x50
Nov 16 12:33:15.314074 vsa-0000002a-vc-1 kernel: [78961.814248] 
async_page_fault+0x45/0x50

