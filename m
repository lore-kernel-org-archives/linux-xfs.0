Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A21C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20FD623120
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbhASGrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 01:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbhASGrE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 01:47:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3807C061757
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 22:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a8nSY6Fi+/dtJD8UBZU0mMngBvhu3ugCtwLpn9ClBpU=; b=TPDNc4y5j/bjZGa6hOsh4n1zIq
        nUNpErExsAw2yTITkKRCI1eLKfGL58fcpaJWJlD7RDKG55/HE2v38unuaNPRF9UbMJsqSHKQfCgf7
        0l2bIzf7/40rKqcokhiAplHKaqm4qdxHrOFVvCk0gBN0x3nCBE3sVVGlFO8mrr+ZdeFwoiGRtuDuS
        biT/ZEUiZ9tTXRyq8ELDIpXHskZHZMTvliIbsjO6laJrv30BpvnFD3oDw/fi/rHMVaR1c4Vyhi661
        /pC6GBWpR170lpzIXEFSm7cHSmL+GUyjjhwDeM6gtX7FD5bkupwRzfW7QKggPhFrg/LOrfElTbD3k
        INZzsJkw==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1kmL-00Dv1D-9s; Tue, 19 Jan 2021 06:46:14 +0000
Date:   Tue, 19 Jan 2021 07:44:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create convenience wrappers for incore quota
 block reservations
Message-ID: <YAZ/s1a0c7drWZv3@infradead.org>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100791039.88678.6897577495997060048.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100791039.88678.6897577495997060048.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
> -						XFS_QMOPT_RES_REGBLKS);
> +	error = xfs_quota_reserve_blkres(ip, alen, XFS_QMOPT_RES_REGBLKS);

This is the only callsite outside of xfs_quota_unreserve_blkres,
so I'm not sure how useful the wrapper is.  Also even on the unreserved
side we always pass XFS_QMOPT_RES_REGBLKS except for one case that
conditionally passes XFS_QMOPT_RES_RTBLKS.  So if we think these helpers
are useful enough I'd at least just pass a bool is_rt argument and hide
the flags entirely.
