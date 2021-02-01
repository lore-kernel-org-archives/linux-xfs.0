Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACF2C433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE8164E9B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhBAMg0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBAMgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:36:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F186C061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gaFgus17a3X73dNaN73wwfO4u4qrC8DRp8aVvefosu4=; b=SuK/KlWVZMgdEAzc6lvGNjrfsM
        id8q3ShR3tEzqMBZHBH/aZMKG0ALbbQxPJnJheI45Bx2m73P3G4PsY9mOxoiAkGkJaAtBgysBwjNw
        Jar034iNrpgggeGMiSikfTxMj6HnjPabZiBhCIUdtsIjsgOGNMs0o7/8Nlz7kH6CaDpsTlS4XsTPo
        bFdrvDD/aJxdWYEKzxPPAlLOuQTs/XeI6uyG5NxUB7s5vOjMIvyt3S3TJwsrwKWNs7y7tdl+ais5T
        9jqxUzUBzVBWkRPnMx8dW7ljwbiOwtFYmaOBKWKfvPJMUvC5oIqVtkYiitr32bVLoppXlAZSLV+q0
        1XCfia4Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YQe-00DlXH-8G; Mon, 01 Feb 2021 12:35:40 +0000
Date:   Mon, 1 Feb 2021 12:35:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 08/12] xfs: flush eof/cowblocks if we can't reserve quota
 for inode creation
Message-ID: <20210201123540.GB3279223@infradead.org>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214517156.140945.6151197680730753044.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214517156.140945.6151197680730753044.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +xfs_blockgc_free_dquots(
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
>  	unsigned int		eof_flags)
>  {
>  	struct xfs_eofblocks	eofb = {0};
> -	struct xfs_dquot	*dq;
> +	struct xfs_mount	*mp = NULL;
>  	bool			do_work = false;
>  	int			error;
>  
> +	if (!udqp && !gdqp && !pdqp)
> +		return 0;
> +	if (udqp)
> +		mp = udqp->q_mount;
> +	if (!mp && gdqp)
> +		mp = gdqp->q_mount;
> +	if (!mp && pdqp)
> +		mp = pdqp->q_mount;

I think just passing the xfs_mount as the first argument would be a
little simpler and produce better code.

>  	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
> +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {

Same minor nit as for the last patch.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
