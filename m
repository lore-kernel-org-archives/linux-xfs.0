Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14B1C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E622065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="axzAFI8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgGOSoK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:44:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FE8C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UAP6RPk09FKTR3vmabvir7Mv4V3K23UhBH6Rur2wyAo=; b=axzAFI8xNi6QalbdHo+Q7tOPte
        Wyl9RcS8k048+3bMK3GzNxRtq9VUquoeMt9BFy/PoRPpm1PEJ8oFi+3Rw8La0l05HlhpN7M3VhhR0
        GN4xR8rCEgI/Kq5yjxYau+PcKmXnOZ+3d4IWOyTu35jTySbZWW2XgnbYv2/zNbrSfvrOygILDHdDN
        2olapKNrghkFiJXm8p65eFc8X/zMrMdRVVieG51Kqh99KFRtgxG5DkzedV3WoLDNKiKCJE1wxMLra
        zFQ6lzOWVFOqhLbr1I5rTq7S1nPZ8/LR7tD6QPP3pXU8MkrJf877c0SmMlY9f5rAabRAonkVwLH+3
        Ck/CbXXg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmO0-0006GG-B9; Wed, 15 Jul 2020 18:44:08 +0000
Date:   Wed, 15 Jul 2020 19:44:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] repair: use fs root ino for dummy parent value
 instead of zero
Message-ID: <20200715184408.GC23618@infradead.org>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:35AM -0400, Brian Foster wrote:
> If a directory inode has an invalid parent ino on disk, repair
> replaces the invalid value with a dummy value of zero in the buffer
> and NULLFSINO in the in-core parent tracking. The zero value serves
> no functional purpose as it is still an invalid value and the parent
> must be repaired by phase 6 based on the in-core state before the
> buffer can be written out.  Instead, use the root fs inode number as
> a catch all for invalid parent values so phase 6 doesn't have to
> create custom verifier infrastructure just to work around this
> behavior.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
