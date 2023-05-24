Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2757FC7EE29
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 01:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbjEXBgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 21:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjEXBgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 21:36:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611B718E
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:36:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d3e5e5980so270849b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684892199; x=1687484199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zHlOrgCj6CSK96OU2N94t5vkzCDLNc2ElfEOGQmW5sI=;
        b=zu+KJ68oIZ/dh8e65O2usOMDPIlFkimFjLFEhXcS4moHgfib13IhJ6oV5LEDwTfhTv
         9mMQ3pNMiHVXxzcG+3jdQs7zbtt74TixAlscxC7in7AsroUXJ6tr4X4vluCwvW0DuGaH
         arZ11trcsxAp1zHtHGftCPxUOvUWDJ9pqnYrwk3Br5b856PyI2SVxNWlFYPZNQ1jN4YJ
         Za7tzUk4eDz5d9G81NprCCVjPASgzIobWNbRhN/Ozx3IlMFUlEKvWKfT6w2IlMxFBFc7
         eGprQiau6ST07qysy0sRuStA5n1+KH0cQ+okB1LxwONqgBSbAf0lnTznn+latuKqZXxp
         x4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684892199; x=1687484199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHlOrgCj6CSK96OU2N94t5vkzCDLNc2ElfEOGQmW5sI=;
        b=TJicvDM9v8yxtbf6qbxIOOusEk02dW5lAQ8YqKTU9BDou6JnPdRqKng8tSfdC9UclX
         +zjDSs2vvEmvzHE5+OKtECU8Go6klPSlWQCKO3rSOBQVsbu2QdouC2YJ81L9QfeHRASo
         uJdtM/bANcBs7cxO6VSQhFU5anefe64e+jy+LU5pIfXgk6Pb2T+ERiiYGGtWWN2hAORQ
         Q+P8w8NS6sc6oNES1N/UJozdF/QRPfGpjV1Jz+1NA7EM/pvhAuIAFNoH19BCBSGH7hd+
         3tJxoSyccg8ynn0qRNfgeMlv9NMq3K+mMaZ+EP47hc3eAPZ3pReywcxli+uznJfueKyR
         Vr8Q==
X-Gm-Message-State: AC+VfDwSrAsQEzJ63XZ8Y/uYW3wguKNWGsKFSaYO7z0EnoQKtW+9Kvrr
        BDd+NOtZYvv4SaTqAB5jzMw1bA==
X-Google-Smtp-Source: ACHHUZ4mUBHZM65d0ik3as14jHucAhVAHFklNHFJSxeFj2mCPLU6/5jg0d1z1SneN7vu4MiAwH8jSw==
X-Received: by 2002:a05:6a00:2d11:b0:64f:4812:8c7e with SMTP id fa17-20020a056a002d1100b0064f48128c7emr1179375pfb.19.1684892198602;
        Tue, 23 May 2023 18:36:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id s9-20020aa78289000000b0063f2e729127sm6477685pfm.144.2023.05.23.18.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 18:36:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1dQY-0039N9-2Q;
        Wed, 24 May 2023 11:36:34 +1000
Date:   Wed, 24 May 2023 11:36:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>, yangerkun@huawei.com,
        yi.zhang@huawei.com, chengzhihao1@huawei.com
Subject: Re: [PATCH] xfs: fix the problem of mount failure caused by not
 refreshing mp->m_sb
Message-ID: <ZG1qIsLppH3VBGDO@dread.disaster.area>
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
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>

There are a bunch of things we need to re-init post recovery if the
superblock contents change during recovery. See xlog_do_recover() -
if we are moving the sb log item recovery updates from post-recovery
to "at log item recovery", then we need to be moving everything else
in xlog_do_recover() here as well.

That said....

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
> +
> +                       bp->b_ops->verify_write(bp);
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
> +                       }
> +
> +                       xfs_sb_from_disk(&mp->m_sb, sb);

Ok, so what are we supposed to do here if the filesystem was shrunk?
How do we guarantee that the mods that the shrink might do beyond
the new end of device in the same checkpoint have already been
replayed by the time the superblock change of size is replayed here?

What if feature bits in the superblock were changed?  e.g. we add a
feature bit the filesystem doesn't understand? Or we have items for
recovery in this checkpoint that are in the log after the superblock
that depend on that feature bit not yet having been changed?

What if the superblock got re-logged and the feature bit change
subsequent objects rely on so gets moved to later in the checkpoint? 

i.e. there appears to be some important item recovery ordering
issues we likely need to address here before we move the in-memory
state updates from post-recovery to mid-recovery. I suspect that
fixing this problem so that superblock updates also guarantee log
recovery ordering is also going to need changing how we update
feature and geometry state in the superblock....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
