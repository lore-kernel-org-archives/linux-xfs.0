Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C02C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDA020656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QSTM0CZo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBUOnp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:43:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgBUOnp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j6OPG+Ofa6CUseRVznU4hzK76L5qzbmjnZw0kpzECNg=; b=QSTM0CZo/EGmEQ6bl9E3DHf0JT
        8flH6I/d4EzYrSt15w1Lhh+Tdvi6zdWzwIFyowBKqGp6/j6HZ2FAjvx+thEvAzgCP6KxS7aQxEmEf
        EjJQI90pFUV0ZD2pmXveiSEldUjav1PKwF8DJkC4EH1p4i96TW2iQ3j6FOGPKe6Fct0W5DXpKgeyS
        9gi9elGZYxRoAwNDTF2Qg+uJGEQApzhMDi90Fk22TXn70qQmnsEKdcBuGzZT3cdX/WAwNTEmYWiq4
        yTkYu5leco/80HgQc0q9B8pGqkSBV5WjRvkoNzSO9a7CKvIj2Coeb3/PdIQ54za+H9iagDOzM6k34
        qWKymWzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59Wq-00067l-BB; Fri, 21 Feb 2020 14:43:44 +0000
Date:   Fri, 21 Feb 2020 06:43:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] libxfs: replace libxfs_getbuf with libxfs_buf_get
Message-ID: <20200221144344.GC15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216298676.602314.14219714632503201687.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216298676.602314.14219714632503201687.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change all the libxfs_getbuf calls to libxfs_buf_get to match the
> kernel interface, since one is a #define of the other.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
