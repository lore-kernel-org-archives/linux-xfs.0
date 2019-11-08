Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D732DFA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C1B21882
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dy6tgSLY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfKHFtp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:49:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43622 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfKHFtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 00:49:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lxofdiN8VU70+462RB2Oce55SU0EocOGsEJ31XrpRhs=; b=Dy6tgSLYgSfJmUE9/4rM4bgB5
        +PMzWa6k/+uGR+2osIxCfssFsQvNLVqZ5IdZJ6XEM0QMMqdJwRI6Ffo2GcwQ2PCcl8hos/t8g03xg
        i1Xh3yONiRUoIqcZofknb2za+OQDVB6zrEk3m10gJ8rciQ9OG4ojkzPePY3PXxisMcIjnYwGS33q1
        gzxqsebNnkJl6mo9YUFSV3i9IFVlIdo2bO3KXx5VcwLi7YkX3IB2g5i9fAVd40q2N06+Be9F9K2ya
        cvq+MbpWNQo9YfWP2hBUcGycxedohmOAEqV1/Z0dnsKPo/6I/6stH6B6r6rAyefJ7rJv5xTsuOEAy
        ykPzAyvZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSx9R-0006i0-Jq; Fri, 08 Nov 2019 05:49:41 +0000
Date:   Thu, 7 Nov 2019 21:49:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ian Kent <raven@themaw.net>, linux-xfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: remove a stray tab in xfs_remount_rw()
Message-ID: <20191108054941.GA25221@infradead.org>
References: <20191108051121.GA26279@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108051121.GA26279@mwanda>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 08:11:22AM +0300, Dan Carpenter wrote:
> The extra tab makes the code slightly confusing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
