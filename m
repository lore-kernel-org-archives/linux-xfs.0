Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825DAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 06:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbhKXHC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Nov 2021 02:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhKXHC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Nov 2021 02:02:28 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9958AC061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 22:59:19 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t4so1283653pgn.9
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 22:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=hbgVkXJ+p7q+3ilxJVL0B2BOmWPqZ3VxhVs8S0D1Kko=;
        b=Hwlc50o+L/8ivl/tGhujcixJ1mekx1inmmjNiOj47SvOAh+SVhe4KikZ/hTXnqbvlo
         eVudPf22Hd3q7qHFNsLnF19swJz5ZHZa9jEjt2+xZonWEfLSldoTOIgr1eohuyXlQxkG
         HlAao2QtTQh2jLlrkOjPT2KKrO85fVxLjeSK6+riQ1GcqGmHG2/B5kGUCUnTZdGcx1f5
         02/jjTjiWdL3GwscmlZ5SbYA0m/vJaqNbUYawTEocCV+c0qhKDNYodBPOGxpHOzX3TQC
         7OCkBm1dQPUYzyg+dZ56UnoSZ+rBCRtpnirpVbMzcQw60LAk+HLC0mvbWiaZJ9op+N/d
         pmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=hbgVkXJ+p7q+3ilxJVL0B2BOmWPqZ3VxhVs8S0D1Kko=;
        b=HyZhNjwYnc3N7R5CvemibZ0Q/n8dXkDvg1xRV4MY6hrGMEgjUgif7qR02hiGnfiT+b
         49T0kz2ieIyA1PMaYp/7ZhmKUxuNFhbTyjgTayStx+pH1ZH2tKHwEqkDM6tP4kiKSf18
         5K9uEdbu1SzeKRwWlWtCBY3vl9G0/Edm9p5rHP+Q0/smUUADN1D9VvXViev12h2v1aOf
         K/IyAXx7a494DI4xd3kfaNNF6iQtkG5sz2MGIljAyg5I4eUAeOhKaxMpic72uH2x+ten
         Q2XO0AjthtkDhnPc7/GhkUH/kSyrKk+pa3kJrpKB1uTQagTJ/eGx+RHyBQ83DoSjEYv+
         9VPQ==
X-Gm-Message-State: AOAM531JvExv7ssGGyZea8b36P4dhz8wgiw8O2VU/sHCW4/9rEscIUnf
        BdHxM5lcv8gVaMYd3bokXY5oyWPm3Ag=
X-Google-Smtp-Source: ABdhPJz65izukCSrz85HLV6lkZcd44HRHTzuk7mJbuwJJ1I1qx0yClZJ3J2I3I+FjjiuE9OHwwj3DA==
X-Received: by 2002:a05:6a00:b8b:b0:481:16a1:abff with SMTP id g11-20020a056a000b8b00b0048116a1abffmr3511483pfj.77.1637737159144;
        Tue, 23 Nov 2021 22:59:19 -0800 (PST)
Received: from [172.20.120.5] ([162.219.34.249])
        by smtp.gmail.com with ESMTPSA id d2sm15828694pfj.42.2021.11.23.22.59.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 22:59:18 -0800 (PST)
Message-ID: <45d845e6-70c9-a52b-a8c4-f1dbf9f4a5d7@gmail.com>
Date:   Wed, 24 Nov 2021 14:59:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     linux-xfs@vger.kernel.org
From:   Wang Jianchao <jianchao.wan9@gmail.com>
Subject: [BUG] xfs deadlock due to agi and agf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi list

We are running out online tasks on centos 4.18.0-147.5.1.el8 kernel,
and we have encountered a deadlock case many times. And it looks like
a deadlock around agf and agi. 

We get a scene which has 106 backtrace of D tasks and there are mainly
6 kinds of backtrace. Most of them were waiting for AGI's lock and others
are AGF.

Since the correct order is AGI->AGF, so the backtrace trying to require
AGI's lock is more suspect, right ?

Thanks a million for any help.

