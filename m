Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87579C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B52224656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JoTuwZrB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgBUOyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:54:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUOyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:54:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V1ht46SwKemMDo4nJFvtJYgR+1dLV3rrGIS4c+9ANt0=; b=JoTuwZrBdSoN7wpqEg7Pbi6Cup
        ALzyeRMIk66GagnBAW2BpSNsapvTmqXM6qCUSZFUCqxMFybBPlyrjQA0R1ITP2v4Ucs9z8sSzc3yK
        2MPG6vnG1dXTg38D5rbOaSkTOf0WNkwlHdfCqyaDIj2nfChHtZLFMmxAeMZ1bUMIEPvieyOMphQkW
        PhZPQk6mavXfr4I15oUJbyNTDDeq9so7O8I2RqDTGv+E+PUKax2ryf+DPOFmtWNP8MIc6WamBToz4
        R0WkjzDVA3Vr/1fkeyJgzl5dRJuBF0+gdbZW99+Ej6jfDqQVcuOF1L5IujU+ZiLWpAWgx9eByRjFa
        vGSy6S6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59ha-0003kT-8b; Fri, 21 Feb 2020 14:54:50 +0000
Date:   Fri, 21 Feb 2020 06:54:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/18] libxfs: rename libxfs_readbuf_map to
 libxfs_buf_read_map
Message-ID: <20200221145450.GO15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216306157.602314.3988177354387047296.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216306157.602314.3988177354387047296.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename this function to match the kernel function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
