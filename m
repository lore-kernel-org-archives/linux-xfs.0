Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6147FC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1331E64DE8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhBYHkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbhBYHjn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:39:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CFAC061756
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v2Zbi67SmYTKqWoPFpFYPEOYBcFJGVJ3dsMOKlB6hXw=; b=h150H2Hm74DskWsiuelVdMsnV6
        eGGnMlSmhpb4wys3KvqD5G50szJMILqMuZ2h+sjmj9Ag6NPTJcBmW9eereNN/sqGqdd9Vu2vI23yQ
        NnOr29tIApACP2KgnVMCcvLZAEFh+iO0lZ0uP2bSeZTPCIAQvKf5dUGaG6dpaLCKRZXsKpkSbLEHz
        6F57s1urVJCWTttmhmniXddYn+ZX/OfsiGkQsZrSWDQa2zSiMpr5vD8IriKWCSDwkOHRU0GF4eS4e
        pgCzOexAFdXsYAeCF4DF+lO2eebHqRmw4Jo3AUH0EqvNROQLmMrCnPmdZd+QmcRW9qgKtNuDGqVFm
        FDFc63OA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBEW-00AQ78-7T; Thu, 25 Feb 2021 07:38:50 +0000
Date:   Thu, 25 Feb 2021 07:38:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
Message-ID: <20210225073848.GC2483198@infradead.org>
References: <161319441183.403510.7352964287278809555.stgit@magnolia>
 <161319442288.403510.14136573891346236052.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319442288.403510.14136573891346236052.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:33:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make the expected AGI size larger for the inobtcount feature.

Is embiggen really a word?  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
