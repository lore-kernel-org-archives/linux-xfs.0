Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AF7C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 08:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA3E2075C
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 08:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZaxYo4nn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfKKIvR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 03:51:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKIvR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 03:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VCR1mCMnaXvQGzJGpUGF1xEMGrT5ZqirfI9SfNdoVrI=; b=ZaxYo4nnn46T84fyE0LUpGEAL
        uzN/DasYYMbEXC38wWDTcqqhB239fO3gKxe8RSufc5BqAstf3B0dg0IWhWObqEZ99DSPeGRU2yPnP
        UcQ63KPqibSxKvuQ3gQsdKEmPO+Bj2WcHWSkW2db0oabvd3hHlL4K/+6S3/Jpn7/H6zV1RdEcMBm+
        /melAWY7/vJdHzxGbcWTDPe7eIxgJSfN2CUcPmh0rXN7lEC/JA9yK5nEXzl61oZblmkms61bJRRbU
        kDRVb43JO0uxOkRgbng1LqGRuSPWkYylL1zG9HrEkWs/dNUeM9CuJ3hpHGzgHHA0gaSSCFOKFu8wG
        BH5+Ke1xA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU5Pp-0004uv-2l; Mon, 11 Nov 2019 08:51:17 +0000
Date:   Mon, 11 Nov 2019 00:51:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.org
Subject: Re: [PATCH 2/3] xfs: kill the XFS_WANT_CORRUPT_* macros
Message-ID: <20191111085117.GA5729@infradead.org>
References: <157343507145.1945685.2940312466469213044.stgit@magnolia>
 <157343508488.1945685.9867882880040545380.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157343508488.1945685.9867882880040545380.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I have to say I really hate the macro that includes the actual
if statement. 

On Sun, Nov 10, 2019 at 05:18:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The XFS_WANT_CORRUPT_* macros conceal subtle side effects such as the
> creation of local variables and redirections of the code flow.  This is
> pretty ugly, so replace them with explicit if_xfs_meta_bad() tests that
> remove both of those ugly points.  First we use Cocinelle to expand the
> macros into an if test and braces with the following coccinelle script:

Also all this seems to be out of date.
