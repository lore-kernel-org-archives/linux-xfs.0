Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53129CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 04:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjJREyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 00:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjJREyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 00:54:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79B193
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 21:54:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 178E568AFE; Wed, 18 Oct 2023 06:54:26 +0200 (CEST)
Date:   Wed, 18 Oct 2023 06:54:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: use accessor functions for bitmap words
Message-ID: <20231018045425.GD15759@lst.de>
References: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs> <169759503104.3396240.5905890094753315092.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169759503104.3396240.5905890094753315092.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* Convert an ondisk bitmap word to its incore representation. */
> +static inline xfs_rtword_t
> +xfs_rtbitmap_getword(
> +	struct xfs_buf		*bp,
> +	unsigned int		index)
> +{
> +	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
> +
> +	return word->old;
> +}
> +
> +/* Set an ondisk bitmap word from an incore representation. */
> +static inline void
> +xfs_rtbitmap_setword(
> +	struct xfs_buf		*bp,
> +	unsigned int		index,
> +	xfs_rtword_t		value)
> +{
> +	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
> +
> +	word->old = value;
> +}

Before getting rid of xfs_rbmblock_wordptr I initially did this as:

	return xfs_rbmblock_wordptr(bp, index)->old;

and
	xfs_rbmblock_wordptr(bp, index)->old = value;

which looks a little neater to me.

Otherwise looks good:

Signed-off-by: Christoph Hellwig <hch@lst.de>
