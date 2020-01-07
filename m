Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B34C33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCBC8208C4
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jVpiRVkq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgAGOUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 09:20:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgAGOUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 09:20:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3FTVxRGW3eQb2DJJOl1ICKb5SAFL4iIXYBguW9371Go=; b=jVpiRVkqh9UTFHXDjA+RHs7xt
        n5a6W3aMcte7xoeWxYDpCQlzHFeyoyTyK23HAP4P+LydxS+yLsnOA31aYMHKfpBXO7LBdZj5634pl
        QH0JRzhTpEJ0hmvZPgmojQ9P8rVX6Zeo7ONVmcvMaz18zp6NV20PlcIraUBWnx4Lhy0XGtCIR7/7a
        N9AyU5UgG8SgaMMszY7wloMUe+P/XcWxOaI9GYrZ6z5O4K+2CF87SBaAy8rCvFJiPUYpoV0A+M24r
        Xu/x7Ekv1NPnJ3GMKb/iw+uCMau1Y6oJEaEl3CG/Q64sos8/2UiCqTZqu7aCIrD/EOSBtu/tb8lNF
        6ZE8IIK/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iopim-000605-0Q; Tue, 07 Jan 2020 14:20:36 +0000
Date:   Tue, 7 Jan 2020 06:20:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] misc: support building flatpak images
Message-ID: <20200107142035.GA17614@infradead.org>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
 <157784176718.1372453.6932244685934321782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157784176718.1372453.6932244685934321782.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 31, 2019 at 05:22:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Poke the system until it supports building flatpaks.  Maybe.

Why would we want to support such a fucked up package delivery
mechanism?
