Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DE5C43461
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E1C20757
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GgMDxlG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbgIHQib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732078AbgIHQhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 12:37:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F26C0A3BE1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Rt7D9/lIZF5q1v2Cnuaqaasg5Z/h71JCrcF4To1rvM0=; b=GgMDxlG4knF97MRykd8qaCyd5N
        9ai8tSNTSyqOaVAa60eOLieT+4Ofy2Izbiv/dxklwP64/2qc7tRseBWG0B/bH14yFT+rci8Y1P0gb
        f8LnNDvZgfNHwd2BTY5TB9Lh+EdURDlqQTA3obQnzJuztwkNX1upRoogOYqh6QkhykTxLaNtgEkef
        rkWA0b6hwGQb0aClpFd4+F3xXVVbogvBnicl8fXKLW+2Mc4wH8Qidx43LgSesQ9pU+mJFZWQJ97cX
        YZxsu7fvCEIn9V+i4NOHSu0d2L+MnXjVT7R9sv2p0PASssD+gfwnhiVpVMHxTgRrqz/Y+WUATvzqE
        i16aueDg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf0i-0002wq-PL; Tue, 08 Sep 2020 14:54:16 +0000
Date:   Tue, 8 Sep 2020 15:54:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_repair: use libxfs_verify_rtbno to verify rt
 extents
Message-ID: <20200908145416.GK6039@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950116137.567790.6513237616093378971.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950116137.567790.6513237616093378971.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:41AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the existing realtime block validation function to check the first
> and last block of an extent in a realtime file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
