Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1840FC35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDA6620656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ywp4A/Gk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBUOoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:44:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgBUOoO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:44:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sFPB1TPmMlq0MvQhX4Ul52lQjWjEyzkFJ3FRfQm9kY0=; b=Ywp4A/GkaKOUQ0lvAceqfFzv7Z
        3JuFkUNqdDoTcucgNkEDJhh7o1QkzciM5ipfCPziqFR+ROwS+6Lb6vGdfrf6S1D1O48A1FED9Xfn/
        oGS6HWtQgh6X9iwgVvBAXQr2ejn9Uvkm7ghRQttUOh5IuOtsnR5C+82XHEDNnfrB0VgshKVT9p+EM
        IkUFFnKxoejZHgRlBT+T+n/NIeLUREdcUg8NQqmUfERXeB32cuKC2CHofqpRDuj7xnWlX3VhvIcMR
        qQkrpH83VJb+li7/lCG3/oW4FM/o0+yhndzz6N8+2k8LDuc9XsUEbPLJGIuXN1JYC5vQB/KTdrztp
        t2FY23kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59XJ-0006LW-IQ; Fri, 21 Feb 2020 14:44:13 +0000
Date:   Fri, 21 Feb 2020 06:44:13 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] libxfs: replace libxfs_readbuf with libxfs_buf_read
Message-ID: <20200221144413.GD15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216299309.602314.10312057165892234719.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216299309.602314.10312057165892234719.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change all the libxfs_readbuf calls to libxfs_buf_read to match the
> kernel interface.  This enables us to hide libxfs_readbuf and simplify
> the userspace buffer interface further.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
