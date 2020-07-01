Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0630C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A985820775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MCwpFaOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgGAIxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728574AbgGAIxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:53:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CDFC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LDngsTjRd0GrhAA21P+Q7I8/Xjoed85iZD8fNGj1fEI=; b=MCwpFaOxDKf4CH8GjAfDHdDFAa
        ypgGXz5tIH53oGUwliCjJ9TtM7MYmxDcJ1YJdFfCCkk17H5UDX6UiG8nJPrNj1iVwr1TanNYydGIC
        znYce60kEM/92WggabW51I/odu6uGsl6N71WLIixnKGI6NtZzlp4P63m8kdkIzxc9rA1fQzzh/y2e
        oeWZuG13YAx2mv4SbIHkstge7QndzgogP/+6UgiTAqs0AW/MyBAzpFY0IGaxE0aov0+r7YbDZxp1z
        Q05+rqQ1BnSvNvCX3lDG5LU8TLr1NBmdftSpqxCfx7PVM2VVo+sPU/oKMYfqy+aotuqF/UGI6qt/B
        a316wJSg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYUj-0007lv-Et; Wed, 01 Jul 2020 08:53:29 +0000
Date:   Wed, 1 Jul 2020 09:53:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] xfs: refactor default quota limits by resource
Message-ID: <20200701085329.GL25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178739.2864738.11605071453935920102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353178739.2864738.11605071453935920102.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've split up the dquot resource fields into separate structs,
> do the same for the default limits to enable further refactoring.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
