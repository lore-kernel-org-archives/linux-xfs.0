Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A60C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 21:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiGRV6e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 17:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiGRV6d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 17:58:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F92E9FE
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 14:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC6C2B817AD
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 21:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70644C341C0;
        Mon, 18 Jul 2022 21:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658181510;
        bh=4DLdtsPPnMIp5Y+y73LIunwBwkQCYU3/LdMIkhbP15M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dU2O3GHrV4tWyDEoCYSRnj4CiNHz5dma239b890xyq5Y3TSI1kiVQ4tJuVysojD8i
         N/7QLsj7fm7Un3wXgfQRze2bi1vcuKl1XVvxL5HxVKN097Byr/yCqyce9sEPAmT1ed
         6bWmp3JBWhmlBLZzX61iVs8fIrmi0ZlRMIxSnBuoNI2JXlO44pSfCQ/Ahvtz0iwvsT
         CPIgEh+UCTvMkbgOzFLCrN6H0GKWJTHIgDgFGDUT/GTaWNsX+dPOAeWqB4NufZDWKm
         tIcDkWruYYjplSy4pluhWXWM+4q59hV/1BP+AWFJcNVvSoY9xIE+nlCjS5RmwrN69u
         pwFh6/MwE4ikw==
Date:   Mon, 18 Jul 2022 14:58:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.15 CANDIDATE 0/9] xfs stable candidate patches for
 5.15.y (part 3)
Message-ID: <YtXXhQuOioUeSltH@magnolia>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 18, 2022 at 01:29:50PM -0700, Leah Rumancik wrote:
> Hi again,
> 
> This set contains fixes from 5.16 to 5.17. The normal testing was run
> for this set with no regressions found.
> 
> I included some fixes for online scrub. I am not sure if this
> is in use for 5.15 though so please let me know if these should be
> dropped.
> 
> Some refactoring patches were included in this set as dependencies:
> 
> bf2307b19513 xfs: fold perag loop iteration logic into helper function
>     dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
> f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
>     dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d
> 
> Thanks,
> Leah
> 
> 
> Brian Foster (4):
>   xfs: fold perag loop iteration logic into helper function
>   xfs: rename the next_agno perag iteration variable
>   xfs: terminate perag iteration reliably on agcount
>   xfs: fix perag reference leak on iteration race with growfs
> 
> Dan Carpenter (1):
>   xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
> 
> Darrick J. Wong (4):
>   xfs: fix maxlevels comparisons in the btree staging code

Up to this point,
Acked-by: Darrick J. Wong <djwong@kernel.org>

>   xfs: fix incorrect decoding in xchk_btree_cur_fsbno
>   xfs: fix quotaoff mutex usage now that we don't support disabling it
>   xfs: fix a bug in the online fsck directory leaf1 bestcount check

No objections to these last three, since they're legitimate fixes for
bugs in 5.15, but I would advise y'all not to worry too much about fixes
for EXPERIMENTAL features.

--D

> 
>  fs/xfs/libxfs/xfs_ag.h            | 36 ++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_btree_staging.c |  4 ++--
>  fs/xfs/scrub/dir.c                | 15 +++++++++----
>  fs/xfs/scrub/quota.c              |  4 ++--
>  fs/xfs/scrub/repair.c             |  3 +++
>  fs/xfs/scrub/scrub.c              |  4 ----
>  fs/xfs/scrub/scrub.h              |  1 -
>  fs/xfs/scrub/trace.c              |  7 +++---
>  fs/xfs/xfs_ioctl.c                |  2 +-
>  fs/xfs/xfs_ioctl.h                |  5 +++--
>  fs/xfs/xfs_qm_syscalls.c          | 11 +---------
>  11 files changed, 48 insertions(+), 44 deletions(-)
> 
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
