Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0A6C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 16:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 316932072D
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 16:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tH/eZtfC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgCEQtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 11:49:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgCEQtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 11:49:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ooq+QeG0gNQEodBqpyLtepbX3bc28ULrJ2An20jhYYE=; b=tH/eZtfCW3Fh6SJw0NdhpZa9O2
        a07skLTOwP7Zx+BV7p2roMWZ/WcyUS0iY31yeZgpgrQXYrzd4SIsTB4QErnHBbM1eY0qg9bnj5wlQ
        etT14DE5vZlwYI2nCCqjpjHEB++5tzaUKt+bnjpQ/3eIazRmGlAwG/L1TJiVOfTP4yI7agHfywniN
        7v3G932uMjsMSHbU14XS++UotAngyQRp8x1P0KKHlVRdauZGVuMM234yRA1p4oFqBe3E4x0YNjncV
        i0H5BqazzkMaW2K8xRAjePKUE5DMN3fCH0Qn6o2yavXb9Lf5P+GkCLZKWln3bxtKOcjsNj107vw+q
        ExbJ2NHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9tgx-0002MU-8D; Thu, 05 Mar 2020 16:49:47 +0000
Date:   Thu, 5 Mar 2020 08:49:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
Message-ID: <20200305164947.GB7630@infradead.org>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294092192.1729975.12710230360219661807.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:48:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix two problems in the dir3 free block read routine when we want to
> reject a corrupt free block.  First, buffers should never have DONE set
> at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> pointer back to the caller.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
