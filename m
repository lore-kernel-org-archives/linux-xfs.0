Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41778C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Dec 2022 16:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiLWQSJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Dec 2022 11:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLWQSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2022 11:18:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9355EB5;
        Fri, 23 Dec 2022 08:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OLvFioeiYyXkZ4ICmV2p63aeyTPh1eBJBQIe3c5ybcA=; b=ftnG0NkOKpwRx7Ol2TXy1EAMOz
        u37hvZa2zINVVg2bV9yiIz/6anTQkmQ8MVhV8foLGSVyDHFi1OxBLjnTN7IeAqlmm7nrIo1GUnjpE
        Jk8OZajlRZGtQNg8zTNepdbPAMvsPgFNPayHhixlJZf+mTHpgPF4Iq7WtlTTC5VCWzDp4s7qSRSGw
        Z+kAxqQi6X0vIltkNbOgdfsxFdA5pRdaf3iWmYXySivfVKfv1CPfDB4/WqxI6EjaF6ElDBV1dCbcN
        WbUFpkdbw13yV7H6hMdQBe3VUmF7sONsdpx7KJQiBDbTb5C9rbGgG9AaOlL2pWqF2hyOZQ1zanq6y
        Bsj993LQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8kkJ-009tVz-5X; Fri, 23 Dec 2022 16:18:07 +0000
Date:   Fri, 23 Dec 2022 08:18:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 07/11] xfs: disable direct read path for fs-verity
 sealed files
Message-ID: <Y6XUv68yaKY9vBoO@infradead.org>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-8-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-8-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:31PM +0100, Andrey Albershteyn wrote:
> The direct path is not supported on verity files. Attempts to use direct
> I/O path on such files should fall back to buffered I/O path.

Just curious: why?  What prevents us from running the hash function
over the user pages in direct I/O?
