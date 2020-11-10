Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD5EC388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA5220797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kH3eAEk6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJShA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKJSg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:36:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F52C0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bRgJR/4dyZISyN/xr/S7rQqhKhgCCwscPNl+HQ9nhUM=; b=kH3eAEk6P6cvW0S9wrA1Gkr9LZ
        +j+4hWmyawLfMnj1ThpTP+CmyTU09Eg/4e1pOaituVKZ8CTh4kOmsDxHghuPUV62G1oZiss1Xmq8F
        shIiOsR5L6l0yEHN/DmZaJozoDCkjtdPXdoXllLapYg1xPFASdgtI57BAsSvMV6MD0SHKllUtGWC0
        1GdBw1S6XG+fKS4kKjssR6Ftj0RM1z4WHMGIIwtHgjMPoWw/lvkt9iK00qqEMH8xPhvGdTkChEuwy
        nPx9Q/vUSpBskH0Kpo+ttqr1EfPO/YZphC5MZJ88TSI3fI0DELSiBDATpBNdRbbKLVi+kElt6OZhG
        P1D3FyxA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYVh-0002f9-6N; Tue, 10 Nov 2020 18:36:53 +0000
Date:   Tue, 10 Nov 2020 18:36:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] mkfs: clarify valid "inherit" option values
Message-ID: <20201110183653.GF9418@infradead.org>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
 <160503139674.1201232.14186191797913715969.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160503139674.1201232.14186191797913715969.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 10:03:16AM -0800, Darrick J. Wong wrote:
> From: Eric Sandeen <sandeen@sandeen.net>
> 
> Clarify which values are valid for the various *inherit= mkfs
> options.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> [darrick: fix a few nits]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
