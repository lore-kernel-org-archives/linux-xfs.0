Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F474C2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C65B0206F7
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tmbNcuay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgDIHnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:43:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgDIHnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CV6Te7SSsVYfO5qXJMVBonZD8GFhNGqIndenQtc9TwY=; b=tmbNcuaywUI6i+NDiziDUA8RaL
        kycXIo91adcsRXAWqHnGYEFWr7GmKV7nTlXwy+Lt7hhn5AMtwOfqxyWkNYfJKUpgn4MkU/puylKHh
        koPiV0RhFvfvgtUq4f59h0w9rFkkYeEEAjK6Nl7oqB4pInjMpOBCDe1azwDSklQm5F41PpyAhoV8p
        fG16f7a1pIuUVPnaJsRH56uCFFXLkmniGpESscGG5qkINdpqfdVBuWGnm9NTBwZP5Ta0a8Yyr6Qw7
        ccapTf4J+8jRa0VPEpfg5Pt8X09LbP5OhSAB3H88k8YmaPr+PR8/CJ+YCWJK+O8bFbkL0PiBIa8Vf
        49xKkLiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRqO-0008Ke-ID; Thu, 09 Apr 2020 07:43:24 +0000
Date:   Thu, 9 Apr 2020 00:43:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] libxfs: check return value of device flush when
 closing device
Message-ID: <20200409074324.GF21033@infradead.org>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619915636.469742.17283369979015724938.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158619915636.469742.17283369979015724938.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 06, 2020 at 11:52:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Although the libxfs_umount function flushes all devices when unmounting
> the incore filesystem, the libxfs io code will flush the device again
> when the application close them.  Check and report any errors that might
> happen, though this is unlikely.
> 
> Coverity-id: 1460464
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
