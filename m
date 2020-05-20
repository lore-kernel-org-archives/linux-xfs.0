Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA58C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 127B22065F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YRAzqUjI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgETG4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 02:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgETG4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 02:56:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494EFC061A0E
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 23:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nKPk8F0seUktS7UaDCTPtJ51lLKAlTPzdAAYzw91RzU=; b=YRAzqUjIS52ZoAlzsZOw2GVgLF
        MREfP03YRhmbsUkMSPO2jP3X3JhU3T7oKDC/VE0qUaNUDLUhO6PznN5MKJfCLLobQeZol7UQUbK4N
        jDtSTBvyDvP9JglWw8hD/QG76kcSqeoJ0wCbu8PahVV/lsfxqx5INs5/edZrj/fEtnM0+ta/3WCEY
        FY+HM2vr7vSgavMENhu+3WXKtlFGf/GRovGoMuztQuh4/H2/09F3WxfeNAlssFY5HQw3akxIVcpLi
        hECnKDtQ9rcNh/WgV9NY6XbxGWEkIfzklER+GHuK1qGb+WwMFmEa4DkqEqqQMEIhfAhXpm3vE9YJC
        lE5RIabA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbIe4-0002ts-5G; Wed, 20 May 2020 06:56:04 +0000
Date:   Tue, 19 May 2020 23:56:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reduce free inode accounting overhead
Message-ID: <20200520065604.GB25811@infradead.org>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519214840.2570159-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 07:48:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Shaokun Zhang reported that XFs was using substantial CPU time in

s/XFs/XFS/

>  	if (idelta) {
> -		error = xfs_mod_icount(mp, idelta);
> -		ASSERT(!error);
> +		percpu_counter_add_batch(&mp->m_icount, idelta,
> +					 XFS_ICOUNT_BATCH);
> +		if (idelta < 0)
> +			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> +							XFS_ICOUNT_BATCH) >= 0);
>  	}
>  
>  	if (ifreedelta) {
> -		error = xfs_mod_ifree(mp, ifreedelta);
> -		ASSERT(!error);
> +		percpu_counter_add(&mp->m_ifree, ifreedelta);
> +		if (ifreedelta < 0)
> +			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);

I'd be tempted to just remove the ASSERTS entirely, as they are still
pretty heavy handed for debug kernels.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
