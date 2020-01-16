Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18316C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3CF921582
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PlmmVM7K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgAPQrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:47:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34902 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbgAPQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cIWCuT83Yc8sAN1Z+Xue58/l3GomlSmjn4NrXKjMpvY=; b=PlmmVM7KNubeusdDtL71RgH6V
        AsfwnG/aXsvkii4TFXo1hTmfoVEyGZ1+QGn7a6QVyT82e90JeFFGlYtIYLXehZSj7a+2bdYJBx8qO
        6Q1R65Pb2L4a7l1BLb6RjaxhisGXZF0iyvXRgpb9VFs7CStw5c8PKB+Jim7A7YiYy9FTz2ge4pnvA
        yfmPt+6KVtVnZl507TaKlwP+YzKHrPmAjf4tYL3MVx4QiH/gTdnOgIUpQzf1vAVWKjJn6Qu5CQRiu
        nrUQzK71OihPzhdaeli04ggeJqrU7/UIlkutZQmg9vyv2RCBDgZQpfeXRh9lQ41E47gaGpsnGZdAG
        mdF7l+Q7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is8J3-0002Kc-Rs; Thu, 16 Jan 2020 16:47:41 +0000
Date:   Thu, 16 Jan 2020 08:47:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200116164741.GA4593@infradead.org>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915535059.2406747.264640456606868955.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 10:15:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When writing to a delalloc region in the data fork, commit the new
> allocations (of the da reservation) as unwritten so that the mappings
> are only marked written once writeback completes successfully.  This
> fixes the problem of stale data exposure if the system goes down during
> targeted writeback of a specific region of a file, as tested by
> generic/042.

I think this is the only safe way to deal with buffered I/O into
holes, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
