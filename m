Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17211C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 12:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjDLMDV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjDLMDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:03:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614E67EC4
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gOSX5JL5rGM/0F1G2Euz1lZSY+s3QD8Vk48NPZHzgg8=; b=wl4bfeqbiEBsrj7FKI7kSgPr8e
        8gVUwc/nadijSCeCexLdapQtG/Al3DVX5DjQbiaasZS6YroV9WcrVtZkyOmZ/0i962zpgZjMKfI+y
        32YBWghf6fH8raUfiHSIsT57R/HLGvpxw9+TBWMohxYJH3xyMHV/BQZQ0efmiPTrTbLIMyONDj+Dv
        rBo51PtglkD9ghiEEXy9eWJAgW8mjz2HhEFPhxeIMDQ3Jk6CEQ7+bVKc18hblsrnSWQb1W02TisPO
        h4nvqA31Kz2BgWaun+BzCaa8kHK+aOigHGeQ8CVqgOot99MAFn8+4/kLwu+O1MgzkVKP/d5z+Z+Fh
        fri5VoCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZBU-0031he-0f;
        Wed, 12 Apr 2023 12:02:44 +0000
Date:   Wed, 12 Apr 2023 05:02:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <ZDad5BU5pViaOMwL@infradead.org>
References: <20230411184934.GK360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411184934.GK360889@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 11:49:34AM -0700, Darrick J. Wong wrote:
> @@ -226,10 +226,15 @@ xfs_iformat_data_fork(
>  
>  	/*
>  	 * Initialize the extent count early, as the per-format routines may
> -	 * depend on it.
> +	 * depend on it.  Use release semantics to set needextents /after/ we
> +	 * set the format. This ensures that we can use acquire semantics on
> +	 * needextents in xfs_need_iread_extents() and be guaranteed to see a
> +	 * valid format value after that load.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
>  	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
> +	smp_store_release(&ip->i_df.if_needextents,
> +			   ip->i_df.if_format == XFS_DINODE_FMT_BTREE ? 1 : 0);

ip->i_df is memset to zero a little earlier (same for the attr fork),
this only needs to be:

	if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE)
		smp_store_release(&ip->i_df.if_needextents, 1);
