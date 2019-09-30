Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CC4C4360C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C85D9218DE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 07:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OtF2/xUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfI3Hw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:52:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI3Hw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=OtF2/xUtLOGGH/hlL2qesa3xK
        e88MmB7gFlztEwoMiXIYpm/9oTjt/fiyJp2F9TgoiTHHcBxyT8Qje5uTh23mHkjn+czh12whHXGzE
        c1dGd29iMG/ViWwK4RK1YTF3EjTqyLxrXv52CWkPCsValCFS+sJxtnYoRtn8GRCf1g6mF4Ojv4SjL
        Xst/Ge3voVnoqT6xx3FTKX9OnpNASp1RG9u2XpvuWySzwbKC8G1gqntgoeJq3d5ZqXzagDcAmBKaQ
        jATqHi57nQkkUN8FcCWVVBc7bGL/Sudq5qBeJo0rrsbjXp+IpO/s+eKBYlNDd+M5jLi7p/1bZa9JI
        fcwWtUNpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqUJ-0002KS-Fv; Mon, 30 Sep 2019 07:52:55 +0000
Date:   Mon, 30 Sep 2019 00:52:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] libfrog: convert ptvar.c functions to negative error
 codes
Message-ID: <20190930075255.GG27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944763225.302827.11883869939231821231.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944763225.302827.11883869939231821231.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
