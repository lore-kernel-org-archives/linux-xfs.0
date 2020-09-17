Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD5CC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA702083B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YeQNCCN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgIQIEQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgIQICQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:02:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B66C061788
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hr8EOjXOX2mDnB+QnrmAkBlwHYzq3UhaCE3MP+6PeRE=; b=YeQNCCN2bWm/7n6bvBehhC747m
        zAc/5mYcqGn52XfrOkMVQYHnJ6JoM92DA6mPzgfga47jFZyWhbDTAVw2KroBEGNBTDkudVN5oSKn6
        Gy6vVl/szzfSHkQBxFpCiR5ITPH9z1qCME5wLYgiJKVxthU2lUm92qYQ81p+OLZ7BfA5jgwvchsM/
        pNrAwj31BaywD3Lopw/Kjfe2xBg7EwG46FfBjuG8l6/rg6BqctU921whKG9poRGJmnEdXd0obURr0
        1Fu2XnuNTvn9+9Eg0iNEuFg0ITb9e51wT6NhpI031Swux0Yaos9WCDTgUHwaYh0YcPkSsRiKwxX6E
        HTz4Lutw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIors-0007nP-7n; Thu, 17 Sep 2020 08:02:12 +0000
Date:   Thu, 17 Sep 2020 09:02:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: don't propagate RTINHERIT -> REALTIME when
 there is no rtdev
Message-ID: <20200917080212.GU26262@infradead.org>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013467762.2932378.12947505930529559840.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013467762.2932378.12947505930529559840.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:51:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When creating a file inside a directory that has RTINHERIT set, only
> propagate the REALTIME flag to the file if the filesystem actually has a
> realtime volume configured.  Otherwise, we end up writing inodes that
> trip the verifiers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
