Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4009DC35657
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 166FF24650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DwiBHVB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBUOzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:55:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUOzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:55:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mh2uCBO9nmkNiKjyyeXfCBAntFBiMtzh44IMKAbISD8=; b=DwiBHVB4oho1S/dcPhSoEt2ik6
        39rrMw4CtCEtpH3mpeU4wHGkY69YeKdpt6vpyLAeWSF6byhSouwrK1w2/t1YKyHVhaJ3b+dDo2spp
        kKPXh+yuGL6y3k4dyUTgC3n20NRC01QaK/1irlgv+FCV/MjYuMrrSC9UY4Fzd/ySBE+BGgfaeHJkd
        JWZxuICupK8YGsH8H/oEI0ErKTbZ00vX3B+HA5WlyL2bEfNmJcE9zEG1OQF4xApUCpXSslWR2EGdw
        pCguswDZTMvfBwo73bGx5fJIR6VRVis9PUoYN5+0CdPQQ7weq6GNYNLOmUnZVUDY+hpjHOBPBMsOV
        TwD+9Rmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59iU-0006HM-Oo; Fri, 21 Feb 2020 14:55:46 +0000
Date:   Fri, 21 Feb 2020 06:55:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] libxfs: make __cache_lookup return an error code
Message-ID: <20200221145546.GQ15358@infradead.org>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216307576.603628.2104009841729823514.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216307576.603628.2104009841729823514.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert __cache_lookup() to return numeric error codes like most
> everywhere else in xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
