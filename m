Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DBCC55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC8A2080C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 07:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EywXmHz4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgD0HZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 03:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgD0HZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 03:25:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B07FC061A0F;
        Mon, 27 Apr 2020 00:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nvKryGltvAZBbLqFJq4aHWUrRwCZ4uSxodxNcS43W1M=; b=EywXmHz4i8UGNyEIOAOgABnyw2
        QpIgEWUG+OovJD79btXpcQROu2y+Ssxn3weaGuU+lbU8VFb60Mbv/dQ43NebPsBraLJJfgq8jfwea
        K1bZwDeaW28CHbQpqLFKRmV0+gAkfT2RkeebxhqK4OqWrrtvsj2V22Oe0mDWjJCunDuFJDr2e675t
        eprmjw71k1RJwiAQdyQ+HndUERGqVS/pV5nsgUJV3eBuFHY1R8ZO/WOqLZWPvuPT3vhjC/brD5P8A
        ahAla0pEDc7A8slOeJSEkigVFZ4sFMgEKiRnveKoligCFfKpA7vdr4ckYniuxZB0uEnFkZuE45GrC
        0P2tmK3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSy8t-0003X5-3Y; Mon, 27 Apr 2020 07:25:27 +0000
Date:   Mon, 27 Apr 2020 00:25:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200427072527.GA3019@infradead.org>
References: <20200425133504.GA11354@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425133504.GA11354@nishad>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 07:05:09PM +0530, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style in
> header files related to XFS File System support.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used).
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.

Please use up all 73 chars in your commit logs.
