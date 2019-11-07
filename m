Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BFEC5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9BD2077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="THh+1d+6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKGIqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:46:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfKGIqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2WKCuj57emaaq9YO4KPMyxsoPEFfXWmjG09NgOalkvk=; b=THh+1d+6fBMPiUpegUGX1CfZu
        MJE2fp2D11zeJHznxG1Y0qDYzuZxpH0MruMGX/Y2fTgycIOpoN7j0/1DcJ6YveWMYWl4siB7TIFfl
        plWrxSdipFnM+p01Z4aedhw3pPcdjJk2jphjar/XgQvoRqjd2vAD6QNjvWdrcMC8iHS25kX2EhLrv
        9G7qwx0wx7on5KXwuzQZWN/Q7BzLVP274Rr0NqvNaIMwLvy5wJl76z/v0CxU18OaD0zK4U30P6KEe
        0WR2i3NeY2sQbFh0XwZWmB30IE3A1PfoaQzdn22eRsnfHtxTQ4w+HgbZDbyr3YsLnx6M3GE2xofWz
        oaSIevZYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdRE-0002BO-3i; Thu, 07 Nov 2019 08:46:44 +0000
Date:   Thu, 7 Nov 2019 00:46:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/4] xfs: convert EIO to EFSCORRUPTED when log contents
 are invalid
Message-ID: <20191107084644.GA3364@infradead.org>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
 <157309573590.45542.17137773028975239453.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309573590.45542.17137773028975239453.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:02:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert EIO to EFSCORRUPTED in the logging code when we can determine
> that the log contents are invalid.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
