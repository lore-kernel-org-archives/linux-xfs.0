Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32C1C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723D921721
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pd2AlDdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbfJHHBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:01:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbfJHHB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 03:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O7eFktMssjHYs9w+Lb2i2FfNl7Qsj/YhDvX2Tr0EAV0=; b=Pd2AlDdrj1ZUsDyKBEol+tW98
        TOYCzfGgfitpzPgu9eskSFJg9UUIog1QX7t28d/4iCVMzFAo/9m/WoqdVZsZ+1D6I4yJA/d2jPG8K
        RUdonlaBQHWPSHNWYC6YpZMjnyCXJFTLbUeXleN2a4xtjLfs7UF/nwenf+pZXUnpZJzc0+jdA7fWw
        jg0JXJ/IBoNBxwZ+ijHUyuIoEorqw93XJmbbeRfVvIehF+ToOaJPOTZQlVZa8cXU4DSluuQZenb/T
        3mA2LqWVR6eW2d4amaKOPJAz1t27w+oPlsvFBHA1u76I1Lhiby9LcSO0Ny9d5+Sbq/ynzBRnLF9Fl
        OlOW+9IoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjUu-000740-Ts; Tue, 08 Oct 2019 07:01:28 +0000
Date:   Tue, 8 Oct 2019 00:01:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/196: check for delalloc blocks after pwrite
Message-ID: <20191008070128.GD21805@infradead.org>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049659135.2397321.4055705884999858018.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157049659135.2397321.4055705884999858018.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 06:03:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test depends on the pwrite creating delalloc blocks, which doesn't
> happen if the scratch fs is mounted in dax mode (or has an extent size
> hint applied).  Therefore, check for delalloc blocks and _notrun if we
> didn't get any.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
