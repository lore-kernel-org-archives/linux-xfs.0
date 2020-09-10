Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999F7C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52673207EA
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BAtGhSSm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgIJFmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 01:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgIJFme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 01:42:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB92C061573
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 22:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Ww6/jK5tLjR2S5n8wd8ZTfCbgUDGIslpsq6tCeSuxo=; b=BAtGhSSmLzB2AbF8GEDR/ISEIY
        /HF2g0wWFezfgnCh9W7wZ+lDCeRJhBOvS3E+7h03utjclDKBhiJ/Hytm+Rj78vlIJbQHkopQhmURe
        wj/FvwqHkRLV3l4FPLfWyP+Zzla4ADC4BGNlpvQeLbgbIwZWODOW0Czs45NeBv8ePxpsFaSzKu54N
        odr5qN1QaJLSR2PdAV1aTD+MfRwdV98wh6iBdClEDfeqeSVXIkzZAH5g//M+jFqmnQJ2bPMuKPhkN
        SqVHGKx04gFr0wsc1moxYZ6VNqfRydVzWi1Y9I9AXgJOkYwhmw+lTSMOZ6bOac51HEpScSMcTN5lf
        XU37/l5Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGFLs-00029l-3H; Thu, 10 Sep 2020 05:42:32 +0000
Date:   Thu, 10 Sep 2020 06:42:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: refactor inode flags propagation code
Message-ID: <20200910054232.GA7379@infradead.org>
References: <159971620202.1311472.11867327944494045509.stgit@magnolia>
 <159971621055.1311472.9677034380244876371.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159971621055.1311472.9677034380244876371.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY))
> +			xfs_inode_propagate_flags(ip, pip);
> +		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY))
> +			xfs_inode_propagate_flags2(ip, pip);

I'd further simplify this to:

		if (pip) {
			if (pip->i_d.di_flags & XFS_DIFLAG_ANY)
				xfs_inode_propagate_flags(ip, pip);
			if (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)
				xfs_inode_propagate_flags2(ip, pip);
		}

and maybe use "inherit" instead of "propagate"

But otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
