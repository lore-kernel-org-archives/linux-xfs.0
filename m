Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33381C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C36FF206E3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sLntRAj8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLAKGt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgLAKGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:06:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263E8C0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wb5WRspEI8xKaMevXNwYs/t7FgZ8DbfuW4sd9roBpU4=; b=sLntRAj8mwWpO2XQJcNlLbI7PY
        mZ41blLpLaTy8THqmuG6IWm/QrLsEkIXWaV2E2h8xm85KDglKj3BkYqMpzppFmO0qNJL59R1xuzRS
        luQBXJlQYyolobWciGNyu0cw7ihgn8IUlrGYErcQOGVsTSipL54SYN99rjna0CT/w4l48naXWBXi1
        QwkOEcwIW3F9GpQVOUoeIItxUFtfXC0/HYR9+rJhJdutChMpSTmYjgatsB8SXUYkwerImiClIJUpE
        Thq6Z0ZffzRA1QmZpPmEjRbQ8u/yAhDl1yQeuEIreQKnHbyMSh6nu3ykSziJtFi3uOg/pH1cO+kfC
        uj8Ter0w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2YK-0003Da-Qr; Tue, 01 Dec 2020 10:06:32 +0000
Date:   Tue, 1 Dec 2020 10:06:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: hoist recovered extent-free intent checks out
 of xfs_efi_item_recover
Message-ID: <20201201100632.GH10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679390266.447963.18406641317021209964.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679390266.447963.18406641317021209964.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:38:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a extent-free intent from the log, we need to validate
> its contents before we try to replay them.  Hoist the checking code into
> a separate function in preparation to refactor this code to use
> validation helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
