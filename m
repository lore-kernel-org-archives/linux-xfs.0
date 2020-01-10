Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EEEC33CA2
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7052C2072A
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fx6WBpxO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgAJLwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:52:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgAJLwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:52:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t7yDZiI/Mrbo8/Hzp2G6aWT6MxFBFbGngD7E4cok43M=; b=fx6WBpxOXfc46PtTD8i74KdNu
        j0l1AV6KjFZluZ5b6FXbFv4SKg9+84GdGldJjgawV/6nSiG70aqVe/qEpuqeaNEPRYwh2RO1QdctD
        QzODKzxymfoXyONvoNtlWaPzVf8yEAVSGZsXuBkofkD/GMCVqYCBqIqFQWcd1LU7WXUM8QyP8Zj4T
        P5iKPlmSxYjMEglUNk9KaJmSzgytGS7GnKHer6Al7NYV6ojURwykPX4oNlPStfxEBp33VywDHGAGu
        iRTM32YFS9qdC34GTM+YL0AaKBQGwcJplkNZ4jf7dheDDNCmAx1a45c1qYL5bU8eDU2eOOwcJgw3r
        90S3fSJvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipspv-0005sI-F4; Fri, 10 Jan 2020 11:52:19 +0000
Date:   Fri, 10 Jan 2020 03:52:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200110115219.GA19577@infradead.org>
References: <157859545662.163942.11245536419486956862.stgit@magnolia>
 <157859546284.163942.8882319204815065001.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859546284.163942.8882319204815065001.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 10:44:22AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new #define for the maximum supported file block offset.
> We'll use this in the next patch to make it more obvious that we're
> doing some operation for all possible inode fork mappings after a given
> offset.  We can't use ULLONG_MAX here because bunmapi uses that to
> detect when it's done.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
