Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDA0C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 06:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjKNGpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 01:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKNGpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 01:45:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DACD44
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 22:45:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC4BC433C7;
        Tue, 14 Nov 2023 06:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699944340;
        bh=qJNmfLcn5ZZHD6+frjujuXUESqiSBcgGCXmWD3oHixQ=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=lmwopxOnMDqTlp7viiKbcyIoeJuMlWuZm1+i3pe11qlQmJTPXwah1FRh+TxH7PYoD
         B+EdtJ7hRwdjGI8Mno3CkPJj6FVySMCiWa8NhT0TMse1fm7JnvpWy0qwUKMf8nN73T
         /CBZQHtAIKMY29NKfV70FnrSl5w9MAS2w5Y5vgGfbiBcOkkTICfRH659nSoh6Ia/0i
         VKiQgUZu/PVPIJI7GXGJ32I7c6SZLvsZYR54v3XNiM+VZJOyIynDGOiTOe5VQUS3x6
         r+iwd38eQ6gxy7fVsF8sLlHn5Nmma6IZcWL1XKshXb0rjzRG7T3FF5SrHN/GxHiGP8
         nVpkiuux+CiWQ==
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, fred@cloudflare.com
Subject: Re: [PATCH 5.15 CANDIDATE 00/17] 5.15 backports from 5.19..6.1
Date:   Tue, 14 Nov 2023 12:13:49 +0530
In-reply-to: <20231114015339.3922119-1-leah.rumancik@gmail.com>
Message-ID: <87fs18j0j3.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 13, 2023 at 05:53:21 PM -0800, Leah Rumancik wrote:
> Hello,
>
> Here is the next set of fixes for 5.15. Tested on 10 configs x 30 runs
> with no regressions seen on these commits. Commit 7d839e325a "xfs: check
> return codes when flushing block devices" is in this range but was left
> out for now as it revealed a regression which exists upstream. I'll
> include it in a future set once its fix is accepted.
>
> - Leah
>

Looks good to me.

Acked-by: Chandan Babu R <chandanbabu@kernel.org>

> Chandan Babu R (1):
>   xfs: Fix false ENOSPC when performing direct write on a delalloc
>     extent in cow fork
>
> ChenXiaoSong (1):
>   xfs: fix NULL pointer dereference in xfs_getbmap()
>
> Darrick J. Wong (8):
>   xfs: refactor buffer cancellation table allocation
>   xfs: don't leak xfs_buf_cancel structures when recovery fails
>   xfs: convert buf_cancel_table allocation to kmalloc_array
>   xfs: prevent a UAF when log IO errors race with unmount
>   xfs: fix use-after-free in xattr node block inactivation
>   xfs: don't leak memory when attr fork loading fails
>   xfs: fix intermittent hang during quotacheck
>   xfs: avoid a UAF when log intent item recovery fails
>
> Gao Xiang (1):
>   xfs: add missing cmap->br_state = XFS_EXT_NORM update
>
> Guo Xuenan (1):
>   xfs: fix exception caused by unexpected illegal bestcount in leaf dir
>
> Kaixu Xia (1):
>   xfs: use invalidate_lock to check the state of mmap_lock
>
> Li Zetao (1):
>   xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()
>
> Zeng Heng (1):
>   xfs: fix memory leak in xfs_errortag_init
>
> Zhang Yi (1):
>   xfs: flush inode gc workqueue before clearing agi bucket
>
> hexiaole (1):
>   xfs: fix inode reservation space for removing transaction
>
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   9 +-
>  fs/xfs/libxfs/xfs_inode_fork.c  |   1 +
>  fs/xfs/libxfs/xfs_log_recover.h |  14 ++-
>  fs/xfs/libxfs/xfs_trans_resv.c  |   2 +-
>  fs/xfs/xfs_attr_inactive.c      |   8 +-
>  fs/xfs/xfs_bmap_util.c          |  17 +--
>  fs/xfs/xfs_buf_item_recover.c   |  66 +++++++++++
>  fs/xfs/xfs_error.c              |   9 +-
>  fs/xfs/xfs_inode.c              |   4 +-
>  fs/xfs/xfs_log.c                |   9 +-
>  fs/xfs/xfs_log_priv.h           |   3 -
>  fs/xfs/xfs_log_recover.c        |  44 +++----
>  fs/xfs/xfs_qm.c                 |   7 ++
>  fs/xfs/xfs_reflink.c            | 197 ++++++++++++++++++++++++++------
>  fs/xfs/xfs_sysfs.h              |   7 +-
>  15 files changed, 307 insertions(+), 90 deletions(-)


-- 
Chandan
