Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA070C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F0612245A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dNzShcfY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgJ1Vvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:51:50 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgJ1Vvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6JR5L+wTP9qjEfvNi/Be4fRnZJreo8FoB8roNtGUflM=; b=dNzShcfYUa1O26wBFlNYfxFrFU
        7hrNZBl2DkPIALal8F0XTnO2lKdVebry00ERjNt1bhvAcTXD87HOkuD0ipEUTVBTsFIz6NR4pnXOk
        Xl42wY/wrbCv3iId0C7gFrMxGScfZctClfCo6XKhJ0KBUJ6G8pV2kSuA7MUm+/fcuDNzWnO2C2Ajh
        zDM09/N3P6eN792yreoVRs14nsWkyWB+9rvHrDoDTsx9IUcntbY7uByjVs/I0SR3EsdYk8T3dSsB9
        rOwTNvC/PW1NWypvVsr3uc2NHpaKZ3uhwWCVyUEG0fCo8G+fjgRNNvkRpSX2advwqhD2XB6PCaQLL
        9PZyOo9A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfze-0000SS-Jy; Wed, 28 Oct 2020 07:35:38 +0000
Date:   Wed, 28 Oct 2020 07:35:38 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_repair: correctly detect partially written
 extents
Message-ID: <20201028073538.GG32068@infradead.org>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375514426.879169.1166063350727282652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375514426.879169.1166063350727282652.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Recently, I was able to create a realtime file with a 16b extent size
> and the following data fork mapping:
> 
> data offset 0 startblock 144 (0/144) count 3 flag 0
> data offset 3 startblock 147 (0/147) count 3 flag 1
> data offset 6 startblock 150 (0/150) count 10 flag 0
> 
> Notice how we have a written extent, then an unwritten extent, and then
> another written extent.  The current code in process_rt_rec trips over
> that third extent, because repair only knows not to complain about inuse
> extents if the mapping was unwritten.
> 
> This loop logic is confusing, because it tries to do too many things.
> Move the phase3 and phase4 code to separate helper functions, then
> isolate the code that handles a mapping that starts in the middle of an
> rt extent so that it's clearer what's going on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
