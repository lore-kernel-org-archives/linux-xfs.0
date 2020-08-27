Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C095C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB69B22B4D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RkqBz5/h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgH0GvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0GvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:51:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF679C061264
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vthlFXsNWj/Fp8fnh1mbUSu3EE6eYeV8Gxe3HE8nbi4=; b=RkqBz5/hmOVt9WSo4U1E1Z1wCw
        zVM48AKzWryC3e8tCm1/W/+sCVo481Kvkh67uUj4dqJNyg+zG0rUuzf6Hmr1S1b+oNpVDWOvuKY35
        Maz+ulY7nBjsq0wfSPcYCf7OlH8Ur/v86p6Z6H5F+7rFvGD5p8w3cjDJsczEc12YF/P2jIfIFagr9
        XyFTOvwgBls3pkDRjwWzcPAnFz1cbJnoQ+lcpM5GoXmHl5C1YXvylWrnE2Sv6nz1BvLxZxBbwmun3
        bCK43jkE669wsmhJH3bD7QG2QD4EFNQp2Z9F+kizyk5c8CNJZ0d2HyOJFM1sc8QVyG1P50bVsDIDi
        NVzZTe+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBkg-0004vq-OZ; Thu, 27 Aug 2020 06:51:14 +0000
Date:   Thu, 27 Aug 2020 07:51:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 07/11] xfs: kill struct xfs_ictimestamp
Message-ID: <20200827065114.GA17534@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954327.2601708.9783406435973854389.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847954327.2601708.9783406435973854389.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> + */
> +static inline xfs_ictimestamp_t
> +xfs_inode_to_log_dinode_ts(
> +	const struct timespec64	tv)
> +{
> +	uint64_t		t;
> +
> +#ifdef __LITTLE_ENDIAN
> +	t = ((uint64_t)tv.tv_nsec << 32) | ((uint64_t)tv.tv_sec & 0xffffffff);
> +#elif __BIG_ENDIAN
> +	t = ((int64_t)tv.tv_sec << 32) | ((uint64_t)tv.tv_nsec & 0xffffffff);
> +#else
> +# error System is neither little nor big endian?
> +#endif
> +	return t;

Looking at this I wonder if we should just keep the struct and cast
to it locally in the conversion functions, as that should take
care of everything.  Or just keep the union from the previous version,
sorry..
