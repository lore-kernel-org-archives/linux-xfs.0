Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55CAC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726B2207D3
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hp1QXrSc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETHsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETHsF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 03:48:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3146C061A0E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 00:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jObRMRc0lqXgtHNNjQUEMnsGdQanB2crR4qz+ckHHEk=; b=hp1QXrSc8/VX/ALSmJvVyHYwju
        06UyXu0rWFw1kX+o9j3V1NS3tZW8Ncqx/OFt1qQet4lLpfB1hNm2KbgjNtPi28GA/4M/FXtBRcCcC
        G3V1MvtmgeIDoy7D6unpdpzAZ6kFCjSYy9wS5oNtohG71h79nD+OdDG5KosSAxyL6y1qIT4z2IZol
        rWOYXhGpzF2Jd0hK45erwoKSZuzLAcUpWykyaZLZYRSVgb0vle9nGYo7bPN7FuW3+4HShrM4Zhwi+
        HBOoeIb0eGv3rhw0MRNitfIhy6wBU2ijwxODsOwp0DjfvKwLKOsaYY0JuAs0KjLzH+75r/0y3qNsW
        JzCWhxMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbJSP-0005aJ-NC; Wed, 20 May 2020 07:48:05 +0000
Date:   Wed, 20 May 2020 00:48:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520074805.GA21299@infradead.org>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
 <20200520073358.GX2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520073358.GX2040@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 05:33:58PM +1000, Dave Chinner wrote:
> +	/*
> +	 * Debug checks outside of the spinlock so they don't lock up the
> +	 * machine if they fail.
> +	 */
> +	ASSERT(mp->m_sb.sb_frextents >= 0);
> +	ASSERT(mp->m_sb.sb_dblocks >= 0);
> +	ASSERT(mp->m_sb.sb_agcount >= 0);
> +	ASSERT(mp->m_sb.sb_imax_pct >= 0);
> +	ASSERT(mp->m_sb.sb_rextsize >= 0);
> +	ASSERT(mp->m_sb.sb_rbmblocks >= 0);
> +	ASSERT(mp->m_sb.sb_rblocks >= 0);
> +	ASSERT(mp->m_sb.sb_rextents >= 0);
> +	ASSERT(mp->m_sb.sb_rextslog >= 0);
>  	return;

No need for the return here at the end of the function.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
