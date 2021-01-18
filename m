Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78945C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3E222C9D
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437470AbhARTwE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437175AbhARTwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 14:52:01 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EE5C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 11:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ubl3+NtdOJfGNKhQld4kYcV65Z+k11p6erna1oaxhdY=; b=dNRvjDK2kSUz/Dmai4xUyAQ2q8
        8Nim/zajzFg2rgwDmiL5gmRjBpPB1iNtJ9Ex1Tq9ZBzxLbTfTBcRwzWz8xHocNBshHOs76u7ZEnxy
        BN0UyOnFZWWbDjCfwnU9aUTLy05Fc3leKTvwQrkh+gQzknBYxH3ef0Z6sGv/wez4pP7YlYF9k5Rf3
        KvMZ13pyKOmXQXZPahkqLotI2pDSlvUyowDCdYhm7uoc+WHHn39HblhuM6L1lyCOw2Y3SwnJWKJQ0
        aLZ3VmmwVqZQQMdQP5h3APfGr5vhhes8FCpb77gRhJO2z5nqx5/cyamsCdF0eWsxvhGX49TcsIHsQ
        09CVF1hg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1aYJ-00DJvN-NK; Mon, 18 Jan 2021 19:51:13 +0000
Date:   Mon, 18 Jan 2021 19:51:03 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210118195103.GA3174212@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737263.1582114.4973977520111925461.stgit@magnolia>
 <X/8HLQGzXSbC2IIn@infradead.org>
 <20210114215453.GG1164246@magnolia>
 <20210118173412.GA3134885@infradead.org>
 <20210118193718.GI3134581@magnolia>
 <20210118193958.GA3171275@infradead.org>
 <20210118194422.GJ3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118194422.GJ3134581@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:44:22AM -0800, Darrick J. Wong wrote:
> D'oh.  I tried making that change, but ran into the problem that *args
> isn't necessarily an eofb structure, and xfs_qm_dqrele_all_inodes passes
> a uint pointer.  I could define a new XFS_INODE_WALK_SYNC flag and
> update the blockgc callers to set that if EOF_FLAGS_SYNC is set...

That does actually sound cleaner to me, but I don't want to burden that
work on you.  Feel free to stick to the current version and we can
clean this up later.
