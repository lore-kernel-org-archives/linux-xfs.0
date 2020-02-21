Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F9CC35657
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F7A24650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j5qiLyZb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgBUOx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:53:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbgBUOx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iXuRuyjGUAU4Vxh4IutmafDFTDb6MuIlCovdlulJqUE=; b=j5qiLyZbW8lu6Lhn9iOk1SZYS/
        3LIW4CZkE3f08GFlPAAzywuluZ5VejMRlHJTVOGn+FACfZtYlSJzxOnkhREqdhIfXSL2w8F3tgiSa
        oWf6MKW/WRy3r4myvJ8s5ZMLUxuyhOFsHaqeKpM6GBsy9QOT15rvifoYpSjwUncqyIuCImP42wfVI
        qZlTCkSW6MS7ENEHCjcQ7sksfKeJ2Ud/eB1POLS16NkYqVHVDokgpzyNgUC2vLSwGNl8URCv5VY7w
        p6F0UpN30R3o4zgxE/MEDBnwGUh2K2ETVI3vIo2AqI2rzESmq9v78EavUHAJ2pzGLMyazizPQHzpi
        CdZe56lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59gE-0003TL-5E; Fri, 21 Feb 2020 14:53:26 +0000
Date:   Fri, 21 Feb 2020 06:53:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/18] libxfs: remove libxfs_writebuf_int
Message-ID: <20200221145326.GL15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216304216.602314.17621620292262138084.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216304216.602314.17621620292262138084.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This function is the same as libxfs_buf_dirty so use that instead.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
