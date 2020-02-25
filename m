Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F370EC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA482084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tAWYsxYW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbgBYRkk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:40:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbgBYRkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mITJJbYepNXjK/aRqHEam/1gRhkd6Qp8umo/ziLTz9Y=; b=tAWYsxYWFa80Nw0tZ9PjuRMpvp
        MpnLZEhACw8iXqQbdbj1HYjZ3iAMkZsSdx+EKKNN6tyc/mEAqFBsafErq7TIH50ULsAJ6wjhrAoI9
        91XOvVhStpNJpsneFu6fzwwXKT8jv0mVz/CVYbOtBz5oT1/Y5Ea6K59tsZnKirc3t7cB0LNTf60vr
        vLizr+pfhD8d4BvFD4OK4rqqEQhzLXBM7ZAoVyDMXg4XdGRVDVMTUNlwEStk7nKEpEyZoJrh5F3V5
        iCakzFh5L4vor/3GuKTdxsSN2yQfgugXHEKnNGO2kW+9NrUTeohtCmekZJrzLFjrUd8LXMUDXzppa
        4yofQFdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eCE-00039J-Sh; Tue, 25 Feb 2020 17:40:38 +0000
Date:   Tue, 25 Feb 2020 09:40:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] libxfs: zero the struct xfs_mount when unmounting
 the filesystem
Message-ID: <20200225174038.GE20570@infradead.org>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
 <158258948007.451256.11063346596276638956.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258948007.451256.11063346596276638956.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since libxfs doesn't allocate the struct xfs_mount *, we can't just free
> it during unmount.  Zero its contents to prevent any use-after-free.

I don't really this at all.  Seems to be cargo-cult style programming.