AGI
================================================
[<0>] down+0x3b/0x50
[<0>] xfs_buf_lock+0x33/0x100 [xfs]
[<0>] xfs_buf_find.isra.27+0x3fa/0x630 [xfs]
[<0>] xfs_buf_get_map+0x40/0x2a0 [xfs]
[<0>] xfs_buf_read_map+0x28/0x1b0 [xfs]
[<0>] xfs_trans_read_buf_map+0xc6/0x340 [xfs]
[<0>] xfs_read_agi+0x95/0x140 [xfs]
[<0>] xfs_iunlink+0x4d/0x140 [xfs]
[<0>] xfs_remove+0x1e2/0x2d0 [xfs]
[<0>] xfs_vn_unlink+0x55/0xa0 [xfs]
[<0>] vfs_unlink+0x109/0x1a0
[<0>] do_unlinkat+0x225/0x310
[<0>] do_syscall_64+0x5b/0x1b0
[<0>] entry_SYSCALL_64_after_hwframe+0x65/0xca
[<0>] 0xffffffffffffffff
// 14/106
// xfs_droplink(), namely, add the inode to orphan list of agi
// can only be one agi, no agf, so it shouldn't be the initiator, right ?

[<0>] down+0x3b/0x50
[<0>] xfs_buf_lock+0x33/0x100 [xfs]
[<0>] xfs_buf_find.isra.27+0x3fa/0x630 [xfs]
[<0>] xfs_buf_get_map+0x40/0x2a0 [xfs]
[<0>] xfs_buf_read_map+0x28/0x1b0 [xfs]
[<0>] xfs_trans_read_buf_map+0xc6/0x340 [xfs]
[<0>] xfs_read_agi+0x95/0x140 [xfs]
[<0>] xfs_iunlink_remove+0x5b/0x430 [xfs]
[<0>] xfs_ifree+0x4a/0x160 [xfs]
[<0>] xfs_inactive_ifree+0xa1/0x1b0 [xfs]
[<0>] xfs_inactive+0x9e/0x140 [xfs]
[<0>] xfs_fs_destroy_inode+0xa8/0x1c0 [xfs]
[<0>] do_unlinkat+0x256/0x310
[<0>] do_syscall_64+0x5b/0x1b0
[<0>] entry_SYSCALL_64_after_hwframe+0x65/0xca
[<0>] 0xffffffffffffffff
// 6/106
// remove the inode from orphan list of agi
// this is after truncate which need to lock agf, but in differernt transaction
// so it's also safe...

[<0>] down+0x3b/0x50
[<0>] xfs_buf_lock+0x33/0x100 [xfs]
[<0>] xfs_buf_find.isra.27+0x3fa/0x630 [xfs]
[<0>] xfs_buf_get_map+0x40/0x2a0 [xfs]
[<0>] xfs_buf_read_map+0x28/0x1b0 [xfs]
[<0>] xfs_trans_read_buf_map+0xc6/0x340 [xfs]
[<0>] xfs_read_agi+0x95/0x140 [xfs]
[<0>] xfs_ialloc_read_agi+0x2f/0xd0 [xfs]
[<0>] xfs_dialloc+0xe7/0x2b0 [xfs]
[<0>] xfs_ialloc+0x6b/0x5a0 [xfs]
[<0>] xfs_dir_ialloc+0x6c/0x220 [xfs]
[<0>] xfs_create+0x227/0x5d0 [xfs]
[<0>] xfs_generic_create+0x237/0x2e0 [xfs]
[<0>] vfs_mkdir+0x102/0x1b0
[<0>] do_mkdirat+0x7d/0xf0
[<0>] do_syscall_64+0x5b/0x1b0
[<0>] entry_SYSCALL_64_after_hwframe+0x65/0xca
[<0>] 0xffffffffffffffff
// 73/106
// Can it try to get agi when holding agf ? especially, when
// xfs_ialloc_ag_alloc() doesn't get any blocks but left AGF's
// locked buf in transaction


AGF
=============================================================
[<0>] down+0x3b/0x50
[<0>] xfs_buf_lock+0x33/0x100 [xfs]
[<0>] xfs_buf_find.isra.27+0x3fa/0x630 [xfs]
[<0>] xfs_buf_get_map+0x40/0x2a0 [xfs]
[<0>] xfs_buf_read_map+0x28/0x1b0 [xfs]
[<0>] xfs_trans_read_buf_map+0xc6/0x340 [xfs]
[<0>] xfs_read_agf+0x8e/0x120 [xfs]
[<0>] xfs_alloc_read_agf+0x3e/0x1b0 [xfs]
[<0>] xfs_alloc_fix_freelist+0x3bc/0x470 [xfs]
[<0>] xfs_free_extent_fix_freelist+0x64/0xb0 [xfs]
[<0>] __xfs_free_extent+0x5e/0x150 [xfs]
[<0>] xfs_trans_free_extent+0x42/0x120 [xfs]
[<0>] xfs_extent_free_finish_item+0x26/0x40 [xfs]
[<0>] xfs_defer_finish_noroll+0x180/0x4d0 [xfs]
[<0>] xfs_defer_finish+0x13/0x70 [xfs]
[<0>] xfs_itruncate_extents_flags+0xde/0x250 [xfs]
[<0>] xfs_inactive_truncate+0xa3/0xf0 [xfs]
[<0>] xfs_inactive+0xb5/0x140 [xfs]
[<0>] xfs_fs_destroy_inode+0xa8/0x1c0 [xfs]
[<0>] do_unlinkat+0x256/0x310
[<0>] do_syscall_64+0x5b/0x1b0
[<0>] entry_SYSCALL_64_after_hwframe+0x65/0xca
[<0>] 0xffffffffffffffff
// Just truncate the data extent, there has been multi-AGF order handling in it
// order of agf ? 'xfs: fix multi-AG deadlock in xfs_bunmapi' has been introduced

