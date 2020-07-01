Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE571C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF3720775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fYPs4Gtq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgGAIXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbgGAIXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:23:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A6C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1olP0IfBHInLncIfO+6kYyEs0+SplQVJCx15Y/bBzoQ=; b=fYPs4GtqncywyRpY/qz6/REkA5
        MoThzB2S9OHomf6IXswTbLJqeJVwb00MoseU2ZQBmmtTAzg9Gt8VLYbnk6+BaskhKnPWdGcS2hhfn
        Yh+ZfGQ9I/U70HvnfUyyQ1pps8PEiUZHqwefgFSDHLEWuBsfCf7e4OMStOdT7e8HlEnKCCxYhMD+u
        CZ4hYhnrcd3qLtC6fyu18pY7sYOhQiIlAxV6mIc+noiqyM50akMYPBOpQIlkmOLkENi1a5cI88xGr
        ZEIAiun3BYLPqpwH7P7dA/wWCLaawo8iLyZA4k9J0xO2kkbSKCbuaBiZHpRm9y+1IM9sScs9jP8Aj
        bSjN52nw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqY22-000666-B7; Wed, 01 Jul 2020 08:23:50 +0000
Date:   Wed, 1 Jul 2020 09:23:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Subject: Re: [PATCH 7/9] xfs: fix xfs_reflink_remap_prep calling conventions
Message-ID: <20200701082350.GF20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304790475.874036.14660403277438656965.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304790475.874036.14660403277438656965.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the return value of xfs_reflink_remap_prep so that its return value
> conventions match the rest of xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
