Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E9DC63777
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 08:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02450221F7
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 08:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgLCIlV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgLCIlT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 03:41:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA8C061A51
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 00:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7DRE3mrMmIjG4S9WNOAdSunLyD6G66uPPKORiFvu4Aw=; b=ttnd1rWMJQFZkvEz84wzeBTcH3
        FtPEiyaowxDxtdNWBsPE7TbSchVFJe/fgZPq4ZJrtHvNkSH5DAT2Fz+rhAcFQQsZKjkPTcSePy+Fj
        NFkgP/fb1KpKy7dQLI3h0OmQeHCie+HuRz5Ijx7l8T8NNBaun5a44vJfup7Lg7DVM27TV3NeTcUkk
        Aqi1ZUnejhyM4/CAgrCy3L9PgkDaHARcPvFYMbvOAibnrOqybazfy6dz69B+1bFYGw2CnIeIPvVAy
        2VbZm7Gi1Kogtq/3/ld4LoYoLKdYNeo8Us4N5/DnQukDbC6d6isjwxqqvI4s3PvgtR0ul1WyUI+KW
        5SAtqwPQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkkAB-0000Gc-Vn; Thu, 03 Dec 2020 08:40:32 +0000
Date:   Thu, 3 Dec 2020 08:40:31 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unneeded return value check for
 xfs_rmapbt_init_cursor()
Message-ID: <20201203084031.GB32480@infradead.org>
References: <1606984438-13997-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606984438-13997-1-git-send-email-joseph.qi@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 04:33:58PM +0800, Joseph Qi wrote:
> Since xfs_rmapbt_init_cursor() can always return a valid cursor, the
> NULL check in caller is unneeded.
> This also keeps the behavior consistent with other callers.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
