Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BBEC33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B75FC207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DWGvcrGW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgANImq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:42:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgANImq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:42:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X3+e1dDMg+xG04rqEks3qF7OaDIkqxMOjgRRnzFEOXg=; b=DWGvcrGWpYb37Auc9ph1b89QK
        Dx9KwI8QIbveLtfdQIVPPte4Mxkiwa9EAtRAYt4R5vab/Pbtm0Uwb0kk6ftVkSGdCV/E4r16xbCUd
        jk2q8aS8mayw4nkY+K1a+3Oz54oYV3r3ewftOBNhPv3gJcZ7SwfX1vsw8O9YlOv0Z71aqdClJgXjV
        hyk13rFBGUcjZENb/Y6R6y5DdcBznuEwOUPxzhf8/edwWcf5n0ryqwFTwyKJs6Q4ifwUEleLuHguZ
        VlvKZRBlBjTpYU4dSnc1nL+X7B3NujINKZzqjEckdWvDFcCXlmBm/t1uQz4xNPPJPCnAInllWoHl9
        SxJswna+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHmf-0000sq-R1; Tue, 14 Jan 2020 08:42:45 +0000
Date:   Tue, 14 Jan 2020 00:42:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 6/6] xfs: check log iovec size to make sure it's
 plausibly a buffer log format
Message-ID: <20200114084245.GD10888@infradead.org>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
 <157898352983.1566005.3041225371468613382.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157898352983.1566005.3041225371468613382.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 10:32:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When log recovery is processing buffer log items, we should check that
> the incoming iovec actually describes a region of memory large enough to
> contain the log format and the dirty map.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
