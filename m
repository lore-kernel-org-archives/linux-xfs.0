Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D38FEB64DD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjHAXkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjHAXkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D851B1
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D09C6176F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 23:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3CDC433C7;
        Tue,  1 Aug 2023 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690933213;
        bh=JNqb2j1HnQ9N5d0vk3w0ix1c2Oa6jKtC80QF3dtgsgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AlIqLXpaM94ZuRNG3qkyzIIbVCIoFm4VhtVucOPRoIJioGszEoZaqk42riTpRB8Ms
         zABaZJz9or5s6wBxefOUGLSdyS7jAqLsp1PK/ov1QN9J7Zj5RNQKS0oVoXGXUx5zjR
         lktPIKae8clHN1Ei8jjhF04Xqq5XgZX7zhneOm3UPXIc2JYmLJbFi6UqOhct4/+uhu
         d9dnsqjPS39rfxR4nCrRrU8TJTCfItVvcPfJK2DLSTjx5hJMQSnZlnmCN4NC30qg66
         cL/MfLEViyA4Y51rpBNdrQHF4FnS35hyd1KoapCVJ6L+XnjRN+WLVJo+FMjs9uaXqg
         ZqbtmcHTzSZzQ==
Date:   Tue, 1 Aug 2023 16:40:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 6/6] xfs: don't look for end of extent further than
 necessary in xfs_rtallocate_extent_near()
Message-ID: <20230801234012.GD11336@frogsfrogsfrogs>
References: <cover.1687296675.git.osandov@osandov.com>
 <554f3ce85edca54d14cc1e1b22c4207a3e8f36a7.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554f3ce85edca54d14cc1e1b22c4207a3e8f36a7.1687296675.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 02:32:16PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> As explained in the previous commit, xfs_rtallocate_extent_near() looks
> for the end of a free extent when searching backwards from the target
> bitmap block. Since the previous commit, it searches from the last
> bitmap block it checked to the bitmap block containing the start of the
> extent.
> 
> This may still be more than necessary, since the free extent may not be
> that long. We know the maximum size of the free extent from the realtime
> summary. Use that to compute how many bitmap blocks we actually need to
> check.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 4d9d0be2e616..2e2eb7c4a648 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -517,12 +517,29 @@ xfs_rtallocate_extent_near(
>  			 * On the negative side of the starting location.
>  			 */
>  			else {		/* i < 0 */
> +				int maxblocks;
> +
>  				/*
> -				 * Loop backwards through the bitmap blocks from
> -				 * where we last checked up to where we are now.
> -				 * There should be an extent which ends in this
> -				 * bitmap block and is long enough.
> +				 * Loop backwards to find the end of the extent
> +				 * we found in the realtime summary.
> +				 *
> +				 * maxblocks is the maximum possible number of
> +				 * bitmap blocks from the start of the extent to
> +				 * the end of the extent.
>  				 */
> +				if (maxlog == 0)
> +					maxblocks = 0;
> +				else if (maxlog < mp->m_blkbit_log)
> +					maxblocks = 1;
> +				else
> +					maxblocks = 2 << (maxlog - mp->m_blkbit_log);
> +				/*
> +				 * We need to check bbno + i + maxblocks down to
> +				 * bbno + i. We already checked bbno down to
> +				 * bbno + j + 1, so we don't need to check those
> +				 * again.
> +				 */
> +				j = min(i + maxblocks, j);

Makes sense now with a fresher head...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

What does the xfsprogs version of this patchset look like?

--D

>  				for (; j >= i; j--) {
>  					error = xfs_rtallocate_extent_block(mp,
>  						tp, bbno + j, minlen, maxavail,
> -- 
> 2.41.0
> 
