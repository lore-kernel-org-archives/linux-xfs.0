Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74650C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B3D2075D
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P32tz9G7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgAXXIZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:08:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgAXXIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Vi/OE8GORXi8+QSk2ZwTWWhs31Ieu2aAQwegBysRNvM=; b=P32tz9G74Cx4KKR5BurWh747K
        KdQMWoJ3zQMyV34+qsAkRT+0Ta4BYGRFHPRz3BBDqz1YHE64AaYLz00jrhci6cJU4zOcKxg50hJNu
        yDT/qVFrUgxHmkf47+GCI7VcUzYW8TmNGqtMddy5UHPQ86iCTvxV+DhXucXdOwSBNUTjSqFvjT/U9
        GOamv7ChEIPQjOL6WYexOo/YSOcL1sd/N6IP8EA3lLROhkzYOVeC96CTsbY+BHnEs5qQxQmKCp2oZ
        0SmBVCu2qCXhFySlpr6LaSBnxmYAkcKreJjyMLpH6XsrjV+SY154TpJsT/jE9xACqSyk77tfykL3x
        zsca/RJEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv83t-0003CO-1Y; Fri, 24 Jan 2020 23:08:25 +0000
Date:   Fri, 24 Jan 2020 15:08:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 06/12] xfs: make xfs_buf_read return an error code
Message-ID: <20200124230825.GC20014@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984317522.3139258.12286918099052261683.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984317522.3139258.12286918099052261683.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:19:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_read() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
