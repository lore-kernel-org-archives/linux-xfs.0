Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2202EC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD3164EB4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhBIJ2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhBIJ0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:26:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325E0C061786
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HokY3MOUoHHJEgOTuRX3FxyiBzW13vK2zRtjKDWz/uk=; b=fCQu+sC0AKTfPksg4f3muWZvHN
        7KJKgdgT3q7RKjaDMTrecw7FQKbTXHID0PQgkZiXMY6wueEdbNkYdmBqRxM8Jo4FNESzCdwnjb+uc
        OQZrgtLHnHry2IMiYDjtsXJDaaZlLxLMk6gxk4Fqm/xrSRU9vaR8/XthuzyQE+XOIwSmbrMwAqUFz
        hLHVo1xQTO/1PxoGD2hXDL+AISeN89tLsLMRadzyPg/Krtg1YiTBpBSWnX++9Ity8omi8VcPPES6j
        BjlJzpmabT2H5VPISpOHniWZnwv6ufB/xrSWpnBkBuIPzw9IXodws2OAKAyqp7wOxyOFHSOmRDNw5
        a50yay9A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PHZ-007ELA-Ei; Tue, 09 Feb 2021 09:26:05 +0000
Date:   Tue, 9 Feb 2021 09:26:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 2/6] xfs_scrub: detect infinite loops when scanning inodes
Message-ID: <20210209092605.GN1718132@infradead.org>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284388746.3058224.2675575511596158478.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284388746.3058224.2675575511596158478.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During an inode scan (aka phase 3) when we're scanning the inode btree
> to find files to check, make sure that each invocation of inumbers
> actually gives us an inobt record with a startino that's at least as
> large as what we asked for so that we always make forward progress.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
