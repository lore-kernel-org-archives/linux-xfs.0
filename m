Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1843C2BC11
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBDC2177B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iMAYIuuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbgIHUEC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730401AbgIHPXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:23:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73878C09B04C
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9YyJ/Z/eiLKQqlLkhiRGiH7WKo48K+PVeGhiKDCptoI=; b=iMAYIuuvDRDQxDt9/oHRhQR/bc
        3jglcb2jJTVGBFyCUhkikLP5jDJZ/WJN9lI52aAQRqei58jdS1t9ylaLydnBizzss5wKSz7nR9Ood
        tl3OTIMaObwQlubJMwXF2pKwH4W9bhSstnMa6Jf6WZW9WfkpJmJI9fUQL+R50tKoDv4GC8zB1TElM
        XeQHgCpI2BTwJqrvibf+PhLN2kJ4PgjBVOalwe90Ne6A7f05DRZ7DpvvLC1cOEyaSrVD34IRB0wfn
        n8MO42xsCW26Sns6+n0IZ6ey9BdtxFkzqOb8O7vTZ/8AlnSpzlciCm0N6wYQO8lwHihIochatFeSw
        svuBKDgA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFeqJ-0002J8-Lr; Tue, 08 Sep 2020 14:43:54 +0000
Date:   Tue, 8 Sep 2020 15:43:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs_repair: don't crash on partially sparse inode
 clusters
Message-ID: <20200908144331.GF6039@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950112377.567790.5885407242137390700.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950112377.567790.5885407242137390700.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While running xfs/364 to fuzz the middle bit of recs[2].holemask, I
> observed a crash in xfs_repair stemming from the fact that each sparse
> bit accounts for 4 inodes, but inode cluster buffers can map to more
> than four inodes.
> 
> When the first inode in an inode cluster is marked sparse,
> process_inode_chunk won't try to load the inode cluster buffer.
> Unfortunately, if the holemask indicates that there are inodes present
> anywhere in the rest of the cluster buffer, repair will try to check the
> corresponding cluster buffer, even if we didn't load it.  This leads to
> a null pointer dereference, which crashes repair.
> 
> Avoid the null pointer dereference by marking the inode sparse and
> moving on to the next inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
