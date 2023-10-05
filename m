Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AFFE92701
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjJEONJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjJEOLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:11:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54B721D16
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 02:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dfwKhSr8G95gQtD9xuUXNbfV9TTqFwSajNkBY4sheKI=; b=1Td590XLG2EBLv3U+L3o+I71IM
        0JA4/ihi80oF3BZBno9D7Fr09Uw/thODPlbYUyf9ZjWjB7qH/1KvFDqrFolguN4x8V6DDVGAFFAeO
        Q9LT14vFBkBaLKZj9C5lOpYA39eCu+9dYDlAoXZaLjZ36b6qgBN0+9s1w2NejgLm26cZKKiYCKEe8
        w71ZZ6uklDTwgiEcdwo1Jf800RrZJ3EqkiMaXrjVnrVHJSiJiC58aHBPFDbj4xzOLEWB2WlMzN5yX
        lUGRxOCM5wyhK6Wc4u5mJ9pfBuh9UPtoKwlghmx0RQaU6KpCwd1qY4ICEI2iZHfKQQKlCwPEBaQH4
        1tkYALhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoKvy-001n3I-1d;
        Thu, 05 Oct 2023 09:46:18 +0000
Date:   Thu, 5 Oct 2023 02:46:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 3/9] xfs: select the AG with the largest contiguous space
Message-ID: <ZR6F6oFbgOgjeWuT@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:37AM +1100, Dave Chinner wrote:
> +	if (max_blen > *blen) {
> +		if (max_blen_agno != startag) {
> +			ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
> +			ap->aeof = false;
> +		}
> +		*blen = max_blen;
> +	}

A comment explaining that we at least want the longest freespace
if no perfect match is available here would be useful to future
readers.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

