Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB73C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D31206DF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rt1AHiC0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgLAKEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLAKEY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:04:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C56FC0613D4
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nF1CH9Ia9jPYnXANKVCPUDkKufW0EsMOBCa6FI3ixBc=; b=Rt1AHiC07arL+jXCl6Ypwxgogf
        VoOGMGsYoddcUB7G79HirNTngqfq8hoiMG+e3vhrJoZnw9rq01d8RomSf5r1x0yXxeM4PFmPui13v
        aIDPggU2w9YUKHvhQgBaOwpJHMmZLzYGzmPDAhYjDymLQM8cvhf3F50o4+5tvIEEs88bv/WY972Ft
        RbXgStwq+WX7Tb7/GPlz410YrA64M+Pm26lgjCBdNBDpPRRqmhcbiVSXIWEgu/ScjXLQkxO+/Ssm4
        4FxmpftfWcZ5jKQNz+ZNKVPtbltU/TWKV2o8cilxThm7yRVA5umrFbbMozQ+M0AB1+K2D2nRcX7hP
        DjkhETRg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2Vb-0002si-0R; Tue, 01 Dec 2020 10:03:43 +0000
Date:   Tue, 1 Dec 2020 10:03:42 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: hoist recovered rmap intent checks out of
 xfs_rui_item_recover
Message-ID: <20201201100342.GD10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679387832.447963.10771235215002135416.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679387832.447963.10771235215002135416.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a rmap intent from the log, we need to validate its
> contents before we try to replay them.  Hoist the checking code into a
> separate function in preparation to refactor this code to use validation
> helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
