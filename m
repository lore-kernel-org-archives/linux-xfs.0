Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C629C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1814D20CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rUkWSFrm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgBYRpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:45:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYRpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rz655jaIUjk3zYQqSL6OY9ghJuU5tGYxBH8fOkA0zfg=; b=rUkWSFrmsli/V9LtW3HyOMaxga
        Nt5KY6sRsRywYFo5BG42NmihtfiyaLE0y8jifsUfTgElPtgmvv826xoaLldtP4jxHyWma+RRm7RLr
        lcL8VK4iQp4t8oNJrqrWAL5cbpaW0q/NeB6JKAAkIO1WO0MJ81Hq2oEWSVIGbhCx5SlUTkdw4rFCr
        5elb5pGkF9pL7gHm+dk4OiRqqx88nZIFsqtoA1pmVzHysUSKT0vDbkFeTNft5bUnC+AYqK6WqW3vv
        yLtF94AppvqKCWdlscsED5Q/d6Lk1lf3sbuF4S0IVuV/nWSyegKft2czLwiQQ6tUFpb0pdoRdVCF1
        0PqutwsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eGW-0006YE-Md; Tue, 25 Feb 2020 17:45:04 +0000
Date:   Tue, 25 Feb 2020 09:45:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/25] xfs_db: use uncached buffer reads to get the
 superblock
Message-ID: <20200225174504.GL20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258955793.451378.12834800309076146911.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258955793.451378.12834800309076146911.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:12:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Upon startup, xfs_db needs to check if it is even looking at an XFS
> filesystem, and it needs the AG 0 superblock contents to initialize the
> incore mount.  We cannot know the filesystem sector size until we read
> the superblock, but we also do not want to introduce aliasing in the
> buffer cache.  Convert this code to the new uncached buffer read API so
> that we can stop open-coding it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
