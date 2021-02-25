Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE328C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C15A64ECE
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhBYJUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbhBYJSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:18:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10ABC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WknfNTRvRJRrn6mgyVHkGwybq8GU0T4xkAiHsJQcd9I=; b=fNwudS6Pazgy1G9nruBVCBjUG3
        SzmJ+Rs3kpobLV0VUGP4efW+qwgVsbXiLWW3ApV0jLFEFyirH3Xtm3r0hnIVgzSatbtxvCNjgC/gF
        duNA34DcKxvtGkAVlxxJs10cjPj8dFDhDa73znJTf7NYkjhUjFKkRdeaF5jQNcTheL8ZJVHn2mpkC
        lIkxiA/lW4KFnS27d0IVUKtodKDXeVlXCHeG92QGnXytxD84LfHTQPjsuYDSxZqmOSAJKMj8ZPQZV
        SuNZJWlFrty1yVPZ5jHuya6XWZcXawev8KkiwUfoygbyjtKHvms5imp64f6Y4xfMQsDQZ2/O+FTjI
        kOPoPB0w==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCmi-00AVok-0o; Thu, 25 Feb 2021 09:18:15 +0000
Date:   Thu, 25 Feb 2021 10:15:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: only CIL pushes require a start record
Message-ID: <YDdqz9LwTJRZCFmj@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index e8c674b291f3..145f1e847f82 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -652,14 +652,22 @@ xlog_cil_process_committed(
>  }
>  
>  struct xlog_cil_trans_hdr {
> +	struct xlog_op_header	oph[2];
>  	struct xfs_trans_header	thdr;
> -	struct xfs_log_iovec	lhdr;
> +	struct xfs_log_iovec	lhdr[2];

oph and lhdr aren't really used as individual arrays.  What about
splitting them into separate fields and giving them descriptive names?
