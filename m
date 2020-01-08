Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C121CC00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C91320692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ruKL4iqK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgAHIvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:51:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgAHIvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:51:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oNv7f6MV2jk5eshW/Kand4tY3/N798JYLSQoOlyd3q4=; b=ruKL4iqKVl3UPT8/Pm6BD7Vdr
        SBpZzRTK7jwfQz8zhNNDN5sqjwKGRumU4LyX4aoKzbffofE7knpcVIFvr0Tz2CEtL31wKTq3JEHud
        /FLYONBsAPMrHqHWPWMn+abTNs/CARxunpPTTbbKtd3AQdLweK4Hx9I58saxeMGD1PbJ06aWEAOpM
        XUKsrRVBWj7KP1jZ2yA5WjpgM8U8bEC1t0sKiAnk6UjnFYK6mp54q6y1BPUJzR0sOh0Lgdk4Auvw5
        Y3ukBWxVjstsMweNr7uWIgTyVz5FE76zOgpsEVGvufxqcW55we5kEsPwIIWN56wE7NZSNHHOAM3SQ
        HMqckUWzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip73r-0000MZ-Ni; Wed, 08 Jan 2020 08:51:31 +0000
Date:   Wed, 8 Jan 2020 00:51:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: complain if anyone tries to create a too-large
 buffer log item
Message-ID: <20200108085131.GB12889@infradead.org>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845709897.84011.1433283906403215456.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845709897.84011.1433283906403215456.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 08:18:19PM -0800, Darrick J. Wong wrote:
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3984779e5911..bfbe8a5b8959 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -761,18 +761,25 @@ xfs_buf_item_init(
>  	 * buffer. This makes the implementation as simple as possible.
>  	 */
>  	error = xfs_buf_item_get_format(bip, bp->b_map_count);
> -	ASSERT(error == 0);
> -	if (error) {	/* to stop gcc throwing set-but-unused warnings */
> -		kmem_cache_free(xfs_buf_item_zone, bip);
> -		return error;
> +	if (error) {
> +		xfs_err(mp, "could not allocate buffer item, err=%d", error);
> +		goto err;
>  	}

The error handling here is weird, as xfs_buf_item_get_format can't fail
to start with.  I'd rather see a prep patch removing the bogus check
for the kmem_zalloc and change the return value from
xfs_buf_item_get_format to void.

Otherwise the patch looks good.
