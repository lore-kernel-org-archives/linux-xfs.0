Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A21CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377029AbjJLFLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376867AbjJLFLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:11:44 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3356A90
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:11:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A79EB6732D; Thu, 12 Oct 2023 07:11:40 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:11:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 2/7] xfs: create a helper to compute leftovers of
 realtime extents
Message-ID: <20231012051140.GB2184@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721209.1773611.10988808692731283385.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721209.1773611.10988808692731283385.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 3e07e7c6a5d53..29f1aa290ce6d 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> +#include "xfs_rtbitmap.h"
>  
>  #include <linux/iversion.h>
>  

This seems to just have slipped in here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
