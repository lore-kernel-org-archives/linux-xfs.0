Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81D1C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 23:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiFVXpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiFVXpd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEA842A1F;
        Wed, 22 Jun 2022 16:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA5BAB8204E;
        Wed, 22 Jun 2022 23:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB35C34114;
        Wed, 22 Jun 2022 23:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655941529;
        bh=knWbFWKPVCf/JcdUUqeVuszXkkpvZ1XDzUuX0zVGWZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H90Aw81HbXUmmlyFgs7k3jw+jd44ERxcPT2u+pLgBeonV7l/V3+4Ru0VYuYOWN1mV
         xbNUAHQCeorgQJuq63aXjmNmsXhYL4pM2ahRHuYocCtRWX/BO3Efv+/g3Fo19cE+5K
         ciwJxN+tl3FsF+xD0yA08RhRL/7KCmT/znxgnVepRuXKVsZgYgA6gEZ8zUlsV0PB2W
         UQHCHsoVCcTgaL+8ReRnF6+tp8G/4mlT6Lcj6zGsthQqJa2Tk8ZhaMJ5wQh6csA3a1
         CIlfsfn1L61VfVEoeVcbKND6QvsNG48uQIwoKSgWh8P12Y8hA3/R4KiTY8pvwy3noV
         6ztzQYnKGFeVQ==
Date:   Wed, 22 Jun 2022 16:45:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 00/11] xfs stable candidate patches for
 5.10.y (v5.15+)
Message-ID: <YrOpmMzn9ArsR9Dy@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 01:06:30PM +0300, Amir Goldstein wrote:
> Hi all,
> 
> Previously posted candidates for 5.10.y followed chronological release
> order.
> 
> Parts 1 and 2 of fixes from v5.10..v5.12 have already been applied to
> v5.10.121.
> 
> Part 3 (from 5.13) has already been posted for review [3] on June 6,
> but following feedback from Dave, I changed my focus to get the same
> set of patches tested and reviewed for 5.10.y/5.15.y.
> 
> I do want to ask you guys to also find time to review part 3, because
> we have a lot of catching up to do for 5.10.y, so we need to chew at
> this debt at a reasonable rate.
> 
> This post has the matching set of patches for 5.10.y that goes with
> Leah's first set of candidates for 5.15.y [1].
> 
> Most of the fixes are from v5.15..v5.17 except for patch 11 (v5.18-rc1).
> All fix patches have been tagged with Fixes: by the author.
> 
> The patches have been soaking in kdepops since Sunday. They passed more
> than 30 auto group runs with several different versions of xfsprogs.
> 
> The differences from Leah's 5.15.y:
> - It is 11 patches and not 8 because of dependencies
> - Patches 6,7 are non-fixes backported as dependency to patch 8 -
>   they have "backported .* for dependency" in their commit message
> - Patches 3,4,11 needed changes to apply to 5.10.y - they have a
>   "backport" related comment in their commit message to explain what
>   changes were needed
> - Patch 10 is a fix from v5.12 that is re-posted as a dependency for
>   patch 11
> 
> Darrick,
> 
> As the author patches 4,11 and sole reviewer of patch 3 (a.k.a
> the non-cleanly applied patches), please take a closer look at those.
> 
> Patch 10 has been dropped from my part 2 candidates following concerns
> raised by Dave and is now being re-posted following feedback from
> Christian and Christoph [2].
> 
> If there are still concerns about patches 10 or 11, please raise a flag.
> I can drop either of these patches before posting to stable if anyone
> feels that they need more time to soak in master.

At the current moment (keep in mind that I have 2,978 more emails to get
through before I'm caught up), I think it's safe to say that for patches
1-5:

Acked-by: Darrick J. Wong <djwong@kernel.org>

(patch 9 also, but see the reply I just sent for that one about grabbing
the sync_fs fixes too)

The log changes are going to take more time to go through, since that
stuff is always tricky and /not/ something for me to be messing with at
4:45pm.

--D

> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-xfs/20220616182749.1200971-1-leah.rumancik@gmail.com/
> [2] https://lore.kernel.org/linux-xfs/CAOQ4uxg4=m9zEFbDAKXx7CP7HYiMwtsYSJvq076oKpy-OhK1uw@mail.gmail.com/
> [3] https://lore.kernel.org/linux-xfs/20220606160537.689915-1-amir73il@gmail.com/
> 
> Brian Foster (1):
>   xfs: punch out data fork delalloc blocks on COW writeback failure
> 
> Christoph Hellwig (2):
>   xfs: refactor xfs_file_fsync
>   xfs: fix up non-directory creation in SGID directories
> 
> Darrick J. Wong (4):
>   xfs: remove all COW fork extents when remounting readonly
>   xfs: prevent UAF in xfs_log_item_in_current_chkpt
>   xfs: only bother with sync_filesystem during readonly remount
>   xfs: use setattr_copy to set vfs inode attributes
> 
> Dave Chinner (2):
>   xfs: check sb_meta_uuid for dabuf buffer recovery
>   xfs: xfs_log_force_lsn isn't passed a LSN
> 
> Rustam Kovhaev (1):
>   xfs: use kmem_cache_free() for kmem_cache objects
> 
> Yang Xu (1):
>   xfs: Fix the free logic of state in xfs_attr_node_hasname
> 
>  fs/xfs/libxfs/xfs_attr.c      | 13 +++---
>  fs/xfs/libxfs/xfs_types.h     |  1 +
>  fs/xfs/xfs_aops.c             | 15 +++++--
>  fs/xfs/xfs_buf_item.c         |  2 +-
>  fs/xfs/xfs_buf_item_recover.c |  2 +-
>  fs/xfs/xfs_dquot_item.c       |  2 +-
>  fs/xfs/xfs_extfree_item.c     |  6 +--
>  fs/xfs/xfs_file.c             | 81 +++++++++++++++++++++--------------
>  fs/xfs/xfs_inode.c            | 24 +++++------
>  fs/xfs/xfs_inode_item.c       |  4 +-
>  fs/xfs/xfs_inode_item.h       |  2 +-
>  fs/xfs/xfs_iops.c             | 56 ++----------------------
>  fs/xfs/xfs_log.c              | 27 ++++++------
>  fs/xfs/xfs_log.h              |  4 +-
>  fs/xfs/xfs_log_cil.c          | 32 ++++++--------
>  fs/xfs/xfs_log_priv.h         | 15 +++----
>  fs/xfs/xfs_pnfs.c             |  3 +-
>  fs/xfs/xfs_super.c            | 21 ++++++---
>  fs/xfs/xfs_trans.c            |  6 +--
>  fs/xfs/xfs_trans.h            |  4 +-
>  20 files changed, 149 insertions(+), 171 deletions(-)
> 
> -- 
> 2.25.1
> 
