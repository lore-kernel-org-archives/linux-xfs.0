Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F4FC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F29620787
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lyD4x2+C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgEAH5b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 03:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgEAH5b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:57:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE65C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fmz/ZWdi/vZrv+W5hNGSnVCKTvnygms90KQrdcRTzLg=; b=lyD4x2+CZT9w2e9osoUR0oOW2o
        8hsec4zM9CStcD7mkq8QTSM9FMiY63v126ky3aUVIlfCH40H1esBZGgQqpZbaEgYt9R6dr5iER//S
        IUfIRNZVjb0tdjW/tga/m1RMfdzqTbO1liqCF92TUxgWB6+pG0Z6lNF6N9Gr3Orc2hLOb9/d9YxFu
        XmLr+GkR2d4YdEi6Lp3PadRbriMLUFd4m1Aren6h3vkq32kNRDpnIRnjnkD1/6pOODlsOb6bXIgt8
        XmABWaF8CpD1anpBEv5XjNVYLt1j33brKbjDcAg9hGsE8WdfPZuMz3RESRlcN5Gn/PTplPxJ/H4Jz
        WGw9SDbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQY7-0001F2-45; Fri, 01 May 2020 07:57:31 +0000
Date:   Fri, 1 May 2020 00:57:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 12/17] xfs: drop unused shutdown parameter from
 xfs_trans_ail_remove()
Message-ID: <20200501075731.GG29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-13-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:48PM -0400, Brian Foster wrote:
> The shutdown parameter of xfs_trans_ail_remove() is no longer used.
> The remaining callers use it for items that legitimately might not
> be in the AIL or from contexts where AIL state has already been
> checked. Remove the unnecessary parameter and fix up the callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
