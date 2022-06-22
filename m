Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81B5C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358284AbiFVQXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376660AbiFVQXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:23:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D4831929
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 09:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D0E8B81FEE
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3DDC34114;
        Wed, 22 Jun 2022 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655914988;
        bh=UXQoXRn7FlN15p8XXQGtnen2Qo5plbgfyxQdY8oSC4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fd6l/9GkPMW5I3WMAA1/2VNxWttmXVOKsv5SDp4kElFv5qKL6IGGFtf4G/cKmkrHc
         PZOpvpuUhqPfJPCeoas5GCIxHEQMT6+dgd8QWz+uI65nzUt+FBR6Wfi4mAFezqQbAR
         WDycIv0O32RDjouXdUyop8PkyOGulTHz/BIfcLmRKv/iYBQsz/nnPHP9hRlObGZXsL
         UD4OPGk6QWqvFaQWXVHGdA4sYjMDeOyr2jFqnEMjQ3rP/kGIzlUQ0G7fyHXV+vDn+L
         jUVeOuw9hJaDaWORvwCxVCfQAopaW/qum6nPwyNFx6StO1MYuEQ7SyV5KgOevR9n/e
         PE4OymFA4TbOw==
Date:   Wed, 22 Jun 2022 09:23:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, mcgrof@kernel.org
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrNB65ISwFDgLT4O@magnolia>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> The patch testing has been increased to 100 runs per test on each 
> config. A baseline without the patches was established with 100 runs 
> to help detect hard failures / tests with a high fail rate. Any 
> failures seen in the backports branch but not in the baseline branch 
> were then run 1000+ times on both the baseline and backport branches 
> and the failure rates compared. The failures seen on the 5.15 
> baseline are listed at 
> https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> No regressions were seen with these patches.
> 
> To make the review process easier, I have been coordinating with Amir 
> who has been testing this same set of patches on 5.10. He will be 
> sending out the corresponding 5.10 series shortly.
> 
> Change log from v1 
> (https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
> - Increased testing
> - Reduced patch set to overlap with 5.10 patches
> 
> Thanks,
> Leah
> 
> Brian Foster (1):
>   xfs: punch out data fork delalloc blocks on COW writeback failure
> 
> Darrick J. Wong (4):
>   xfs: remove all COW fork extents when remounting readonly
>   xfs: prevent UAF in xfs_log_item_in_current_chkpt
>   xfs: only bother with sync_filesystem during readonly remount

5.15 already has the vfs fixes to make sync_fs/sync_filesystem actually
return error codes, right?

>   xfs: use setattr_copy to set vfs inode attributes
> 
> Dave Chinner (1):
>   xfs: check sb_meta_uuid for dabuf buffer recovery
> 
> Rustam Kovhaev (1):
>   xfs: use kmem_cache_free() for kmem_cache objects
> 
> Yang Xu (1):
>   xfs: Fix the free logic of state in xfs_attr_node_hasname

This one trips me up every time I look at it, but this looks correct.

If the answer to the above question is yes, then:
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  fs/xfs/libxfs/xfs_attr.c      | 17 +++++------
>  fs/xfs/xfs_aops.c             | 15 ++++++++--
>  fs/xfs/xfs_buf_item_recover.c |  2 +-
>  fs/xfs/xfs_extfree_item.c     |  6 ++--
>  fs/xfs/xfs_iops.c             | 56 ++---------------------------------
>  fs/xfs/xfs_log_cil.c          |  6 ++--
>  fs/xfs/xfs_pnfs.c             |  3 +-
>  fs/xfs/xfs_super.c            | 21 +++++++++----
>  8 files changed, 47 insertions(+), 79 deletions(-)
> 
> -- 
> 2.36.1.476.g0c4daa206d-goog
> 
