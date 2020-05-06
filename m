Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9FEC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A6920B1F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K9cJh6/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgEFPfT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgEFPfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:35:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20FDC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fewU+hFnsHKM3KBNzyDjghOZ7GoXLJWOW4zBNIEgd6E=; b=K9cJh6/OY0UgCd5IstNoXiLOnz
        JU4IgZ+VONdLceqt8dixdAMEPDc9toEIjVwF0E1Jb/NO0snYM6CTijn9V34RM/Jd6kXE4aTileHdt
        qWiSwVgeTJ+xeF/KbPr+klzM5FF70gNeXkp8H6I4/EHTJD9ZNmMxsYOYmMdWVuOU9kBBvGbah6ATZ
        iWV8tqxGDaq3ILOrzoj8T3CnpEQiJIZgchVmqCJpn/L63pTg6QMgbeI6vXL5Z33Bm8fr6OlnmA5JR
        1II1yK5Yh82I4FQQVvzRd6Zgq3DLrqIawaRmSEoN8r3ExvQ1wIe0wuuyKRUgBQzdXzX2Jj/0zkDty
        p1aaWSJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWM4s-0001WJ-Jl; Wed, 06 May 2020 15:35:18 +0000
Date:   Wed, 6 May 2020 08:35:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/28] xfs: hoist setting of XFS_LI_RECOVERED to caller
Message-ID: <20200506153518.GB27850@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864119233.182683.339682087935092440.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864119233.182683.339682087935092440.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:13:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The only purpose of XFS_LI_RECOVERED is to prevent log recovery from
> trying to replay recovered intents more than once.  Therefore, we can
> move the bit setting up to the ->iop_recover caller.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
