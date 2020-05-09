Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A262C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A5B20746
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aJozV329"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEIRSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:18:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607BEC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ku01LVy4mg2CK9Ibi+928ZUwYspLRNRmB0kk+FB/mJM=; b=aJozV329v3oXOm+cQcMPjR0CdF
        3z8fkvuYMFwjP9rnY2gqQo9fJo1z1A7hYm6LlLbpeQRHBw1Nvw1oBZpq1zzeBwHSMTdCCgnH4YUdk
        06OUXLNHG3YzWQ6endrzuDumKk98iTS7d0dTkVfDfy3B4igOhSGzmUkIzlH2StXctu7TSMn+TL4q8
        CoBze3Xo2jDJkkfvkdRW5I3sDaU8/xaH+yXzEtFbQ/ixbi22ddV8yrwnCEN1mk9i/QJ+wLq9HZgj/
        rLjGY5ycGRCfpQTx3IW84WstbQD5EUKgytqcD76oVTX0mo94iokmaGLsnsRPeP02nk4rhyUYadESw
        mvlxG5HQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXT7O-0006lC-Ld; Sat, 09 May 2020 17:18:30 +0000
Date:   Sat, 9 May 2020 10:18:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs_repair: convert to libxfs_verify_agbno
Message-ID: <20200509171830.GC15381@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904185435.982941.16817943726460132539.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904185435.982941.16817943726460132539.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the homegrown verify_agbno callers to use the libxfs function,
> as needed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This looks mostly good, but there is one thing I wonder about:

>  	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
> -	if (bno != 0 && verify_agbno(mp, agno, bno)) {
> +	if (libxfs_verify_agbno(mp, agno, bno)) {

Various of these block is non-zero check are going away.  Did you
audit if they weren't used as intentional escapes in a few places?

Either way this should probably be documented in the changelog.
