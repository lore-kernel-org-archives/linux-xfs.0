Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AFDC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 07:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6346A23A68
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 07:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbhAIHBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 02:01:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbhAIHBW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Jan 2021 02:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054CC23A68;
        Sat,  9 Jan 2021 07:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610175642;
        bh=pZt971tQiS6yTmbimdBoWmyPfJPlNmH4Oy+GU94equg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oUIZFvJybHyH92Ej73N/IFsVrPtI7uPSnw9/nZecYPfMinJW5LtkQjIVwQ3Xe/4ZM
         ZiEZfhF0l/v4j47F11+rvdxSRdcsgeyhnDt4daUzpLr3hS4vgBF/qUXpXgBcmD04N1
         IIaE9t+OAsopB0cnvyIY/810N/Ckt58q1GY6ygx5wsM0EjIp3KsaInrcXmy07A5lWu
         tx1nqSJOV4BtRo7l5IrCd/MPrQp2GukKmzx6SkOckXCnOt//QSUlVxqNuZJZeNT19y
         V4jkEy+d/5zkjcKm5zdmrfz4z4BSO53DfJydulWc6FuUKeJGND8HsLJMCv7IaTJdR9
         mHbgIr2+BVFng==
Date:   Fri, 8 Jan 2021 23:00:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_scrub: detect infinite loops when scanning inodes
Message-ID: <20210109070041.GV6918@magnolia>
References: <161017367756.1141483.3709627869982359451.stgit@magnolia>
 <161017368431.1141483.1015560955108076159.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161017368431.1141483.1015560955108076159.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 10:28:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During an inode scan (aka phase 3) when we're scanning the inode btree
> to find files to check, make sure that each invocation of inumbers
> actually gives us an inobt record with a startino that's at least as
> large as what we asked for so that we always make forward progress.

Heh, this should have gone in the random fixes series.  Sigh...

--D

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/inodes.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> 
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index bdc12df3..4550db83 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -119,6 +119,7 @@ scan_ag_inodes(
>  	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
>  	struct xfs_bulkstat	*bs;
>  	struct xfs_inumbers	*inumbers;
> +	uint64_t		nextino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
>  	int			i;
>  	int			error;
>  	int			stale_count = 0;
> @@ -153,6 +154,21 @@ scan_ag_inodes(
>  	/* Find the inode chunk & alloc mask */
>  	error = -xfrog_inumbers(&ctx->mnt, ireq);
>  	while (!error && !si->aborted && ireq->hdr.ocount > 0) {
> +		/*
> +		 * Make sure that we always make forward progress while we
> +		 * scan the inode btree.
> +		 */
> +		if (nextino > inumbers->xi_startino) {
> +			str_corrupt(ctx, descr,
> +	_("AG %u inode btree is corrupt near agino %lu, got %lu"), agno,
> +				cvt_ino_to_agino(&ctx->mnt, nextino),
> +				cvt_ino_to_agino(&ctx->mnt,
> +						ireq->inumbers[0].xi_startino));
> +			si->aborted = true;
> +			break;
> +		}
> +		nextino = ireq->hdr.ino;
> +
>  		/*
>  		 * We can have totally empty inode chunks on filesystems where
>  		 * there are more than 64 inodes per block.  Skip these.
> 
