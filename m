Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F9EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 02:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiCVChA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 22:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbiCVCg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 22:36:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B454D13E86
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 19:35:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EB80B818E6
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 02:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A49C340E8;
        Tue, 22 Mar 2022 02:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647916529;
        bh=W5q0PA3KyEOrxz4dsR0A+UWNj0RyEIb2yMpBHTVphV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ECkWbklQa/aub+35BKGDwlsyUf7Tvh18jUIn4K47RnOaB/lGFJw3YKhJs7OmAVOfk
         8gHX2K+BO0vK/kjlfcFLRUP5UgnDP6S7Yyrqfp/EOToDv+IDH/Pq0CzDKdY1iLkk+q
         2nQkoj9UFGepfoxdQUGeQSuoc0HY8XGuB6By/nBJxZegag3TxAh7bBT/eK2VkE1Ea5
         T3L6hzIatqBT/iVYki8wCrBLl3uaQqdmPMJPuDuTh9sG+WH89zzURlzM6e5Xnb/dud
         brCrQvHLHI31j7C9nsT3HJ3EKY9Sn98qVP8PGJbeDYIpJgJUNw8ju9ZmrKsC2w64sU
         kKPcWGysNQydg==
Date:   Mon, 21 Mar 2022 19:35:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: more shutdown/recovery fixes
Message-ID: <20220322023528.GM8224@magnolia>
References: <20220321012329.376307-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321012329.376307-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 12:23:27PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> These two patches are followups to my recent series of
> shutdown/recovery fixes. The cluster buffer lock patch addresses a
> race condition that started to show up regularly once the fixes in
> the previous series were done - it is a regression from the async
> inode reclaim work that was done almost 2 years ago now.
> 
> The second patch is something I'm really surprised has taken this
> long to uncover. There is a check in intent recovery/cancellation
> that checks that there are no intent items in the AIL after the
> first non-intent item is found. This behaviour was correct back when
> we only had standalone intent items (i.e. EFI/EFD), but when we
> started to chain complex operations by intents, the recovery of an
> incomplete intent can log and commit new intents and they can end up
> in the AIL before log recovery is complete and finished processing
> the deferred items. Hence the ASSERT() check that no intents
> exist in the AIL after the first non-intent item is simply invalid.
> 
> With these two patches, I'm back to being able to run hundreds of
> cycles of g/388 or -g recoveryloop without seeing any failures.

Hmm, with this series applied to current for-next
+ your other log patches
+ my xfs_reserve_blocks infinite loop fix and cleanup series

I see this while running fstests on an all-defaults v5 filesystem.
I /think/ it's crashing in the "xfs_buf_ispinned(bp)" right below the
"ASSERT(iip->ili_item.li_buf);" in xfs_inode_item_push.

