Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFC7C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 16:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbjEWQWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 12:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbjEWQWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 12:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F543198
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 09:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B21963448
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 16:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1C2C4339B;
        Tue, 23 May 2023 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684858941;
        bh=8El5lfLKNCT2Sj0ezZ9HBAL7dUUMgSTFDXIQo5XdLB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNwvebJxaw5o4u8mocnauDOtu0qnH2+cSOvizyzFxMd37pf8pkjPz0emgkdLDmDYv
         LKngMypb/d3WQInUGh0UX03VYNyQvL1aZ+mToVv5a+8nul41x5u2BuuoAMxY5iYI2p
         hE5g4zr9/YUh4LPIvFIrD6+G+shnvvBa2j+3lTdzw+ZAYDTRJK+gMmI8ykpk6clA8L
         0fMzEltLW3KAX972B5C9XI+bqylxafxYQN2JoQYZr7pIOnZiT/5sA9NWsLfE0z4e0x
         bushx9hsQhGZ60izArbMyRP464CLRaEKdPLhvwKqwYMI0cuNbxjZbrPEZfPOz2ucCn
         XxQjBq8JqZZgg==
Date:   Tue, 23 May 2023 09:22:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>, yangerkun@huawei.com,
        yi.zhang@huawei.com, chengzhihao1@huawei.com
Subject: Re: [PATCH] xfs: fix the problem of mount failure caused by not
 refreshing mp->m_sb
Message-ID: <20230523162220.GG11620@frogsfrogsfrogs>
References: <38fc8e93-a4be-7eef-ebd6-fa3cb31b9dee@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38fc8e93-a4be-7eef-ebd6-fa3cb31b9dee@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:25:54PM +0800, Wu Guanghao wrote:
> After testing xfs_growfs + fsstress + fault injection, the following stack appeared
> when mounting the filesystem:
> 
> [  149.902032] XFS (loop0): xfs_buf_map_verify: daddr 0x200001 out of range, EOFS 0x200000
> [  149.902072] WARNING: CPU: 12 PID: 3045 at fs/xfs/xfs_buf.c:535 xfs_buf_get_map+0x5ae/0x650 [xfs]
> ...
> [  149.902473]  xfs_buf_read_map+0x59/0x330 [xfs]
> [  149.902621]  ? xlog_recover_items_pass2+0x55/0xd0 [xfs]
> [  149.902809]  xlog_recover_buf_commit_pass2+0xff/0x640 [xfs]
> [  149.902959]  ? xlog_recover_items_pass2+0x55/0xd0 [xfs]
> [  149.903104]  xlog_recover_items_pass2+0x55/0xd0 [xfs]
> [  149.903247]  xlog_recover_commit_trans+0x2e0/0x330 [xfs]
> [  149.903390]  xlog_recovery_process_trans+0x8e/0xf0 [xfs]
> [  149.903531]  xlog_recover_process_data+0x9c/0x130 [xfs]
> [  149.903687]  xlog_do_recovery_pass+0x3cc/0x5d0 [xfs]
> [  149.903843]  xlog_do_log_recovery+0x5c/0x80 [xfs]
> [  149.903984]  xlog_do_recover+0x33/0x1c0 [xfs]
> [  149.904125]  xlog_recover+0xdd/0x190 [xfs]
> [  149.904265]  xfs_log_mount+0x125/0x2f0 [xfs]
> [  149.904410]  xfs_mountfs+0x41a/0x910 [xfs]
> [  149.904558]  ? __pfx_xfs_fstrm_free_func+0x10/0x10 [xfs]
> [  149.904725]  xfs_fs_fill_super+0x4b7/0x940 [xfs]
> [  149.904873]  ? __pfx_xfs_fs_fill_super+0x10/0x10 [xfs]
> [  149.905016]  get_tree_bdev+0x19a/0x280
> [  149.905020]  vfs_get_tree+0x29/0xd0
> [  149.905023]  path_mount+0x69e/0x9b0
> [  149.905026]  do_mount+0x7d/0xa0
> [  149.905029]  __x64_sys_mount+0xdc/0x100
> [  149.905032]  do_syscall_64+0x3e/0x90
> [  149.905035]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> 
> The trigger process is as follows:
> 
> 1. Growfs size from 0x200000 to 0x300000
> 2. Using the space range of 0x200000~0x300000
> 3. The above operations have only been written to the log area on disk
> 4. Fault injection and shutdown filesystem
> 5. Mount the filesystem and replay the log about growfs, but only modify the
>  superblock buffer without modifying the mp->m_sb structure in memory
> 6. Continuing the log replay, at this point we are replaying operation 2, then
>  it was discovered that the blocks used more than mp->m_sb.sb_dblocks
> 
> Therefore, during log replay, if there are any modifications made to the
> superblock, we should refresh the information recorded in the mp->m_sb.

Heh, clever.  Thanks for supplying a patch. :)

> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 43167f543afc..2ac3d2083188 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -22,6 +22,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
>  #include "xfs_quota.h"
> +#include "xfs_sb.h"
> +#include "xfs_ag.h"
> 
>  /*
>   * This is the number of entries in the l_buf_cancel_table used during
> @@ -969,6 +971,29 @@ xlog_recover_buf_commit_pass2(
>                         goto out_release;
>         } else {
>                 xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +               /*
> +                * If the superblock buffer is modified, we also need to modify the
> +                * content of the mp.
> +                */
> +               if (bp->b_maps[0].bm_bn == XFS_SB_DADDR && bp->b_ops) {
> +                       struct xfs_dsb *sb = bp->b_addr;

I think the body of this if statement ought to be a separate function,
e.g.

STATIC int
xlog_recover_sb_buffer(...)
{
	struct xfs_dsb *sb = bp->b_addr;

	bp->b_ops->verify_write(bp);
	...
}

Also, I think the callsite is better placed at the end of
xlog_recover_do_reg_buffer.

> +
> +                       bp->b_ops->verify_write(bp);

I was about to ask why you ran the full write verifier here instead of
calling ->verify_struct (which skips the crc computation), but then I
realized:

const struct xfs_buf_ops xfs_sb_buf_ops = {
	.name = "xfs_sb",
	.magic = { cpu_to_be32(XFS_SB_MAGIC), cpu_to_be32(XFS_SB_MAGIC) },
	.verify_read = xfs_sb_read_verify,
	.verify_write = xfs_sb_write_verify,
};

So, heh.  No structure verifier.  I think for completeness
xfs_sb_buf_ops ought to have one, but I'm willing to live with this for
now.

> +                       error = bp->b_error;
> +                       if (error)
> +                               goto out_release;
> +
> +                       if (be32_to_cpu(sb->sb_agcount) > mp->m_sb.sb_agcount) {
> +                               error = xfs_initialize_perag(mp,
> +                                                       be32_to_cpu(sb->sb_agcount),
> +                                                       be64_to_cpu(sb->sb_dblocks),
> +                                                       &mp->m_maxagi);
> +                               if (error)
> +                                       goto out_release;

Might want to log a message here that the perag init is what killed log
recovery.

Other than those reorganization suggestions, I think this looks correct.
Would you mind submitting your testcase to fstests?

--D

> +                       }
> +
> +                       xfs_sb_from_disk(&mp->m_sb, sb);
> +               }
>         }
> 
>         /*
> --
> 2.27.0
