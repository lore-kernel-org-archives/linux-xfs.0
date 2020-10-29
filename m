Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F43C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5520E20790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KK4bnRV9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgJ2Jri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgJ2Jri (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:47:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFD8C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EwCXYr1X1I4jEDCqQk68rJUV1NJkeE/YuU9hl8xD654=; b=KK4bnRV9vrKVdp4b8sptySjQzw
        abiyL3CiupKA8OncqZuncDwxWXerDqSXLFG1dj4Ke46gZRmBWEAJK2tu/Ty6kC31ZCRBmDA57WLzx
        hws5bXei3aqXpZw4iOvpV/zgN22STbkt2vR8Tv9ve2dfgrdOwXdMKTFBUtAd+g1No35P7ioaGgdXR
        6AG45iwMFC11+ejqSRZ8mpYTJE4ILNSP+AuLlHZjGPStJ7dNvp0FZmWhJIzCJ68WF1HiX7PpJZXMk
        oXjFi156RJgXBiN6b1qwniQTeSUFv9JOm94qOfPEyzmQyXrbxxVq3SdQiHP2PQx+Cn2HGhJNskeMz
        2+xvrNEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4Wr-0001Xz-Oj; Thu, 29 Oct 2020 09:47:33 +0000
Date:   Thu, 29 Oct 2020 09:47:33 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/26] xfs_db: refactor timestamp printing
Message-ID: <20201029094733.GJ2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375528453.881414.12498523896617282388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375528453.881414.12498523896617282388.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:34:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce type-specific printing functions to xfs_db to print an
> xfs_timestamp instead of open-coding the timestamp decoding.  This is
> needed to stay ahead of changes that we're going to make to
> xfs_timestamp_t in the following patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
