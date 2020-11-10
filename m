Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23648C56201
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C677D20809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jD1Q1hcg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKJShs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKJShs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:37:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24933C0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LMWbZG/eTaFBxzInG+llXt/BAVkrhwKy4mC9LcrhjxY=; b=jD1Q1hcg1OaZx696TsnGRJYHEy
        qkSwOFavnRhRl2ilzAzKXCHwiKH6Dh4lmgSMblIkV89qA9/cQ6hHQWVdrYjG3OQNrijLXbYFr0bcW
        fOR1cCHVv/+C6GDUgiqvxcpIA7EmZjvbI0vc0OIBKnhcZpwt4Ryl+sA5h43K9udDD8t4l6XUGy7kR
        BCWMC/MBNUCZ3X1xzdTWBfcoMdT4M3uQEKUsHB94SzxBJ9LLfPmSORr8rgcnK949YQvLe9VVL5DuB
        NZXun+gsR35heagXbHCusqWTN6Jn5aI4ghU9mFBwMWCAo3oYtpejXxXsmQXtuscCOerhswLgslBez
        ga1296Gg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYWX-0002i6-AN; Tue, 10 Nov 2020 18:37:45 +0000
Date:   Tue, 10 Nov 2020 18:37:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] libxfs-apply: don't add duplicate headers
Message-ID: <20201110183745.GI9418@infradead.org>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
 <160503144025.1201232.11112616423278752638.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160503144025.1201232.11112616423278752638.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 10:04:00AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're backporting patches from libxfs, don't add a S-o-b header if
> there's already one in the patch being ported.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
