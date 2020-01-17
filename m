Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF8BC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 07:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 165E8206B7
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 07:00:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lx7rZU6f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgAQHAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:00:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgAQHAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 02:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ls6W7HKl4MDkWlZ2Ssfl92ORGxUnvCAzb7XNdlNGXkI=; b=lx7rZU6fug70MqKIWpn+GFmNd
        vbOWbSd9HDf4n5SqKP2AYWFvsZYRjNSNP1BLFPZ0vvlm086SdmmvMmOSo1u9aNdzvfz8+Wm3eaygF
        EnnZ1y9tmkQymuYgZ7+Mv/mIkpYdslzn4XCIwMUuYaAnGPqCRIwPVkmiAfcSPNot4+lizwvFmGy2K
        X8HUUyWpDkP+rQ0sHHGa/KyUZyKevAdGNQx+1KR/jXriQ1okuuzYGPCC9U+VcHAsg9O7hGnlKOmJt
        8NqK3oYldLa/IOwrf7ez9j87CcDea2AVjtRjf1kpFs3S67ITV+LyIqAvk68ssrAgYLh+IPz0txClx
        w7dtjXKJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isLcN-0000n9-UN; Fri, 17 Jan 2020 07:00:31 +0000
Date:   Thu, 16 Jan 2020 23:00:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 11/11] xfs: remove unnecessary null pointer checks from
 _read_agf callers
Message-ID: <20200117070031.GD26438@infradead.org>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924228789.3029431.3716642922130140199.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924228789.3029431.3716642922130140199.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:24:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Drop the null buffer pointer checks in all code that calls
> xfs_alloc_read_agf and doesn't pass XFS_ALLOC_FLAG_TRYLOCK because
> they're no longer necessary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
