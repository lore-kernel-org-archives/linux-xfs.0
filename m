Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA83C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 773E32071E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eVcIPJsv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgAYXSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:18:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXSQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wKt8IL0L/LT22g/5d0OSh4reKSQ1ZHqzNuKgiB45UK0=; b=eVcIPJsvr8eFcqZsU2x2O2vhI
        vutyZyWcn0MeQ7yxh7SRqZZW+sncnhX64UrgUdt/QW/27bv0nSBfqjYjVU6RpLROOi5iL2dRhPVnf
        5o2NpxZC3e7N09x+OxT99frK/jhYgd1L9ZbM38xbbxLbLX5RhiwPqwF7OoUFUDIUkQ0SoIxZZ285v
        ylWbaW3qAD46kTUNhelEyzfP/tLGNZMRN6PeJAJEywYyjIV8SwNEojaBi6K1oZLShsRbrX3nVwjlA
        GLyK6DBDdm4xzSCi1R57Tj42UjJHjOHLwAyY/4e8kdhYz0Ur6VOROoQgSDVQnN9Hp45Wma1qDGYMt
        6+tHBZh+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUgx-0006ld-Dr; Sat, 25 Jan 2020 23:18:15 +0000
Date:   Sat, 25 Jan 2020 15:18:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs_io: fix copy_file_range length argument overflow
Message-ID: <20200125231815.GJ15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982503121.2765410.8361260238180400802.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982503121.2765410.8361260238180400802.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 04:17:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't let the length argument overflow size_t.  This is mostly a problem
> on 32-bit platforms.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
