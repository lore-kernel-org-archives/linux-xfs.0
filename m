Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2329DC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E21208DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LWMyUkyP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgEIRJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:09:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5569BC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0e1xUuM9SgV56/izlPD5AL4HFZ6B6DAGBEil3KK6rbg=; b=LWMyUkyPxPbLP6Ku4BaUsDk52G
        05THAJVud8XXVDk7HpJcXYeaFEvtSvomgrZsZFH0/2+PAxERJB0B64kizdr+NKsrqJfD2hJHhsVlf
        Dm2UxgZA22OxuGsLDwwmPwTlIdXigvQB95vwKlfisxIgNzWSASjvDWiQa+sp4aMjitl5VuEm5FMsS
        X/UcCr3si5zDEGy48mf7AENzPvPnxNb2ijNIQmtKVjxS5eWdXKZL/XTwZy62IuH9mWS1LUKvUx610
        F29Wq8xjYsVo3ZdCqJHQuv+sqDyeA7ZJ7m7dXK8r6trpnPeGSPcyOIIHuMV6PHp8Lmt4B0gcz+7WX
        EVumDPIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSyi-0000xA-Lv; Sat, 09 May 2020 17:09:32 +0000
Date:   Sat, 9 May 2020 10:09:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs_repair: check for AG btree records that would
 wrap around
Message-ID: <20200509170932.GC12777@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904181121.982941.11919205494567354626.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904181121.982941.11919205494567354626.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:11AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> For AG btree types, make sure that each record's length is not so huge
> that integer wraparound would happen.
> 
> Found via xfs/358 fuzzing recs[1].blockcount = ones.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
