Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0B4C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC4892076D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:07:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gIrhxTNC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgEFPHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgEFPHu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:07:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5719AC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uTb+sGJFdrSxxf8TrKPgXCUTwoI594s31Kkq0kFD3os=; b=gIrhxTNCZ617463i/pm1I2GYDJ
        ENTnSuvVlJeR9nlZxVgfo0Zm50aEA3PAT2zYuBdG5IeGCe11Nkg0WDgAoyaqMZOTaiyVHj9CU5Xvk
        UYS+wNIiPxFclw6fh1/VOx8Sh8RgMq2JmmIOOsyNLCkGnFJ8D+0ZOI8WiYJBvd/Gcdz6xSpu/WLKn
        /r/7W4b86ykA0tzTMuCv0aKyosxSSWZPY/T2C7Flzya7gJ/XqZK0PcJBci7wl4SQ/7e3G4d5+5UdE
        tKheZlRdPrH2f98XU+QhNRG6SBOvo243EC6IdRarj1ztpOnbR+iOYdHb6KZYWGiL5HV4yUY4AXfm9
        t6C/1+IA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLeI-0005AV-7Z; Wed, 06 May 2020 15:07:50 +0000
Date:   Wed, 6 May 2020 08:07:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/28] xfs: refactor log recovery item dispatch for pass1
 commit functions
Message-ID: <20200506150750.GG7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864105772.182683.2888229701435255975.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864105772.182683.2888229701435255975.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
> +		trace_xfs_log_recover_item_recover(log, trans, item, pass);
> +
> +		if (!item->ri_ops) {
> +			xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> +				__func__, ITEM_TYPE(item));
> +			ASSERT(0);
> +			return -EFSCORRUPTED;
> +		}

Given that we check for ri_ops during the reorder phase this can't
happen.  I think we should remove this check.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
