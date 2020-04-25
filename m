Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A76AC54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 579E220704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rd59NJZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDYSUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYSUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:20:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF58C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iQHfYo8xrvxJcAo91O5cQES0vHNX9E8i/W7NMNydCRo=; b=rd59NJZMrLCTOUbXRRcHYBeo4e
        BkRhfR+YuCuQaUUB2zlfoIzfcYoCSS4ijLs6LquQA/QztiwbAcvDDtnjcowERkjYC987C7B3mTWk6
        llYQUFeiYXx/krqpiRG/HdvuLGZPcLgMdZodut/Chr7m71T8EQ7WvquIBn4aHDohvtEOCs9SC/pcB
        7v08EdW/Un2N8BtRIWkvTR1En1C/1cPk2ozlauiFdM2irhG4qWFBIU9vFtqSzpTQBCjLIdzjEQfjH
        QeisKAXqgIPmzHnbDlanNgqJGP3z3yhAeSNCa7KMbW+fQXRlU+IEd8EzovGr1k1sjE6F48q+90bKt
        9JmIYnWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPPp-0000tF-Kv; Sat, 25 Apr 2020 18:20:37 +0000
Date:   Sat, 25 Apr 2020 11:20:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/19] xfs: refactor log recovery item dispatch for pass1
 commit functions
Message-ID: <20200425182037.GC16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752118861.2140829.15933917079805307080.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752118861.2140829.15933917079805307080.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;

Please switch to the struct types instead of typedefs for all moved
code.
