Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF46C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B7F233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 07:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ivwrEWPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfH2H1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 03:27:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2H1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mVWTQeX+aElrwwuDZ3Zs0jyMDB+CNfF7ocRK2BN478k=; b=ivwrEWPL3rjU0QXLHF338fztZ
        aj1J4+Naj2/GlVzztkvaPvROGP4moVv1sxDcxhbZbzycDWqHym6ExZJU5utOCbROcOVrXGRVUfotT
        jOyal9QqymnlWGJ2KS7fmyHfIKkn0v+CCqcHRriOrVSHzwVo5n19CE2t5et39mjQi4BXo/mjMnzcH
        lhZE6DqvIR7/RQi9wKs+uYD5yefwVtawF6mHhQtvMIIBKi4eDH0aGzb9WTcHsK+oLZq0PFNrSMlT6
        h6Dx51TWHpgkCWOK1W8wyJHAgFIz4NeXgwA92etnRrcPR4l8/PWnjooI3A3VjffZkzR/9o2bQKY+M
        RBLWW/oVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Eq4-00023a-T2; Thu, 29 Aug 2019 07:27:24 +0000
Date:   Thu, 29 Aug 2019 00:27:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove unnecessary int returns from deferred
 bmap functions
Message-ID: <20190829072724.GE18102@infradead.org>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685618004.2853674.8675927096254274691.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685618004.2853674.8675927096254274691.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the return value from the functions that schedule deferred bmap
> operations since they never fail and do not return status.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
