Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5428AC54E8A
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3260320731
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ObDKqwlu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgEJHY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A178C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3SinYE92GyZQrcKaE2h8BAMFrUmoRzQOnwNUg0V5Vtc=; b=ObDKqwluDCPZhu1knd8mfbEVfl
        f7ijFlMKycXcTFZub8XR8lhpUb6JiyidJmMQbVQ8KC1jWi1AzjKYTB2iyB0vCiAWJtk/EaMyECoKD
        H6BU0pvvyixVpVmC2MA+OSyKaY8HNBBZIzWVWt77ZToQYLYMGAL8+mr1L7/4aV01Ry5M/DxIILvGi
        4SVgCv1Lk8k1ix7ZldpH9RMA3S+HXg6mcGtewzaewLiCCclXeE57hi91XFfGSO5va8K9UtS3mvOwE
        pz7721t80UEL3WlSYg7FAU1cSvvS9RlPI1CAl5ML3+bL5gHZOKLd2eJW/SMsZa5KZUpyvHMeVxIe0
        KSYHI29w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgK3-0004x8-Ib; Sun, 10 May 2020 07:24:27 +0000
Date:   Sun, 10 May 2020 00:24:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs_repair: refactor verify_dfsbno_range
Message-ID: <20200510072427.GA8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904186058.982941.7156787817804393560.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904186058.982941.7156787817804393560.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor this function to use libxfs type checking helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
