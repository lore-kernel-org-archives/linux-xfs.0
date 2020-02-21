Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF800C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91FBB24653
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IQRoeZ4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgBUOzE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:55:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUOzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Fq4AzH0ZOH+JSuwxyAwBKXdK4XEXVvwJJhdmCwPsfdw=; b=IQRoeZ4QSWKswzFGgcBRa2p9zx
        b7T4Cn0aymxLtPOYwZ7qD306yn6mX4MNT+MPbN15E8WTf9dC6TpF93xQ1yb5RWP6TX2D8t2mrVEmp
        VDRTjAK0X5jY6sATjWPfRRbB6CNjSnxSnloOSLu8wXQuo9WlYqxwCtC6Wlbl0Pw5YyNNVntnqM2vv
        p2SsykXtVqXTQ3YKeQJU0Rl70/DjdacXGRPlOrKP0cLQqjo8WcHcURMEUaPw2ekrsP7lfJzvFQ2dx
        SIleIJFksWP1kv9g7Mq/xj5vMxKREfLzgW9pdP5FfwTrRgj+eJixNdzjaYLilj5ko24Li5z9XgT35
        44KTQCDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59hn-00041H-6x; Fri, 21 Feb 2020 14:55:03 +0000
Date:   Fri, 21 Feb 2020 06:55:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] libxfs: rename libxfs_getbuf_map to
 libxfs_buf_get_map
Message-ID: <20200221145503.GP15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216306760.602314.2873425161697294878.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216306760.602314.2873425161697294878.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename this function to match the kernel function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
