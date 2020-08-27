Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4CFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B91122B4D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pt5dF+HV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgH0GoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0GoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:44:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4F8C061263
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=20VpnC6oOWzZAfaGlLGCA03snzvGMN/dfo2hSrKrFow=; b=pt5dF+HVV9Ct+ClsVIrXcQ2af9
        eamSuqDhU9c1ZP9diBiD6dnqP3RO3twlJ+RwzisoYJiYDERn8mNU4SRC4fx8Srsr/6C3QENGUULVj
        DJGfRYV7hWwuyzOwrazyDSJDB6/GykpxWgg/mkN7x0gL/u1pfNg7ZVLZ30t25y+B7EsoaCXKbW8G9
        OoAD8O88DREZIILJrdBZW2NoIcVeETjmduUEPHMPx81XgvtTvDPnHM6s2AJxppW9N4eZ2Els9H3nP
        OgS9tdurY2JS0L0Rw07d8QDX7UML+qHX2ZP8PNnR/9loDAqyKIH6OfhhVVZwhHRCCEkw3b+k8CIiH
        vSK/kEAg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBdv-0004HF-Hs; Thu, 27 Aug 2020 06:44:15 +0000
Date:   Thu, 27 Aug 2020 07:44:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 03/11] xfs: refactor default quota grace period setting
 code
Message-ID: <20200827064415.GD14944@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847951741.2601708.15806838224468188924.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847951741.2601708.15806838224468188924.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 03:05:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
