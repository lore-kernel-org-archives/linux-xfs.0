Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4230CC64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C396020770
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 10:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VYnCmYF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgLAKVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgLAKVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:21:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D936BC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y22BmAwA1BEMkZuvk5rJwCbxVsd+L/l/Q9+B37ZDNhA=; b=VYnCmYF6XM8sPJutlHcj1JatzP
        A0KOr4ryFCdH1dlAhEt3qTQhcN3W/D1O87AB+nM26xM4zurJBNm1kP6JedHvEPhyUMIAaBsvXNcUv
        iEFMaPldTK/nfM9jkEZiMKhtSEDfoLjSxlIus+xxaavPk2+VquVnIqENAY3cYEi0FydrlvVxXml27
        A76y+K5FKpsG1NivRMHyS/IJTNdVc59QEfoNQ1kzd2rkF66hvEW0nCK1pB0tuftE0vUOFVjAHuOgt
        vcP4tyc5qCncQOQXSSGYp6uCWUmZTNKm1mJGB9wL1Li0ATmwWZvgfd0N8ikRD6hzFW36ngHraX2HZ
        e5ArNurg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2mK-0004Af-Hn; Tue, 01 Dec 2020 10:21:00 +0000
Date:   Tue, 1 Dec 2020 10:21:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201201102100.GF12730@infradead.org>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124155130.40848-2-hsiangkao@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 11:51:29PM +0800, Gao Xiang wrote:
> It's enough to just use return code, and get rid of an argument.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 45cf7e55f5ee..5c8b0210aad3 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -607,13 +607,14 @@ xfs_inobt_insert_sprec(
>  
>  /*
>   * Allocate new inodes in the allocation group specified by agbp.
> - * Return 0 for success, else error code.
> + * Return 0 for successfully allocating some inodes in this AG;
> + *        1 for skipping to allocating in the next AG;

s/for/when/ for both lines I think.

> + *      < 0 for error code.

and < 0 for errors here maybe.  But I'm not a native speaker either.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
