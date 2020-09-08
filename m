Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCEFC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317712137B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t2nS1uzk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgIHTzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730633AbgIHPhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:37:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C095C0A3BDE
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AMgLq1kYZyqxV9AEXO2bzlSBvFlrttNFS1FgelJYwd4=; b=t2nS1uzkl0bzvxMmgZT15jAbYK
        lCO29zPOChVVGK+6qCWlzyb0NcThMqsiouR6sJjflMNCdFkJDGeiPxwbGFQ0AUKBlXLXo70OlTVJS
        J+DmwsDu5ExB3Pb0VSh1Vp1OKrBw0ZS3Adt4OA4twU7c9Bgxu5Smf7ECUz7/i1/9C7/oY7CplGEJQ
        Jehqev00K306HXKr3jc7oCOQbkipAQPc809/PCAZf9SjdoylC9P7YQs5+Vf4iZUcf4XTSWh2oosvf
        /GFsr5r3wYMvPrFtam5aorcQv9LSXQhqpAxlhI6Nmywzr4zGux6VnQRPX0w/11/dNxVB4ZdTrmgcF
        Z2THFvWA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFezL-0002sr-A8; Tue, 08 Sep 2020 14:52:51 +0000
Date:   Tue, 8 Sep 2020 15:52:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs_repair: fix handling of data blocks colliding
 with existing metadata
Message-ID: <20200908145251.GJ6039@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950114896.567790.10646736292763230158.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950114896.567790.10646736292763230158.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prior to commit a406779bc8d8, any blocks in a data fork extent that
> collided with existing blocks would cause the entire data fork extent to
> be rejected.  Unfortunately, the patch to add data block sharing support
> suppressed checking for any collision, including metadata.  What we
> really wanted to do here during a check_dups==1 scan is to is check for
> specific collisions and without updating the block mapping data.
> 
> So, move the check_dups test after the for-switch construction.  This
> re-enables detecting collisions between data fork blocks and a
> previously scanned chunk of metadata, and improves the specificity of
> the error message that results.
> 
> This was found by fuzzing recs[2].free=zeroes in xfs/364, though this
> patch alone does not solve all the problems that scenario presents.
> 
> Fixes: a406779bc8d8 ("xfs_repair: handle multiple owners of data blocks")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
