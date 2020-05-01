Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA05FC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993ED2184D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BDzHMaaM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgEAK2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 06:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728480AbgEAK2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 06:28:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AADC08E859
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 03:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FItWIJCgYbqLk0i0ykcuRVN4HIj0aLNksWvyk6/FL+8=; b=BDzHMaaMS5fn5+OyN88t2ggYGa
        zZYUv6kAMhYJzKcACX3WfaKvLVRqfX1J3yYhMtKMQTgxSK+3Y8gYRC9tkuOpUoIZF+uRJX2kM0p7F
        UyLm2TLB3A3L4wvzTkxpvelYKBjqXgQJmGPF5iioAwOLs+bctdspwTsXLOSs/XG4wyqv/1JhkGXya
        5PUxdrJw9FiJAjDFnP7B64RwX36u6FWGg712GXJ7JJbC9NcPHNIJx8Bh6wq6qqyf2oTxlRUtXiwT5
        vW+fFDucRqs9er529hevg5uJAWlt2YOLhxDo7D5aBh2mxuQ6RboqHPqvLE59EaSWsH0jW4HGjOYRE
        DHvQbrbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUSuS-0006Q4-E3; Fri, 01 May 2020 10:28:44 +0000
Date:   Fri, 1 May 2020 03:28:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/21] xfs: refactor log recovery EFI item dispatch for
 pass2 commit functions
Message-ID: <20200501102844.GA13329@infradead.org>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820771414.467894.16178249031828526203.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158820771414.467894.16178249031828526203.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +STATIC int
> +xlog_recover_extfree_done_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{

...

> +	return 0;
> +}
> +
>  const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
> +	.commit_pass2_fn	= xlog_recover_extfree_intent_commit_pass2,
>  };
>  
>  const struct xlog_recover_item_type xlog_extfree_done_item_type = {
> +	.commit_pass2_fn	= xlog_recover_extfree_done_commit_pass2,
>  };

Nipick: It would be nice to keep all the efi vs efd code together
with their ops vectors?  Same for the other intent ops.
