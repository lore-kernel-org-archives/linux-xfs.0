Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F8FC432BE
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 15:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33CC260F11
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 15:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhHIPIk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 11:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbhHIPIj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 11:08:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C27C0613D3;
        Mon,  9 Aug 2021 08:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lVisPR5KYrIvMXDw9TO9BYr5cUWzTK5uEBjREsWaDZw=; b=FZAC+JOHKOolQ0tQy9niwPLdJY
        ZPBp2OAOsqp/iUYEibb87Zogf2D10l8lnVlSq/lwCZAwZi/mphoKiVWRGKVoKhIKlq3bfSu568mFa
        moyOiJGlg0B/Ha9fNfYWhsdXSfoUKvWXD02eLBsgHv3pGg2BMwWw91GpvmeLmifT5JzzpRpw5iKk6
        ZLuDMXg42FiE4YsZOcsMPDLHQkTWSSXFNwSAN4x0XxnROurFGseOV1SX48PHp0m1dUS9b4XG3jpNa
        Z7KcNSFFGkqitSX3e9Ik35/qWyXPKLhtRkJhSbUw3MKzWiy7t5tKei8p7Q+irVo5IbFWEMNux+L/0
        NAW9/boQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mD6sG-00B6dW-2h; Mon, 09 Aug 2021 15:07:43 +0000
Date:   Mon, 9 Aug 2021 16:07:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ojeda@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        arnd@arndb.de
Subject: Re: [PATCH 3/5] xfs: automatic resource cleanup of for_each_perag*
Message-ID: <YRFEtK1CNr0Q+4nz@infradead.org>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
 <162814685996.2777088.11268635137040103857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162814685996.2777088.11268635137040103857.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +# Required for for_each_perag*
> +ccflags-y += -std=gnu99

I don't think it is up to an individual subsystem to pick a specific C
dialect.

I think the most important reason why the kernel sticks with gnu89 is
to avoid the misfeature of variable declarations in the middle of
blocks, and this change would lose it.

> +	xfs_agnumber_t		last_agno = 0;
>  	int			saved_error = 0;
>  	int			error = 0;
>  	LIST_HEAD		(buffer_list);
>  
>  	/* update secondary superblocks. */
> -	for_each_perag_from(mp, agno, pag) {
> +	for_each_perag_from(mp, iter, 1) {
>  		struct xfs_buf		*bp;
>  
> +		last_agno = iter.pag->pag_agno;

This is a really horrible API as it magically injects a local variable
in a macro.  It also leads to worse code generation and a small but
noticable increase in .text sie:

hch@brick:~/work/xfs$ size xfs.o.*
   text	   data	    bss	    dec	    hex	filename
1521421	 301161	   1880	1824462	 1bd6ce	xfs.o.old
1521516	 301161	   1880	1824557	 1bd72d	xfs.o.new
