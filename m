Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA187C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D2A23383
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbhAMPLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMPLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:11:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B68C061794
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NMJXl9AHO5s1SEcI05e2niWs7FQaydoGkbplLmIIoLQ=; b=Dnwdc6zXnX40WjZTRBuv80Miem
        ChBA69aCPWS51kAOtNTZPBIXEmneR8OfQ0wwpPB5/b0tjUCHvTfXMFzZSF5ycKdTAaatK8sv3kZTD
        n+vh/QvGJMA1qSKm472TFrm1RF7K58tA4g8zf5aq31PE6YVin0+jeJbyJW8U7iIgHN+kmhRffsZFs
        bQK9RWZ6QYPiWaB1vvGuDgdD/YGgkHCoUGsU7mDACChf/a73dvgXS3AzK8AW+NwGxNUGJWh5s/5wJ
        Me4Tyric2vqq4se8FJVctkqO4dfn//ZnDBQscz2Ubpcq7wSUbUX8gYkFhTaA+NmzpUxTv+tmLPfaO
        b41oVT/w==;
Received: from 213-225-33-181.nat.highway.a1.net ([213.225.33.181] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhmP-006Oe7-Ay; Wed, 13 Jan 2021 15:09:54 +0000
Date:   Wed, 13 Jan 2021 16:09:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: parallelize block preallocation garbage
 collection
Message-ID: <X/8NOl0vwCvEOjrI@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040743914.1582286.9059958538368033662.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040743914.1582286.9059958538368033662.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Split the block preallocation garbage collection work into per-AG work
> items so that we can take advantage of parallelization.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
