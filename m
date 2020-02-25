Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9BCC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2BA620838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EGn9+hIT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgBYRw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:52:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731281AbgBYRw6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HPQvTuh9p0qPt2nw9BPJZ2KVXoffuqd6eIp95iufoUA=; b=EGn9+hITWv4RcyaMNbMjNCmAFL
        oDRyEd8/gmruMLl/pvKPqfQcSXCUKYsN9qEJZgDQB/xFHeCow81dGqxpHK4KMyE1Y2LfiYZv5abUd
        2nOaAwTWWQCMTLvHbm5ant8DGA9FEXJNrfbY2kC4KHhRwwH7nVHn4gacNQ7aM9oXagZmP10mAODqM
        u1oFw77aX2CqUud4Feb+S066bevV0XV0SljbhIwfZYDlMPbTOagWs2F92nlyZDEOC1NnYA6Eu7v6o
        fX9LWUr/TVrz7I0jKClPDJPGz3vI1L3xyzuw8pNrcxQc5aCEyA/FSlTFGhkYP1+N6o2uUY7FzzNHL
        sg++BqXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eO9-00013y-E5; Tue, 25 Feb 2020 17:52:57 +0000
Date:   Tue, 25 Feb 2020 09:52:57 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/25] libxfs: remove the libxfs_{get,put}bufr APIs
Message-ID: <20200225175257.GU20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258962890.451378.12681114574724102575.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258962890.451378.12681114574724102575.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:13:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hide libxfs_getbufr since nobody should be using the internal function,
> and fold libxfs_putbufr into its only caller.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
