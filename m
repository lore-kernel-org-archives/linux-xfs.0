Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC38C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E9520746
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SUkbOUw7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIROq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIROq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:14:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23EBC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S2mUfY+ZgJ7N9f4HcGfnBlbiN6Uvb5BtBiHN/NkoahY=; b=SUkbOUw7/TVEu3YYvmyjijkhiE
        8fYc4BRsKrA8D8PfFLUQB7gCM3xX6FeAsWL1r6FUpp4/T4Z3EobzCS1Q3EBwx/F2o5BXBDaNor2t7
        nD5IOXXEzuA5QtHfI1kASEOVa4M5k5bLTjyL76gTEXUS4X4nfBVQDXn10o8HaJ1qmECEZP+SnzubN
        gPp70bCaMFyoMrJANl47Sc+dHla7kzpKCwN9mQ5C867kbtl1kIQAQPKFxxGbjqaeKTgTU0yP388a7
        TIjfYOGLFbqM8Fih5otIVohrlL4rX2oRfc68ng7rhTDgJz8KLX12FbUkACGeKeWTymCvfcHMCHKmb
        vEddYnhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXT3l-0004Aw-35; Sat, 09 May 2020 17:14:45 +0000
Date:   Sat, 9 May 2020 10:14:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/16] xfs_repair: tag inobt vs finobt errors properly
Message-ID: <20200509171445.GA15381@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904184198.982941.18130519450590388566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904184198.982941.18130519450590388566.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Amend the generic inode btree block scanner function to tag correctly
> which tree it's complaining about.  Previously, dubious finobt headers
> would be attributed to the "inode btree", which is at best ambiguous
> and misleading at worst.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
