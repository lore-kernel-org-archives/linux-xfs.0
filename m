Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB9FC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D31206D6
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uHrhsYYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgEIQgW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEIQgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:36:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8367C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 09:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mwflHJqrYsPg1B8IQ6D05GSF151NauEFeEKqylDm5RA=; b=uHrhsYYGn44uXEUACRHbDK8Gdg
        K0nI8jgUw6g+BUVm8UNbCTHP/VICu7C5dBisSVo45aE5tKm9RdDAC7v8Z91SBsp3kwHhh0URRPSBm
        OMI+OT9mzYFOm3/iW/v1IcyT2GiWD6m1Cr0ORWf/65BDYq1xnDQoeBswRVfupMtMJtyjl9q8173Ml
        Zs02+DF9mrE9Ouv31W6sxU8R1Uk9enS4hAC/ieNg8ikvx2Fgvfgxfsh9cyJwXOa87X3OsKJQQzTID
        2FQ4w2D6CqymO0ev6ee5V+nGTMonxFrf0snwyEMWhWCTKyc7NiXf86vKhLR4ytgA/kBJU2kUyqgPZ
        AdSNI4KA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSSa-0008IG-18; Sat, 09 May 2020 16:36:20 +0000
Date:   Sat, 9 May 2020 09:36:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxcmd: don't crash if el_gets returns null
Message-ID: <20200509163620.GB23078@infradead.org>
References: <158904177147.982835.3876574696663645345.stgit@magnolia>
 <158904177769.982835.13533960280738735171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904177769.982835.13533960280738735171.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:29:37AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> el_gets returns NULL if it fails to read any characters (due to EOF or
> errors occurred).  strdup will crash if it is fed a NULL string, so
> check the return value to avoid segfaulting.

Didn't I review this already?

Reviewed-by: Christoph Hellwig <hch@lst.de>
