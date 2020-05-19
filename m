Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E6EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 07:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C63D2070A
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 07:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hPkiMDjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgESHNu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 03:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgESHNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 03:13:49 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19F6C061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 00:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tt2COFtePsI1nfCmnxUxjOsTbN/xOz9LLWXx8BqM6NA=; b=hPkiMDjCG9QjpLbmrqG3wrZjdt
        wjk2e5WhgJa6fx9dt82A2M/1U8iGLaePEFEMkIHyAAEVCuCUwsxk0+zBfxCqiYg7/K6+YoRXLRG/8
        0QhSdM1uBQ9xewweCPTkpuiIsdY1sAPlgKIEaKxUp5Y4OJ52NgZE9HI4wvRGDx8gjrYEWtQfhM0wl
        3AOvM4jUytsQtG/zxN1/iyJZStiL9ovy21VSfBtAzLDXyeoz3ga+Ustpj3jQ+L/mIZNb7xMLw6wdv
        0TfZyNIOcLlZFhmAAJKj6N6Di09hOUip+BLvey5rdWVOyJdX2Jpeac8qdPRvuHA8XULLA1SohRnV3
        hRfasKgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jawRS-000844-Bq; Tue, 19 May 2020 07:13:34 +0000
Date:   Tue, 19 May 2020 00:13:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: don't fail unwritten extent conversion on
 writeback due to edquot
Message-ID: <20200519071334.GA6323@infradead.org>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984935767.619853.515097571114256885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984935767.619853.515097571114256885.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:49:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During writeback, it's possible for the quota block reservation in
> xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
> limit.  This causes writeback errors for data that was already written
> to disk, when it's not even guaranteed that the bmbt will expand to
> exceed the quota limit.  Irritatingly, this condition is reported to
> userspace as EIO by fsync, which is confusing.
> 
> We wrote the data, so allow the reservation.  That might put us slightly
> above the hard limit, but it's better than losing data after a write.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
