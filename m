Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62974C33CA2
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2922B2080D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GdvBdLwT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgAJLwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:52:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgAJLwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:52:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p7YtYbYfuL3AH/xT4MqGIGY8GSFVCczaYo1ql0HgWDA=; b=GdvBdLwTbsTlMZuT8K9l0qd6p
        mRPwhReHjGYJpuLqq9Dk7YLEWGRvfbAslyuWYMywpcuLMkpfb9/8M3j7MtDMGQCK/eRaELCrD5+ZD
        7hlXrNU54G0GGOEiHUbSwE5+USQdGlvyKboLNszmRU4CQEbl5Gyz9ee1yGAEkMv+8LhkDimU7h8KL
        3hM/wIzic4wOue6m067Dp0a08u8FOCN+VY2zg6/Xge+BepYDOq09VQss9jQd/d43PzalI+yHrgpDQ
        3Lz/lyd+nJzoAuV5M9NB1Em4aEhhuWMNl75o7xgSBV5R1raegTq8mk0lU80lNXfu3qF4aYzFSwAJO
        STvaSfDvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipsqN-00063n-7o; Fri, 10 Jan 2020 11:52:47 +0000
Date:   Fri, 10 Jan 2020 03:52:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: truncate should remove all blocks, not just to
 the end of the page cache
Message-ID: <20200110115247.GB19577@infradead.org>
References: <157859545662.163942.11245536419486956862.stgit@magnolia>
 <157859547075.163942.7214434913691255010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859547075.163942.7214434913691255010.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 10:44:30AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_itruncate_extents_flags() is supposed to unmap every block in a file
> from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
> bunmapi range, even though s_maxbytes reflects the highest offset the
> pagecache can support, not the highest offset that XFS supports.
> 
> The result of this confusion is that if you create a 20T file on a
> 64-bit machine, mount the filesystem on a 32-bit machine, and remove the
> file, we leak everything above 16T.  Fix this by capping the bunmapi
> request at the maximum possible block offset, not s_maxbytes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