[ 1294.636121] run fstests generic/251 at 2022-03-21 16:06:27
[ 1295.168287] XFS (sda): Mounting V5 Filesystem
[ 1295.180601] XFS (sda): Ending clean mount
[ 1295.471352] XFS (sdf): Mounting V5 Filesystem
[ 1295.482082] XFS (sdf): Ending clean mount
[ 1295.483612] XFS (sdf): Quotacheck needed: Please wait.
[ 1295.487265] XFS (sdf): Quotacheck: Done.
[ 1376.010962] XFS (sdf): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[ 1386.006736] XFS: Assertion failed: iip->ili_item.li_buf, file: fs/xfs/xfs_inode_item.c, line: 547
[ 1386.007571] ------------[ cut here ]------------
[ 1386.007991] WARNING: CPU: 0 PID: 419577 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
[ 1386.008837] Modules linked in: btrfs blake2b_generic xor lzo_compress lzo_decompress zlib_deflate raid6_pq zstd_compress ext4 mbcache jbd2 dm_flakey dm_snapshot dm_bufio dm_zero xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip xt_REDIRECT xt_set ip_set_hash_net ip_set_hash_mac ip_set iptable_nat nf_nat nf_conntrack nfnetlink nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter ip6_tables iptable_filter bfq pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
[ 1386.012759] CPU: 0 PID: 419577 Comm: xfsaild/sdf Not tainted 5.17.0-rc6-djwx #rc6 38f9b0b98565b531708bd3bd34525d3eec280440
[ 1386.013718] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 1386.014493] RIP: 0010:assfail+0x3c/0x40 [xfs]
[ 1386.015098] Code: 90 9c 45 a0 e8 81 f9 ff ff 8a 1d d3 28 0c 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 60 81 4f a0 e8 b3 4d fd e0 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
[ 1386.016706] RSP: 0018:ffffc9000530be18 EFLAGS: 00010246
[ 1386.017172] RAX: 0000000000000000 RBX: ffff888063ace300 RCX: 0000000000000000
[ 1386.017801] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa0449eb0
[ 1386.018435] RBP: ffff88805fa897c0 R08: 0000000000000000 R09: 000000000000000a
[ 1386.019059] R10: 000000000000000a R11: f000000000000000 R12: ffff88800ad06f40
[ 1386.019685] R13: ffff88800ad06f68 R14: 00000016000191e9 R15: 0000000000000000
[ 1386.020395] FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[ 1386.021172] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1386.021680] CR2: 0000564ba4fc9968 CR3: 000000002852c002 CR4: 00000000001706b0
[ 1386.022313] Call Trace:
[ 1386.022555]  <TASK>
[ 1386.022763]  xfs_inode_item_push+0xf4/0x140 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
[ 1386.023579]  xfsaild+0x402/0xc30 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
[ 1386.024367]  ? __set_cpus_allowed_ptr_locked+0xe0/0x1a0
[ 1386.024841]  ? preempt_count_add+0x73/0xa0
[ 1386.025255]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
[ 1386.026163]  kthread+0xea/0x110
[ 1386.026487]  ? kthread_complete_and_exit+0x20/0x20
[ 1386.026924]  ret_from_fork+0x1f/0x30
[ 1386.027261]  </TASK>
[ 1386.027475] ---[ end trace 0000000000000000 ]---
[ 1386.027889] BUG: kernel NULL pointer dereference, address: 000000000000017c
[ 1386.028498] #PF: supervisor read access in kernel mode
[ 1386.028955] #PF: error_code(0x0000) - not-present page
[ 1386.029419] PGD 0 P4D 0 
[ 1386.029663] Oops: 0000 [#1] PREEMPT SMP
[ 1386.030012] CPU: 0 PID: 419577 Comm: xfsaild/sdf Tainted: G        W         5.17.0-rc6-djwx #rc6 38f9b0b98565b531708bd3bd34525d3eec280440
[ 1386.031100] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 1386.031855] RIP: 0010:xfs_inode_item_push+0x3d/0x140 [xfs]
[ 1386.032435] Code: 8b 7f 48 48 89 fb 48 8b af 90 00 00 00 4d 85 ff 0f 84 b1 00 00 00 8b 85 c8 00 00 00 41 bc 01 00 00 00 85 c0 0f 85 87 00 00 00 <41> 8b 87 7c 01 00 00 85 c0 75 7c f6 85 f8 00 00 00 02 75 73 4c 8d
[ 1386.034005] RSP: 0018:ffffc9000530be28 EFLAGS: 00010246
[ 1386.034569] RAX: 0000000000000000 RBX: ffff888063ace360 RCX: 0000000000000000
[ 1386.035230] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa0449eb0
[ 1386.035845] RBP: ffff88805fa897c0 R08: 0000000000000000 R09: 000000000000000a
[ 1386.036462] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000001
[ 1386.037069] R13: ffff88800ad06f68 R14: 00000016000191e9 R15: 0000000000000000
[ 1386.037722] FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[ 1386.038504] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1386.038998] CR2: 000000000000017c CR3: 000000002852c002 CR4: 00000000001706b0
[ 1386.039616] Call Trace:
[ 1386.039849]  <TASK>
[ 1386.040055]  xfsaild+0x402/0xc30 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
[ 1386.040800]  ? __set_cpus_allowed_ptr_locked+0xe0/0x1a0
[ 1386.041267]  ? preempt_count_add+0x73/0xa0
[ 1386.041634]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
[ 1386.042487]  kthread+0xea/0x110
[ 1386.042777]  ? kthread_complete_and_exit+0x20/0x20
[ 1386.043207]  ret_from_fork+0x1f/0x30
[ 1386.043584]  </TASK>
[ 1386.043795] Modules linked in: btrfs blake2b_generic xor lzo_compress lzo_decompress zlib_deflate raid6_pq zstd_compress ext4 mbcache jbd2 dm_flakey dm_snapshot dm_bufio dm_zero xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip xt_REDIRECT xt_set ip_set_hash_net ip_set_hash_mac ip_set iptable_nat nf_nat nf_conntrack nfnetlink nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter ip6_tables iptable_filter bfq pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
[ 1386.047627] Dumping ftrace buffer:
[ 1386.047940]    (ftrace buffer empty)
[ 1386.048267] CR2: 000000000000017c
[ 1386.048569] ---[ end trace 0000000000000000 ]---
[ 1386.049097] RIP: 0010:xfs_inode_item_push+0x3d/0x140 [xfs]
[ 1386.049704] Code: 8b 7f 48 48 89 fb 48 8b af 90 00 00 00 4d 85 ff 0f 84 b1 00 00 00 8b 85 c8 00 00 00 41 bc 01 00 00 00 85 c0 0f 85 87 00 00 00 <41> 8b 87 7c 01 00 00 85 c0 75 7c f6 85 f8 00 00 00 02 75 73 4c 8d
[ 1386.051276] RSP: 0018:ffffc9000530be28 EFLAGS: 00010246
[ 1386.051732] RAX: 0000000000000000 RBX: ffff888063ace360 RCX: 0000000000000000
[ 1386.052338] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa0449eb0
[ 1386.052945] RBP: ffff88805fa897c0 R08: 0000000000000000 R09: 000000000000000a
[ 1386.053555] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000001
[ 1386.054228] R13: ffff88800ad06f68 R14: 00000016000191e9 R15: 0000000000000000
[ 1386.054855] FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[ 1386.055535] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1386.056034] CR2: 000000000000017c CR3: 000000002852c002 CR4: 00000000001706b0
[ 1386.056653] note: xfsaild/sdf[419577] exited with preempt_count 1

--D
