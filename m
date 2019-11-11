Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707D9C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 07:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A3F2075B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 07:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lrbtorrn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKH5q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 02:57:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfKKH5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 02:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=lrbtorrnQgQZ8z/U+JZbf4Y/Z
        z7NwLrEARh+PernGzzyWBNxpTEZ6ruJciTCqtxW6CdwALfbnMlOXD5bj18ioKuF+80vswnj09Oo78
        LICBsXNuvv7IpL+cTw5YePVGiAXValBXL+j8q6ScOfVNbowbJWujHwbARNtGIxy1zAAKJjZ9g5rEI
        aFXoTAEJNbyA/WxE++lRFyIp84IJla8jebvX7ORfh9FtAWNKcpTRw7F3wEgHDCK0EmSb2qPvs9qlZ
        kdKhKVWx942f01BrDhKP1XmHyKZ8AMQNpAlNWc6f4AA8UZZ/UBFQiV+RKgnERsP8npNB/9yGJr4w0
        epGATfRxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU4a2-0001F2-1j; Mon, 11 Nov 2019 07:57:46 +0000
Date:   Sun, 10 Nov 2019 23:57:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191111075746.GA4548@infradead.org>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
 <157343510150.1948946.270237649955385275.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157343510150.1948946.270237649955385275.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
