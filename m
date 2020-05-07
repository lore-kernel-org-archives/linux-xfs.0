Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026C6C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 06:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F6A20B1F
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 06:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ewvehAXf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgEGGG5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 02:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgEGGG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 02:06:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1E1C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4RxxdXuIBeN6ARSq0NbSSxvUq0kodixIoCl+WMxV20c=; b=ewvehAXf6d6r0KaXpiNs6J9hBr
        280y0jBa29QkUjbc/SChFnH0a1In9uFWx8+8D9jg6H14Xv0gb24RXqhYTgeeDV3P0fBk7T8GMS+ac
        8zS/aq16vZHPOd7S7+TPWE25rtftNRz9wVLvutuSThiXz6DKWTQu5OTbA5TRo4hI4ZA2Rju+oj0tT
        gHV8hM0dNpbd8iG3tUrH6vHQbk44xk5QhR0R6Lkkcmd0gga7zBqsrl3EU5bO2SQn9EXQ0Uf+1KrZM
        IYWUK8UNqh0IbGbfE7I9OJ7oV0TaktP9xI20LZEyN+p3viwvhLMzQ+tg49cPBlcoG/FUNgy936K8E
        mYvgfc0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWZgO-0005iP-TU; Thu, 07 May 2020 06:06:56 +0000
Date:   Wed, 6 May 2020 23:06:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/25] xfs: refactor adding recovered intent items to the
 log
Message-ID: <20200507060656.GA5335@infradead.org>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
 <158881342959.189971.5621808877331045450.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158881342959.189971.5621808877331045450.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 06:03:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During recovery, every intent that we recover from the log has to be
> added to the AIL.  Replace the open-coded addition with a helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
