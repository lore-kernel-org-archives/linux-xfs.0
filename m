Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC3AC33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1CC2075B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="btnJuxQf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgAPJZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 04:25:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAPJZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qqde28v6Yl8tgqmJFo8axzaCudNy6IvA2+Xi7kUi6X8=; b=btnJuxQfL4dRTSdWx/fvGouxP
        XINBDelzV1M9VuzQann9edLjRRmgmp63QpMbcqozfxMtH/BVK02NmrGYO1w65Pb99cF6HM81Wx3cN
        aLQO2ev3e6NjgvH6KbmYBJKYBivvnn77ykcNhzAXU+y/0xdMHK6FtkUrZxfdb0S3q4zgoZ6txPDG0
        xCmYEfCwAMFU1Gqg7rWbwuBquxfWFf3LblAhPX6EBxfyrGRmG9+9Y2MTNAqLLaiS1Z8Dc52M7j/f4
        XbAwbgMHWMP2iwmNssfuTa+VtS0H2tcs4JCRiQSOLqHQciE3MZiv8v9dzJxGxdoPkeVO6slL/0IfF
        d0XFIUeUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1PU-0007cr-DU; Thu, 16 Jan 2020 09:25:52 +0000
Date:   Thu, 16 Jan 2020 01:25:52 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs/020: call _notrun if we can't create a 60t
 sparse image
Message-ID: <20200116092552.GG21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915147960.2374854.2067220014390694914.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915147960.2374854.2067220014390694914.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we can't create the 60T sparse image for testing repair on a large fs
> (such as when running on 32-bit), don't bother running the rest of the
> test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
