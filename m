Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B0EC38BF9
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B03A20732
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c3eHQyWl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgBXWqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:46:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49994 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbgBXWqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aP+A5/8iyURIH4NmkbHAnWqPkYRmBTJrcY0zX81854I=; b=c3eHQyWl3Pk+P/joWoLakamcwW
        qjry/sCPlPGBo6YEeiJL+v4SV0c/KkaIvyq0xjjFe2LVIaioHoaTjZcw8dv4YD03SXMm2Zcg6OltX
        yqdCptathLFtUkO30Vi5OPs4zDEsmIKz1CoVJj/ECitoR/RfxA4bwRY52uINrktjB5jC2Mqsgwyqj
        egnmGpuInedWPUTrSBsRyO8PJnxRXo2+LwOar/NVh80b8QTimZ+erhCFjTrH9o4IPqVaQRG1YQ6Xe
        HXCfUK1XHLz/5c8PAF2O4lQyXd+RxLH0JXZM5n97LDmLrb+gKPX7S1A0o7V8JtrZgznFpcmNv1VkG
        lphhYzNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6MUy-0002gc-FN; Mon, 24 Feb 2020 22:46:48 +0000
Date:   Mon, 24 Feb 2020 14:46:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200224224648.GB25075@infradead.org>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
 <20200224220256.GA3446@infradead.org>
 <75eb13f6-8f96-a07d-f6ee-c648f8a3b38e@sandeen.net>
 <20200224223034.GA14361@infradead.org>
 <61713cad-ea6c-6a0c-79eb-cf01105e1222@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61713cad-ea6c-6a0c-79eb-cf01105e1222@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:35:08PM -0800, Eric Sandeen wrote:
> > The "harmless" gcc complaint is that the kernel build errors out as
> > soon as XFS is enabled on arm OABI.  Which is a good thing, as the
> > file system would not be interoperable with other architectures if it
> > didn't.
> 
> Not just on latest GCC?

AFAIK all versions of gcc, as that is the intent of BUILD_BUG_ON.
