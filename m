Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BD3C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C03F206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M3p9AE0Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgGAIus (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGAIur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:50:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCF9C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hZobkoDO0sn6IQP20GdK1eGIQy+gu+wZ5xQJM1c4tNA=; b=M3p9AE0ZmJ5xVOZOfs3nPQet7c
        B51XNFMZowXYIlskFbc+EtaEgGHBKr1esGUseKN7XNdV7THYAielyOwtmCYr7mGlThX2xmDkgIFDt
        9gks/BFI59/tixEYyFr44BD7XBYRg2P6uAg3cQE8/ddUpiLsmJfDS5ncEqFpG1O6OIdZngwaluguU
        lTOtu5uzVDwTWvAfvIBQ7b3Y+yMOa/HVhbzieHi9/fhRrHeK62tT+TVxHEMY5nVjHJ7usim6MA87I
        k+5if6NbtMVCWXGnJwXab3MSN6l0oS/m+Im+bUbOQ8kGvOlsis4Fh/M/VdeGmvgg2RI8q+TVXcSXf
        W01BGfGw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYS5-0007cb-UH; Wed, 01 Jul 2020 08:50:45 +0000
Date:   Wed, 1 Jul 2020 09:50:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: stop using q_core limits in the quota code
Message-ID: <20200701085045.GG25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353175596.2864738.3236954866547071975.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353175596.2864738.3236954866547071975.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add limits fields in the incore dquot, and use that instead of the ones
> in qcore.  This eliminates a bunch of endian conversions and will
> eventually allow us to remove qcore entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
