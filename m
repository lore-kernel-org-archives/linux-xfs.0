Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDC1C77B71
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Apr 2023 02:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjDPCad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Apr 2023 22:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDPCad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Apr 2023 22:30:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154252D5F
        for <linux-xfs@vger.kernel.org>; Sat, 15 Apr 2023 19:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968106127D
        for <linux-xfs@vger.kernel.org>; Sun, 16 Apr 2023 02:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B2BC433D2;
        Sun, 16 Apr 2023 02:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681612230;
        bh=0ewkS+GY1GKvWS98YU9y50Wi6gBmlnwaEZXnPy8N/RA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K0irpvmm0iDttgkEytytXha8WGv4mXecWtIY+cKWNuryW0aP3yWJXMpoauvwbktJd
         Zm9aHOh2ANZJswAkVCb+okRUgGlJASoG6R5goKl88M1O/aWHf58slSJBy7E1TmiJKj
         fyTJTOVTfdUFwgOAuJ20gVdi02vykW/fGlcgTpEjx559mhavSbi7QHY1eu35NHY9n/
         DiXJYisAtu4MMDa/O2ts0PXcfb3rBXfMtsM9qoB/sTdcR5YwAozCxRr1agqv3k4TN9
         ea5hBUpPrK6Bjlf43TljB/Q6SFVicepPMkjfZ38er5nnmA5xDRTQM5frEpo9dJlq0Z
         +Hpjh4hyeV+wQ==
Date:   Sat, 15 Apr 2023 19:30:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix duplicate includes
Message-ID: <20230416023030.GA360889@frogsfrogsfrogs>
References: <20230415224532.604844-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415224532.604844-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 16, 2023 at 08:45:32AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Header files were already included, just not in the normal order.
> Remove the duplicates, preserving normal order. Also move xfs_ag.h
> include to before the scrub internal includes which are normally
> last in the include list.
> 
> Fixes: d5c88131dbf0 ("xfs: allow queued AG intents to drain before scrubbing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/refcount.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index ed5eb367ce49..304ea1e1bfb0 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -9,6 +9,7 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_ag.h"
>  #include "xfs_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_refcount.h"
> @@ -16,9 +17,6 @@
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
>  #include "scrub/trace.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
> -#include "xfs_ag.h"
>  
>  /*
>   * Set us up to scrub reference count btrees.
> -- 
> 2.39.2
> 