[<0>] down+0x3b/0x50
[<0>] xfs_buf_lock+0x33/0x100 [xfs]
[<0>] xfs_buf_find.isra.27+0x3fa/0x630 [xfs]
[<0>] xfs_buf_get_map+0x40/0x2a0 [xfs]
[<0>] xfs_buf_read_map+0x28/0x1b0 [xfs]
[<0>] xfs_trans_read_buf_map+0xc6/0x340 [xfs]
[<0>] xfs_read_agf+0x8e/0x120 [xfs]
[<0>] xfs_alloc_read_agf+0x3e/0x1b0 [xfs]
[<0>] xfs_alloc_fix_freelist+0x3bc/0x470 [xfs]
[<0>] xfs_free_extent_fix_freelist+0x64/0xb0 [xfs]
[<0>] __xfs_free_extent+0x5e/0x150 [xfs]
[<0>] xfs_trans_free_extent+0x42/0x120 [xfs]
[<0>] xfs_extent_free_finish_item+0x26/0x40 [xfs]
[<0>] xfs_defer_finish_noroll+0x180/0x4d0 [xfs]
[<0>] __xfs_trans_commit+0x149/0x350 [xfs]
[<0>] xfs_remove+0x21d/0x2d0 [xfs]
[<0>] xfs_vn_unlink+0x55/0xa0 [xfs]
[<0>] vfs_rmdir+0x7a/0x140
[<0>] do_rmdir+0x17d/0x1e0
[<0>] do_syscall_64+0x5b/0x1b0
[<0>] entry_SYSCALL_64_after_hwframe+0x65/0xca
[<0>] 0xffffffffffffffff
//It seems that the defer operation comes from xfs_dir_removename()
//It should hold agi

[<0>] down+0x3b/0x50
[<0>] xfs_buf_lock+0x33/0x100 [xfs]
[<0>] xfs_buf_find.isra.27+0x3fa/0x630 [xfs]
[<0>] xfs_buf_get_map+0x40/0x2a0 [xfs]
[<0>] xfs_buf_read_map+0x28/0x1b0 [xfs]
[<0>] xfs_trans_read_buf_map+0xc6/0x340 [xfs]
[<0>] xfs_read_agf+0x8e/0x120 [xfs]
[<0>] xfs_alloc_read_agf+0x3e/0x1b0 [xfs]
[<0>] xfs_alloc_fix_freelist+0x3bc/0x470 [xfs]
[<0>] xfs_alloc_vextent+0x27b/0x560 [xfs]
[<0>] __xfs_inobt_alloc_block.isra.8+0xc0/0x120 [xfs]
[<0>] __xfs_btree_split.isra.38+0xdd/0x580 [xfs]
[<0>] xfs_btree_split+0x4b/0x100 [xfs]
[<0>] xfs_btree_make_block_unfull+0x192/0x1c0 [xfs]
[<0>] xfs_btree_insrec+0x41d/0x4c0 [xfs]
[<0>] xfs_btree_insert+0xcb/0x230 [xfs]
[<0>] xfs_difree_finobt+0xb9/0x1e0 [xfs]
[<0>] xfs_difree+0x11e/0x190 [xfs]
[<0>] xfs_ifree+0x82/0x160 [xfs]
[<0>] xfs_inactive_ifree+0xa1/0x1b0 [xfs]
[<0>] xfs_inactive+0x9e/0x140 [xfs]
[<0>] xfs_fs_destroy_inode+0xa8/0x1c0 [xfs]
[<0>] do_unlinkat+0x256/0x310
[<0>] do_syscall_64+0x5b/0x1b0
[<0>] entry_SYSCALL_64_after_hwframe+0x65/0xca
[<0>] 0xffffffffffffffff
// Hold agi and operate agf


Thanks
Jianchao
