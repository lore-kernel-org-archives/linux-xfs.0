Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2306C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Oct 2021 01:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5D660EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Oct 2021 01:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJZCBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 22:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhJZCBl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Oct 2021 22:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0976C60F9B;
        Tue, 26 Oct 2021 01:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635213558;
        bh=2mPUeS3RqwqWj8tVvCnTHL2ub0rzQLafcEE3PBVvJxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuYRtDUL8OWpn9pezDpylf0Duc4khiZkIfof7OM069mENoXozlR5G0lb3jrEa/FCB
         mlMS9IiMSAAAhUoO0Vggr1uMV/I0QJmbI9iYeGhUuKuxHLtn6gEKMitRkgtaUODQWZ
         BHBc5f8jGXGiHjrw1MbN4KiF/wdLxU/wJxvKzDG8Ohulj+OVHf8Ot7IOK+XvXO02pH
         8hNfNCorjcoz+zFMVMOazp2WknM02/dPru1Lhab6m9b4qhNzpUZ+mr2cuBvYdtSMNX
         Re3StoFBV2qNhzJiOOc19pMIw9sedzt2OjerihGJXXFgcJATQiJP6VXNe1C+wwNlgY
         gfGcuDB4ReD1Q==
Date:   Mon, 25 Oct 2021 18:59:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] xfs: Remove duplicated include in xfs_super
Message-ID: <20211026015917.GA24307@magnolia>
References: <20211026014807.27554-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026014807.27554-1-wanjiabing@vivo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 25, 2021 at 09:48:07PM -0400, Wan Jiabing wrote:
> Fix following checkincludes.pl warning:
> ./fs/xfs/xfs_super.c: xfs_btree.h is included more than once.
> 
> The include is in line 15. Remove the duplicated here.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

LGTM, thanks for the patch. :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f4c508428aad..e21459f9923a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -37,7 +37,6 @@
>  #include "xfs_reflink.h"
>  #include "xfs_pwork.h"
>  #include "xfs_ag.h"
> -#include "xfs_btree.h"
>  #include "xfs_defer.h"
>  
>  #include <linux/magic.h>
> -- 
> 2.20.1
> 
