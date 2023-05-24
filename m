Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFC9C77B7E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 02:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbjEXCjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 22:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbjEXCi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 22:38:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6823C186
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 19:38:57 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QQwH90vRhzTkgj;
        Wed, 24 May 2023 10:33:57 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 10:38:54 +0800
Message-ID: <63278dba-4dc1-0f72-69ea-4f831817ad95@huawei.com>
Date:   Wed, 24 May 2023 10:38:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] xfs: fix the problem of mount failure caused by not
 refreshing mp->m_sb
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        <yangerkun@huawei.com>, <yi.zhang@huawei.com>,
        <chengzhihao1@huawei.com>
References: <38fc8e93-a4be-7eef-ebd6-fa3cb31b9dee@huawei.com>
 <20230523162220.GG11620@frogsfrogsfrogs>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20230523162220.GG11620@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/5/24 0:22, Darrick J. Wong 写道:
> On Tue, May 23, 2023 at 02:25:54PM +0800, Wu Guanghao wrote:
>> After testing xfs_growfs + fsstress + fault injection, the following stack appeared
>> when mounting the filesystem:
>>
>> [  149.902032] XFS (loop0): xfs_buf_map_verify: daddr 0x200001 out of range, EOFS 0x200000
>> [  149.902072] WARNING: CPU: 12 PID: 3045 at fs/xfs/xfs_buf.c:535 xfs_buf_get_map+0x5ae/0x650 [xfs]
>> ...
>> [  149.902473]  xfs_buf_read_map+0x59/0x330 [xfs]
>> [  149.902621]  ? xlog_recover_items_pass2+0x55/0xd0 [xfs]
>> [  149.902809]  xlog_recover_buf_commit_pass2+0xff/0x640 [xfs]
>> [  149.902959]  ? xlog_recover_items_pass2+0x55/0xd0 [xfs]
>> [  149.903104]  xlog_recover_items_pass2+0x55/0xd0 [xfs]
>> [  149.903247]  xlog_recover_commit_trans+0x2e0/0x330 [xfs]
>> [  149.903390]  xlog_recovery_process_trans+0x8e/0xf0 [xfs]
>> [  149.903531]  xlog_recover_process_data+0x9c/0x130 [xfs]
>> [  149.903687]  xlog_do_recovery_pass+0x3cc/0x5d0 [xfs]
>> [  149.903843]  xlog_do_log_recovery+0x5c/0x80 [xfs]
>> [  149.903984]  xlog_do_recover+0x33/0x1c0 [xfs]
>> [  149.904125]  xlog_recover+0xdd/0x190 [xfs]
>> [  149.904265]  xfs_log_mount+0x125/0x2f0 [xfs]
>> [  149.904410]  xfs_mountfs+0x41a/0x910 [xfs]
>> [  149.904558]  ? __pfx_xfs_fstrm_free_func+0x10/0x10 [xfs]
>> [  149.904725]  xfs_fs_fill_super+0x4b7/0x940 [xfs]
>> [  149.904873]  ? __pfx_xfs_fs_fill_super+0x10/0x10 [xfs]
>> [  149.905016]  get_tree_bdev+0x19a/0x280
>> [  149.905020]  vfs_get_tree+0x29/0xd0
>> [  149.905023]  path_mount+0x69e/0x9b0
>> [  149.905026]  do_mount+0x7d/0xa0
>> [  149.905029]  __x64_sys_mount+0xdc/0x100
>> [  149.905032]  do_syscall_64+0x3e/0x90
>> [  149.905035]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>
>> The trigger process is as follows:
>>
>> 1. Growfs size from 0x200000 to 0x300000
>> 2. Using the space range of 0x200000~0x300000
>> 3. The above operations have only been written to the log area on disk
>> 4. Fault injection and shutdown filesystem
>> 5. Mount the filesystem and replay the log about growfs, but only modify the
>>  superblock buffer without modifying the mp->m_sb structure in memory
>> 6. Continuing the log replay, at this point we are replaying operation 2, then
>>  it was discovered that the blocks used more than mp->m_sb.sb_dblocks
>>
>> Therefore, during log replay, if there are any modifications made to the
>> superblock, we should refresh the information recorded in the mp->m_sb.
> 
> Heh, clever.  Thanks for supplying a patch. :)
> 
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>  fs/xfs/xfs_buf_item_recover.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
>> index 43167f543afc..2ac3d2083188 100644
>> --- a/fs/xfs/xfs_buf_item_recover.c
>> +++ b/fs/xfs/xfs_buf_item_recover.c
>> @@ -22,6 +22,8 @@
>>  #include "xfs_inode.h"
>>  #include "xfs_dir2.h"
>>  #include "xfs_quota.h"
>> +#include "xfs_sb.h"
>> +#include "xfs_ag.h"
>>
>>  /*
>>   * This is the number of entries in the l_buf_cancel_table used during
>> @@ -969,6 +971,29 @@ xlog_recover_buf_commit_pass2(
>>                         goto out_release;
>>         } else {
>>                 xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>> +               /*
>> +                * If the superblock buffer is modified, we also need to modify the
>> +                * content of the mp.
>> +                */
>> +               if (bp->b_maps[0].bm_bn == XFS_SB_DADDR && bp->b_ops) {
>> +                       struct xfs_dsb *sb = bp->b_addr;
> 
> I think the body of this if statement ought to be a separate function,
> e.g.
> 
> STATIC int
> xlog_recover_sb_buffer(...)
> {
> 	struct xfs_dsb *sb = bp->b_addr;
> 
> 	bp->b_ops->verify_write(bp);
> 	...
> }
> 
> Also, I think the callsite is better placed at the end of
> xlog_recover_do_reg_buffer.
> 
>> +
>> +                       bp->b_ops->verify_write(bp);
> 
> I was about to ask why you ran the full write verifier here instead of
> calling ->verify_struct (which skips the crc computation), but then I
> realized:
> 
> const struct xfs_buf_ops xfs_sb_buf_ops = {
> 	.name = "xfs_sb",
> 	.magic = { cpu_to_be32(XFS_SB_MAGIC), cpu_to_be32(XFS_SB_MAGIC) },
> 	.verify_read = xfs_sb_read_verify,
> 	.verify_write = xfs_sb_write_verify,
> };
> 
> So, heh.  No structure verifier.  I think for completeness
> xfs_sb_buf_ops ought to have one, but I'm willing to live with this for
> now.
> 
>> +                       error = bp->b_error;
>> +                       if (error)
>> +                               goto out_release;
>> +
>> +                       if (be32_to_cpu(sb->sb_agcount) > mp->m_sb.sb_agcount) {
>> +                               error = xfs_initialize_perag(mp,
>> +                                                       be32_to_cpu(sb->sb_agcount),
>> +                                                       be64_to_cpu(sb->sb_dblocks),
>> +                                                       &mp->m_maxagi);
>> +                               if (error)
>> +                                       goto out_release;
> 
> Might want to log a message here that the perag init is what killed log
> recovery.
> 
> Other than those reorganization suggestions, I think this looks correct.
> Would you mind submitting your testcase to fstests?
> 
> --D

Thank you for your suggestion. I will make the changes in the v2 version.
And we will try to submit test cases in the future.

Thanks,
Guanghao

> 
>> +                       }
>> +
>> +                       xfs_sb_from_disk(&mp->m_sb, sb);
>> +               }
>>         }
>>
>>         /*
>> --
>> 2.27.0
> .
> 
