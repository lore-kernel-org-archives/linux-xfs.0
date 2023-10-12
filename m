Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C757BCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 06:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbjJLG0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 02:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbjJLG0R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 02:26:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA21819F
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 23:25:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 528E16732D; Thu, 12 Oct 2023 08:25:52 +0200 (CEST)
Date:   Thu, 12 Oct 2023 08:25:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 7/8] xfs: create helpers for rtsummary block/wordcount
 computations
Message-ID: <20231012062551.GB3667@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721736.1773834.4052037252966105617.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721736.1773834.4052037252966105617.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:08:03AM -0700, Darrick J. Wong wrote:
> +/* Compute the number of rtsummary blocks needed to track the given rt space. */
> +xfs_filblks_t
> +xfs_rtsummary_blockcount(
> +	struct xfs_mount	*mp,
> +	unsigned int		rsumlevels,
> +	xfs_extlen_t		rbmblocks)
> +{
> +	unsigned long long	rsumwords;
> +
> +	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
> +	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
> +}

This helper and its users make complete sense to me and looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +/*
> + * Compute the number of rtsummary info words needed to populate every block of
> + * a summary file that is large enough to track the given rt space.
> + */
> +unsigned long long
> +xfs_rtsummary_wordcount(
> +	struct xfs_mount	*mp,
> +	unsigned int		rsumlevels,
> +	xfs_extlen_t		rbmblocks)
> +{
> +	xfs_filblks_t		blocks;
> +
> +	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
> +	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
> +}

> @@ -54,8 +55,10 @@ xchk_setup_rtsummary(
>  	 * Create an xfile to construct a new rtsummary file.  The xfile allows
>  	 * us to avoid pinning kernel memory for this purpose.
>  	 */
> +	wordcnt = xfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
> +			mp->m_sb.sb_rbmblocks);
>  	descr = xchk_xfile_descr(sc, "realtime summary file");
> -	error = xfile_create(descr, mp->m_rsumsize, &sc->xfile);
> +	error = xfile_create(descr, wordcnt << XFS_WORDLOG, &sc->xfile);
>  	kfree(descr);

But this confuses me.  What problem does it solve over just using
m_rsumsize?
