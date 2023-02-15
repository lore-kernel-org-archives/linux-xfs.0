Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2834C636CC
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 16:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBOQWD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 11:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBOQWC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2023 11:22:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A147B3B0F9
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 08:21:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8FC961CA5
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 16:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A910C4339B;
        Wed, 15 Feb 2023 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676478069;
        bh=72WQuebEO3nOrchOcrIt9HU7PU6bQw+/bPCAiN4cfD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S+hZQD3aCTNkGd84NhxbA3GuqP2kgvgynT46KJlmNt317lV+l3TVEbQJaS1FkOnCb
         g5XjlUxmt1cts6k8Ezg763H1RPNhB9JVZYWhCUY7tkd8+A4ZJKVB3SW86FuG0oUEob
         hGoNLqk+CAoC5G3SK0mpU6k7RdCtoPvL9EC9VeJK42OCLfw/d8S221ILvudvS9tBH9
         jcq3g52UsGSMTcutSqFLDE/08o7K3Onci3OgRozVd2BmQ39aEiY+rGRTUcMnPQ8QF1
         B3Evn4V4U+a3gJoNWStePyaFKqUYArPxYHWtk9Gq0b/xbHk7hQ3LuveYV2d0F4by1G
         ZUEa4t5xNvQIg==
Date:   Wed, 15 Feb 2023 08:21:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/25] xfs stable candidate patches for
 5.4.y (from v5.10)
Message-ID: <Y+0GdP44fa800VIA@magnolia>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 13, 2023 at 09:34:20AM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> This 5.4.y backport series contains fixes from v5.10 release.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> The following is the list of commits along with corresponding
> dependent commits.
> 
> 1. xfs: log new intent items created as part of finishing recovered intent
>    items
>    Dependent commits
>    1. xfs: remove the xfs_efi_log_item_t typedef
>    2. xfs: remove the xfs_efd_log_item_t typedef
>    3. xfs: remove the xfs_inode_log_item_t typedef
>    4. xfs: factor out a xfs_defer_create_intent helper
>    5. xfs: merge the ->log_item defer op into ->create_intent
>    6. xfs: merge the ->diff_items defer op into ->create_intent
>    7. xfs: turn dfp_intent into a xfs_log_item
>    8. xfs: refactor xfs_defer_finish_noroll
> 
> 2. xfs: fix finobt btree block recovery ordering
> 3. xfs: proper replay of deferred ops queued during log recovery
> 4. xfs: xfs_defer_capture should absorb remaining block reservations
> 5  xfs: xfs_defer_capture should absorb remaining transaction reservation
> 
> 6. xfs: fix an incore inode UAF in xfs_bui_recover
>    Dependent commits
>    1. xfs: clean up bmap intent item recovery checking
>    2. xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
> 
> 7. xfs: change the order in which child and parent defer ops are finished
> 
> 8. xfs: periodically relog deferred intent items
>    Dependent commits
>    1. xfs: prevent UAF in xfs_log_item_in_current_chkpt
> 
> 9. xfs: only relog deferred intent items if free space in the log gets low
>    Dependent commits
>    1. xfs: expose the log push threshold
> 
> 10. xfs: fix missing CoW blocks writeback conversion retry
> 
> 11. xfs: ensure inobt record walks always make forward progress
>     Dependent commits
>     1. xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
> 
> 12. xfs: sync lazy sb accounting on quiesce of read-only mounts
> 
> The last commit was picked from v5.12 since failure rate of recovery loop
> tests would increase drastically for some xfs configurations without applying
> it.

Looks good to me; thanks for putting this together!
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Brian Foster (1):
>   xfs: sync lazy sb accounting on quiesce of read-only mounts
> 
> Christoph Hellwig (8):
>   xfs: remove the xfs_efi_log_item_t typedef
>   xfs: remove the xfs_efd_log_item_t typedef
>   xfs: remove the xfs_inode_log_item_t typedef
>   xfs: factor out a xfs_defer_create_intent helper
>   xfs: merge the ->log_item defer op into ->create_intent
>   xfs: merge the ->diff_items defer op into ->create_intent
>   xfs: turn dfp_intent into a xfs_log_item
>   xfs: refactor xfs_defer_finish_noroll
> 
> Darrick J. Wong (15):
>   xfs: log new intent items created as part of finishing recovered
>     intent items
>   xfs: proper replay of deferred ops queued during log recovery
>   xfs: xfs_defer_capture should absorb remaining block reservations
>   xfs: xfs_defer_capture should absorb remaining transaction reservation
>   xfs: clean up bmap intent item recovery checking
>   xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
>   xfs: fix an incore inode UAF in xfs_bui_recover
>   xfs: change the order in which child and parent defer ops are finished
>   xfs: periodically relog deferred intent items
>   xfs: expose the log push threshold
>   xfs: only relog deferred intent items if free space in the log gets
>     low
>   xfs: fix missing CoW blocks writeback conversion retry
>   xfs: ensure inobt record walks always make forward progress
>   xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
>   xfs: prevent UAF in xfs_log_item_in_current_chkpt
> 
> Dave Chinner (1):
>   xfs: fix finobt btree block recovery ordering
> 
>  fs/xfs/libxfs/xfs_defer.c       | 358 ++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_defer.h       |  49 ++++-
>  fs/xfs/libxfs/xfs_inode_fork.c  |   2 +-
>  fs/xfs/libxfs/xfs_trans_inode.c |   2 +-
>  fs/xfs/xfs_aops.c               |   4 +-
>  fs/xfs/xfs_bmap_item.c          | 238 +++++++++++----------
>  fs/xfs/xfs_bmap_item.h          |   3 +-
>  fs/xfs/xfs_extfree_item.c       | 175 +++++++++-------
>  fs/xfs/xfs_extfree_item.h       |  18 +-
>  fs/xfs/xfs_icreate_item.c       |   1 +
>  fs/xfs/xfs_inode.c              |   4 +-
>  fs/xfs/xfs_inode_item.c         |   2 +-
>  fs/xfs/xfs_inode_item.h         |   4 +-
>  fs/xfs/xfs_iwalk.c              |  27 ++-
>  fs/xfs/xfs_log.c                |  68 ++++--
>  fs/xfs/xfs_log.h                |   3 +
>  fs/xfs/xfs_log_cil.c            |   8 +-
>  fs/xfs/xfs_log_recover.c        | 160 ++++++++------
>  fs/xfs/xfs_mount.c              |   3 +-
>  fs/xfs/xfs_refcount_item.c      | 173 ++++++++-------
>  fs/xfs/xfs_refcount_item.h      |   3 +-
>  fs/xfs/xfs_rmap_item.c          | 161 +++++++-------
>  fs/xfs/xfs_rmap_item.h          |   3 +-
>  fs/xfs/xfs_stats.c              |   4 +
>  fs/xfs/xfs_stats.h              |   1 +
>  fs/xfs/xfs_super.c              |   8 +-
>  fs/xfs/xfs_trace.h              |   1 +
>  fs/xfs/xfs_trans.h              |  10 +
>  28 files changed, 946 insertions(+), 547 deletions(-)
> 
> -- 
> 2.35.1
> 
