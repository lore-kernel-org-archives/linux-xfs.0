Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3AFC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 13:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E73E20714
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 13:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nfq2Sr7v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfKVNQJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:16:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfKVNQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 08:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Nfq2Sr7vKomyvMvQE70VWUktT
        Uri1F7nHaA8/+zh4oHjWKvr5Z+33mSlD50bhltkR3+cYHmSlgP+rl7L5KNZOZyBYZ8R0ZqsL2gXuN
        gRfp0dZzLkWQGlxqmn0740Ve0QfN7povzlDPFvkAsKhb3QuePoPig96b/CBmdSSCJK0mp+Q/hmoUv
        4RIbbkGXMCT9AHFaMeZFP9YbyiYmQEek3xBlJ+g2i+vTI2xx7Xw3nhVufeW7/O0ZGYb0gflEo5dQy
        IqH+j4cJzs7lvgSzGGCrKNJuwVHYtsZQnBOxZLC3pg8uiyCfOj8vGeEDu4B9h7Cs2t5aSExi6yk6b
        fN+4wtzqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iY8nA-00033Q-I4; Fri, 22 Nov 2019 13:16:08 +0000
Date:   Fri, 22 Nov 2019 05:16:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] iomap: trace iomap_appply results
Message-ID: <20191122131608.GA5075@infradead.org>
References: <20191122014601.GQ6211@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122014601.GQ6211@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
