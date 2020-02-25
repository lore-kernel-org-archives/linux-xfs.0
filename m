Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFEEC35E0C
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB28F2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tLjAN99d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgBYRnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:43:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbgBYRnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6Dtbm+7Fw7Q+otZHrqOp9bhFW3T/lt7mPxGD5sbhQyk=; b=tLjAN99dLbt2lSvih5GT/0Ki79
        DXCsYXTaN/UL2lnrg495iocbNRHzaq1M1eM3ZdKUkrrnrNgC+pSRUpo8jeiPVvlruhPIBZdXzUqFL
        5UDW7z6gx0lPIKqzx1dVIsVmGb6ch8Ceci/D6rXLZbCTBaq2LciUGFk8nsIqFMJU53fBxXWJDiCSO
        +AtpQiD6HyE5hSShxZMQ80Ch2mg5+721jmA/XwGwtgG6QsGye3yyjllJ2+T5eFiZHCzNJLM+Jm6Oj
        rwIPPi2WhLgHX3dMPuJQ/u8f/3T4VwaoZFseeSwLwvl+IY2ZJpLtFxiC8DWDNnh/wq99lnwMS6aQI
        ijrMF55g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eEn-0005fy-EX; Tue, 25 Feb 2020 17:43:17 +0000
Date:   Tue, 25 Feb 2020 09:43:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/25] libxfs: remove LIBXFS_EXIT_ON_FAILURE
Message-ID: <20200225174317.GH20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258950229.451378.9483745495391694498.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258950229.451378.9483745495391694498.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that the read-side users of LIBXFS_EXIT_ON_FAILURE are gone and the
> only write-side callers are in mkfs which now checks for buffer write
> failures, get rid of LIBXFS_EXIT_ON_FAILURE.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
