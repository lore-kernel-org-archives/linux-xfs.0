Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F00C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D75D20828
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FcPN0/w1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfH2H0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:26:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2H0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JYtBh/AGEOlFPIQUAMN2b5F6b7Z1CgBnTINhaueyyUQ=; b=FcPN0/w1XSmFU0uJK9rPKZcJZ
        8/aZV0/zcbNmoWt3NtplXvJQUYGcOVgPRdicVQ8bQkfoO9AsTwkz42AdMoXxta+gXYHG/UbFnEaKr
        qWWUHfpdrXWL5l5z4hQxkUL/9U5TNRNm+jKNQxdSy8OfxEOJr//RMN2hg8YsA2TeDjlFRy+DdIF8n
        GY2arKmf1UTl32vIEgsAWb9eXDajbG9UpJNIv0+s9483LMWfbeCteEgBpypucXUpd8B7LiC+BClDK
        6ncTsrVmEQE0JvYYfMZ7/b6KSVhXI1h28RzTu6lpVT/JhTqt4vKK4V0eGpJw3YzdU/sDaeyb/NV5s
        8iz8eo6Qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Eou-0001gM-Q8; Thu, 29 Aug 2019 07:26:12 +0000
Date:   Thu, 29 Aug 2019 00:26:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove unnecessary int returns from deferred
 rmap functions
Message-ID: <20190829072612.GC18102@infradead.org>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685616759.2853674.14113052736055839178.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685616759.2853674.14113052736055839178.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the return value from the functions that schedule deferred rmap
> operations since they never fail and do not return status.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
