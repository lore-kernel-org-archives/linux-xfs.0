Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753E6C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5454920857
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pBVOOSse"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgEARuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729697AbgEARuQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:50:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673A2C061A0C
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 10:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zE1l4+w/c4K4zY7qPz/LPCGZ9iDcdRqqKvNknvkpa7U=; b=pBVOOSseNshou8NxV1iUAotGTQ
        wkcCxxIK0dO5vZcj5xsLPOD5HWMGV1dSdkAxz7RTF33GZZUq/6sxb8rNY+UpJkL3l0ufFsKbp4xXa
        d9P9foDpXmB5NgXuc+SFrGuFqdjkPndxhRUpRExKs8yCTvSRc1+2Hg7SNMypAO5Hc5n/CzAjzfrsU
        cbWYH/o8bYH04MSWtK6rdBG2dgdIw62d7mXt9SkXZ2XPGPUMIM7joAupODOKvvBTjRYHe+AopyXcH
        plJhh2ZVJDUbHPrDdUYcTyQ5xbAYu5GvCDweOMfrVg6WygfEBqZ2W5Bo95/bZRF0XKpe6zV5M9XGF
        RacJjFBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUZnh-0000Ay-7i; Fri, 01 May 2020 17:50:13 +0000
Date:   Fri, 1 May 2020 10:50:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] xfs: simplify inode flush error handling
Message-ID: <20200501175013.GA23470@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-4-bfoster@redhat.com>
 <20200430183703.GD6742@magnolia>
 <20200501091730.GA20187@infradead.org>
 <20200501101721.GA625@infradead.org>
 <20200501174305.GW6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501174305.GW6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:43:05AM -0700, Darrick J. Wong wrote:
> On Fri, May 01, 2020 at 03:17:21AM -0700, Christoph Hellwig wrote:
> > Oh, and forgot one thing - can we remove the weird _fn postfixes in
> > the recovery method names?
> 
> Assuming you meant this in context of my log recovery refactoring
> series, yes.

Yes, sorry.
