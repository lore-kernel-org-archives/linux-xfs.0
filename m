Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A60C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E246524656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WnhPnAv2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgBUQ2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:28:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44158 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgBUQ2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 11:28:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gUz9lelxx35kyccbaocYmOCzuWlPiuq8uqc4ltWxLVE=; b=WnhPnAv29jsnGqVh82W0bdjyhd
        h1Hys1gdfkQB/JRcbAGgs3m9aFlicF2RUfo4lw7GR6JubQolPq9GEIZjHhMt+iIvhG7Fal6IcQIqz
        AWTzB4lo5Zcz8GXFGcEpNEiFzW8dIQKrxnhYnPieikePwpym9ItVRpFJ50OCIRwGBQKsY1bMH4Ra6
        YBtny7xm9j7aQVoHnjToZXsQyzSZqKerkX8wiWkvE3P+Wv3IuxZgdQEXFUpt29oizsgQj+5pnLsPl
        yUDRwS5SSmmmUvM/fscng+hkK0dZ1i0ValjT75UFbhDSrljh4XSFmWAQTn4XUOJTINh9/52eDX4NV
        zgb0HbGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5BAL-0003r5-2p; Fri, 21 Feb 2020 16:28:37 +0000
Date:   Fri, 21 Feb 2020 08:28:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] libxfs: make libxfs_buf_read_map return an error
 code
Message-ID: <20200221162837.GA12385@infradead.org>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216310149.603628.17465705830434897306.stgit@magnolia>
 <20200221150339.GU15358@infradead.org>
 <20200221161530.GX9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221161530.GX9506@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 08:15:30AM -0800, Darrick J. Wong wrote:
> > I understand the part about skipping the verifiers.  But how does ignoring
> > EIO in this case fir the scheme?
> 
> "Salvage" mode means that the caller wants an xfs_buf even if the
> contents are invalid or missing due to EIO.  This is useful for db and
> repair because we can fill the buffer with fixed or new metadata and
> write it back to disk.

I thought the aim was to look at the buffer for the content even if
said content fails the verifiers, for which it makes sense to me.

> On a practical level this means I don't have to amend all callsites:
> 
> 	err = libxfs_buf_read(...LIBXFS_READBUF_SALVAGE..., &bp);
> 	if (err == -EIO)
> 		err = libxfs_buf_get(..., &bp);
> 	if (err)
> 		goto barf;
> 
> ...since EIO doesn't seem that much more special than EFSCORRUPTED.

I actually prefer that, as it really documents what is going on.  That
being said if reading the block fails with EIO chances are writing will
fail as well..
