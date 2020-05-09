Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26489C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32A821775
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ng2mrNjW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEIRPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:15:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1A8C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XuymAeyEZJ5poqPdanMUJ9GhWwVlZseUgkIMf55nubI=; b=Ng2mrNjWhcyVr9GYlN0RpuCQ3B
        uz+CHoV8fdpnABfcFGprJWGQW68DMNYQPiEtLAT4IPdjFGrpDExAjm1nsyEALv5L3U3FXJTn+zune
        AZEa3a+OTwhYbDm4CIQY+PFEtBhZbZwnzttbReiUdyjoD1R4w3ty1/e3nSUqv9hayTnP+KES4bpIe
        AmRyb7YniPtyBHU4JxwXUO34sA1nByiBMKWvmVlPPrdqkFTXMVMtObgqRK2CwPr/iYMIKMdKwuiwA
        w5pwQLYzqf9UohpyB312bCwBqIVECZnbzV8Dw2y1lTyKAHFEW246O1aWuLWpbpIf4CH56vHh2mVVO
        OlUWRHIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXT4D-0006Sc-Jv; Sat, 09 May 2020 17:15:13 +0000
Date:   Sat, 9 May 2020 10:15:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/16] xfs_repair: complain about bad interior btree
 pointers
Message-ID: <20200509171513.GB15381@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904184818.982941.1861210055263598397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904184818.982941.1861210055263598397.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Actually complain about garbage btree node pointers, don't just silently
> ignore them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
