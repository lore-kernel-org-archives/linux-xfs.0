Return-Path: <SRS0=f2ny=WU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7FBC3A59E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 23:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC4B22CE3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 23:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MWD6qzI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfHXXFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Aug 2019 19:05:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfHXXFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Aug 2019 19:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jwGipl8iMkWmLl4rTBP3gvfoFQqWBYKomKEgoE2XsyE=; b=MWD6qzI8hKuVR3IBaPV+K96tT
        w0csx3O4bX54VeOG6sJxNBFs84dTsvIYRJAwGsKfyfBAylx5cR7thtxzKNwHykSjQrfcTP2SZAqOw
        2/kkUhSaL+8a404ZXp93pYkOatSuKOlgSyUD0XdhTaDB9SnchNl27/exu57igy56x+beMxKnUH9AO
        AlloOCoBtSagEabkmKdSm7L91l0Z0H6uRW8VQuUdmsNcP88W7mNlbMRKNKPcvKxLoom8YnlpZMwvD
        bZF3x5k7n5pVw9I8gRovlqoR5igaJscU+ypdBvThC7UiaPNwNhkCYy7ZQNhE/M7VUov9Q/+oUjsdh
        +eQDBzwvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i1f6U-0002ei-F2; Sat, 24 Aug 2019 23:05:50 +0000
Date:   Sat, 24 Aug 2019 16:05:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
Message-ID: <20190824230550.GA5494@infradead.org>
References: <20190823035528.GH1037422@magnolia>
 <20190823035734.GH1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823035734.GH1037350@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/tests/generic/group b/tests/generic/group
> index e998d1d5..bb93bccc 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -572,3 +572,4 @@
>  716 dangerous_norepair
>  717 auto quick rw swap
>  718 auto quick rw swap
> +719 dangerous

+ quota + metadata?  

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

and after a while we should add it to auto.  I'm not even sure if we
shouldn't do that ASAP.  It's not that dangerous and we should test
for this everywhere..
