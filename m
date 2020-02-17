Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536E7C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E80C2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hjcep9Fg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBQNvC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:51:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57470 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgBQNvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:51:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5foyVOhREMEcgqpGrHdrghGj12PQaw2nHVMZge/gPtA=; b=hjcep9FgkPpXWZs1KqA10W7Cjh
        p28zKsEvr8mHwNEZ87GeRgvbifHYzyjEGz+WC5DR5NhxCzbegL8uWD6XnRQCM9ewSuUa98gDvpMdJ
        0PVXfL8VxHf3CTwrTaH869DPuoh4rw4mJF71XVOdcMdbdLGi+R0TaParXzlFG7MtCYmbqvxFTlAMT
        LEv3eGjHvwebcR/E6XrVApgxA067j4a4oO9XIHrTSzuJELu5NUMTJgowEsd2iKQAmkZfQF0XLyyUN
        Hn3D29z/Agft2YGU5MwBsLJXogQ3vV7J4HV20OV0v/RrBvCqZVE16U5kzIi5nUcqBJcwYWAIrBOhY
        soeW/9YA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gnd-0001GG-Us; Mon, 17 Feb 2020 13:51:01 +0000
Date:   Mon, 17 Feb 2020 05:51:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 3/7] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20200217135101.GG18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086361666.2079685.8451949513769071894.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086361666.2079685.8451949513769071894.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_repair has a very old check that evidently excuses the AG 0 inode
> btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> AG headers).  mkfs never formats filesystems that way and it looks like
> an error, so purge the check.  After this, we always complain if inodes
> overlap with AG headers because that should never happen.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
