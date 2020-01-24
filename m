Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDDEC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 22:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 884572071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 22:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IdDOpwkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAXW7e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 17:59:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAXW7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 17:59:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EAJEDamQ3cCtZ2tBXNi2BTIDYvkk5/I8M48y+BzhHes=; b=IdDOpwkcMOH0r7wH6Knvo9MMN
        iufa1yrZ8lcBNY+gXlPcvmh1ae+j61s3y6Q5nOiS+aCEL/Vkck6JEaZHrGA8XIIFFDXq3BWkPMcAv
        PYvu0WFLcYUKiY9sky3nLAOFQHDzrKGI/hft3A+yNPU2uLDfrJQ44ET8EtE/KeMXLvqRTzBU3hqGq
        alTbHbwX7MA3I6mjjIOeXTemFyvHQSlJDb/ISlqP1INSHZ7OGmvNKdxo/HEQvRIjbxKgHEN8JsDO4
        sRGEuiY8GQUY11WTLAzZYZS36CkhGaLZgpTomZLoPZb1+LiDk3C0sAMe4jvJJc8R/6i+C1eoW1KJX
        DHGnyxH3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv7vJ-0006FG-FG; Fri, 24 Jan 2020 22:59:33 +0000
Date:   Fri, 24 Jan 2020 14:59:33 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/12] xfs: make xfs_buf_get_map return an error code
Message-ID: <20200124225933.GA20014@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984314875.3139258.14065126701620712857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984314875.3139258.14065126701620712857.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:19:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_get_map() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
