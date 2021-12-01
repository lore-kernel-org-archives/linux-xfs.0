Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7E4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 17:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352065AbhLASBs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 13:01:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47518 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352176AbhLASBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 13:01:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C083CE2020
        for <linux-xfs@vger.kernel.org>; Wed,  1 Dec 2021 17:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4EDC53FCC;
        Wed,  1 Dec 2021 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638381468;
        bh=ePo9EDjjzNDTsvnP2oXj/6L0j4/b3+VCTsVcvAHCMdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqTZChUpTN8MklAGkOiJmqFxIF22gI/MzMU+zchQgnJSZDZvObX1KyIQq3vRvMcmf
         leTq+V5TuSY0e3zvA3sW0r8gCgDRnDDrxk5UlGaMxTIOdi04Gd8k7kJbbLttUVJNnJ
         8dNiXpW8akGnuMuvedBOAE35asa1VizAWtzysr5stJtNB8F/FuDXGWiBhpSyAqeLOh
         mMy+K0l49zGpYmY2Jdxmxycjq8lILlK0kzBsbA7oQsOzqFvtSAABelfWZUL9erQbxG
         1y/ClfNLdh8Tgxd/tOEwl2ba9j7LquuCVTpi/EhTT8oRtzj6BheA+kpgBIx6IQ+pBp
         kyFXFUKwrcsew==
Date:   Wed, 1 Dec 2021 09:57:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] xfs: remove incorrect ASSERT in xfs_rename
Message-ID: <20211201175748.GL8467@magnolia>
References: <bbb4b6d5-744c-11c8-fcda-62777e8d7b19@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbb4b6d5-744c-11c8-fcda-62777e8d7b19@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 30, 2021 at 11:17:56PM -0600, Eric Sandeen wrote:
> This ASSERT in xfs_rename is a) incorrect, because
> (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> b) unnecessary, because actual invalid flag combinations are already
> handled at the vfs level in do_renameat2() before we get called.
> So, remove it.
> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 64b9bf3..6771f35 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3122,7 +3122,6 @@ struct xfs_iunlink {
>  	 * appropriately.
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
> -		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>  		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
>  		if (error)
>  			return error;
> 
