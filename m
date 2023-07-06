Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F109EB64DA
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 03:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjGFDgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 23:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjGFDgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 23:36:32 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1951BCA
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 20:36:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Vmj24eM_1688614587;
Received: from 30.97.48.246(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vmj24eM_1688614587)
          by smtp.aliyun-inc.com;
          Thu, 06 Jul 2023 11:36:27 +0800
Message-ID: <6fcbbb5a-6247-bab1-0515-359e663c587f@linux.alibaba.com>
Date:   Thu, 6 Jul 2023 11:36:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [bug report][5.10] deadlock between xfs_create() and xfs_inactive()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a report from our cloud online workloads, it could
randomly happen about ~20days, and currently we have no idea
how to reproduce with some artificial testcase reliably:

The detail is as below:


(Thread 1)
already take AGF lock
loop due to inode I_FREEING

PID: 1894063 TASK: ffff954f494dc500 CPU: 5 COMMAND: postgres*
#O [ffffa141ca34f920] schedule at ffffffff9ca58505
#1 [ffffa141ca34f9b0] schedule at ffffffff9ca5899€
#2 [ffffa141ca34f9c0] schedule timeout at ffffffff9ca5c027
#3 [ffffa141ca34fa48] xfs_iget at ffffffffe1137b4f [xfs]	xfs_iget_cache_hit->	-> igrab(inode)
#4 [ffffa141ca34fb00] xfs_ialloc at ffffffffc1140ab5 [xfs]
#5 [ffffa141ca34fb80] xfs_dir_ialloc at ffffffffc1142bfc [xfs]
#6 [ffffa141ca34fc10] xfs_create at ffffffffe1142fc8 [xfs]
#7 [ffffa141ca34fca0] xfs_generic_create at ffffffffc1140229 [xfs]
...

(Thread 2)
already have inode I_FREEING
want to take AGF lock
  
PID: 202276 TASK: ffff954d142/0000 CPU:2 COMMAND: postgres*
#0  [ffffa141c12638d0] schedule at ffffffff9ca58505
#1  [ffffa141c1263960] schedule at ffffffff9ca5899c
#2  [ffffa141c1263970] schedule timeout at ffffffff9caSc0a9
#3  [ffffa141c1263988]
down at ffffffff9caSaba5
44  [ffffa141c1263a58] down at ffffffff9c146d6b
#5  [ffffa141c1263a70] xfs_buf_lock at ffffffffc112c3dc [xfs]
#6  [ffffa141c1263a80] xfs_buf_find at ffffffffc112c83d [xfs]
#7  [ffffa141c1263b18] xfs_buf_get_map at ffffffffe112cb3c [xfs]
#8  [ffffa141c1263b70] xfs_buf_read_map at ffffffffc112d175 [xfs]
#9  [ffffa141c1263bc8] xfs_trans_read_buf map at ffffffffc116404a [xfs]
#10 [ffffa141c1263c28] xfs_read_agf at ffffffffc10e1c44 [xfs]
#11 [ffffa141c1263c80] xfs_alloc_read_agf at ffffffffc10e1d0a [xfs]
#12 [ffffa141c1263cb0] xfs_agfl_free_finish item at ffffffffc115a45a [xfs]
#13 [ffffa141c1263d00] xfs_defer_finish_noroll at ffffffffe110257e [xfs]
#14 [ffffa141c1263d68] xfs_trans_commit at ffffffffe1150581 [xfs]
#15 [ffffa141c1263da8] xfs_inactive_free at ffffffffc1144084 [xfs]
#16 [ffffa141c1263dd8] xfs_inactive at ffffffffc11441f2 [xfs)
#17 [ffffa141c1263dfO] xfs_fs_destroy_inode at ffffffffc114d489 [xfs]
#18 [ffffa141€1263e10] destroy_inode at ffffffff9c3838a8
#19 [ffffa141c1263e28] dentry_kill at ffffffff9c37f5d5
#20 [ffffa141c1263e48] dput at ffffffff9c3800ab
#21 [ffffa141c1263e70] do_renameat2 at ffffffff9c376a8b
#22 [ffffa141c1263f38] sys_rename at ffffffff9c376cdc
#23 [ffffa141c1263f40] do_syscall_64 at ffffffff9ca4a4c0
#24 [ffffa141c1263f50] entry_SYSCALL_64 after hwframe at ffffffff9cc00099


I'm not sure if the mainline kernel still has the issue, but after some
code review, I guess even after defer inactivation, such inodes pending
for recycling still keep I_FREEING.  IOWs, there are still some
dependencies between inode i_state and AGF lock with different order so
it might be racy.  Since it's online workloads, it's hard to switch the
production environment to the latest kernel.

Hopefully it helps.

Thanks,
Gao Xiang
