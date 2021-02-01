Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3856FC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9AC364EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhBAMTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhBAMTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:19:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D49EC061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YC2pM+PlMR2KQQHPdi/vmj8JLX8Ys1wWkS83ZEw1QlQ=; b=KDj7raSij9c2ilZbJ5egR3bm1v
        QVvqb0A8dV2nrQtE4UhWvMx7TkpwVYCNaqagClQ55ieu5w0+ENdq5/V9bCIewsHt5gSi8sM9bJSTg
        G+et5B5QcdEYEwKtIu3ixqw8XWoR7qNEb/C9fcO6HCwQv0ADPYQcG0EGUevbeyizFZgmMqmznUG3a
        lp8UJCwGy2WvXDfaxKlxw0o3oL4L1ER1Wqb4klky26ZF5Qubwego9uH0ya6TchwCCAzm55NZ7iDUE
        gvv+BCQkWQqkegi9RHyeVboSGi1kXH44i7Ewi2+9c2mN9x3EPDQ/4i9ZUqcwryO9shZW1hWrHmWXa
        yMLBZNcw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YA6-00DkSm-G8; Mon, 01 Feb 2021 12:18:34 +0000
Date:   Mon, 1 Feb 2021 12:18:34 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 14/17] xfs: clean up xfs_trans_reserve_quota_chown a bit
Message-ID: <20210201121834.GC3271714@infradead.org>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214510730.139387.4000977461727812094.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214510730.139387.4000977461727812094.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  
>  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
>  	    i_uid_read(VFS_I(ip)) != udqp->q_id)
> -		udq_delblks = udqp;
> +		new_udqp = udqp;

We don't even need two variables for each type, instead we can just
clear the original pointer to NULL if the conditions aren't met.
