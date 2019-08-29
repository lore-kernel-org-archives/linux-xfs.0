Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09A6C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA4723407
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k8Lb6sbM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfH2ISZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:18:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfH2ISY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hT8kHOrXvHmUC58ZQSV2GrTd3j1aRtUsm7M719ChJGk=; b=k8Lb6sbMiFj3DA3eosI09bGKo
        NdWC+J1S8Lp+VnUlA/2kRyrnKwFebtmhi+jvV0cTb7T463hp7CD7lFnJmT8k4/mq0KYPaiDcV7vfm
        b5QHPQ8iQR3fHzojuF69+25PyuMvgu6Uzr+SOBYv1on6ETBz5SoTsPxsoR8qMHhJFrvkuiTocloeY
        kt4Vjn7bZiJRaXSs1jts1UsO4wRigLdGEc5EKhX1LUfgIDHGUAUkmM8duygRFiq5g4M5s2JPV1qNo
        8Z2jxCRvoozB2rx/f+qTVsLZnwmEHHAMbpkG3P5z2y9TP+BOzFJ6s0Nu+XEhXGvLUOqDrtT/UlJwP
        0gpqygAlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3FHj-0004Qv-8E; Thu, 29 Aug 2019 07:55:59 +0000
Date:   Thu, 29 Aug 2019 00:55:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: allocate xattr buffer on demand
Message-ID: <20190829075559.GC18966@infradead.org>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828042350.6062-4-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 02:23:50PM +1000, Dave Chinner wrote:
> + * If ATTR_ALLOC is set in @flags, allocate the buffer for the value after
> + * existence of the attribute has been determined. On success, return that
> + * buffer to the caller and leave them to free it. On failure, free any
> + * allocated buffer and ensure the buffer pointer returned to the caller is
> + * null.

Given that all three callers pass ATTR_ALLOC, do we even need a flag
and keep the old behavior around, at least at the xfs_attr_get level?
For the lower level we still have scrub, but that fills out the args
structure directly.

> +static int
> +xfs_attr_copy_value(
> +	struct xfs_da_args	*args,
> +	unsigned char		*value,
> +	int			valuelen)
> +{
> +	/*
> +	 * No copy if all we have to do is get the length
> +	 */
> +	if (args->flags & ATTR_KERNOVAL) {
> +		args->valuelen = valuelen;
> +		return 0;
> +	}
> +
> +	/*
> +	 * No copy if the length of the existing buffer is too small
> +	 */
> +	if (args->valuelen < valuelen) {
> +		args->valuelen = valuelen;
> +		return -ERANGE;
> +	}
> +
> +	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> +		args->value = kmem_alloc_large(valuelen, KM_SLEEP);
> +		if (!args->value)
> +			return -ENOMEM;
> +	}
> +	args->valuelen = valuelen;

Can't we just move the setting of ->valuelen up to common code shared
between all the branches?  That means it would also be set on an
allocation error, but that should be harmless.

> +	/* remote block xattr requires IO for copy-in */
> +	if (args->rmtblkno)
> +		return xfs_attr_rmtval_get(args);
> +
> +	/*
> +	 * This is to prevent a GCC warning because the remote xattr case
> +	 * doesn't have a value to pass in. In that case, we never reach here,
> +	 * but GCC can't work that out and so throws a "passing NULL to
> +	 * memcpy" warning.
> +	 */
> +	if (!value)
> +		return -EINVAL;
> +	memcpy(args->value, value, valuelen);
> +	return 0;
> +}

Can you split creating this helper into a separate prep patch?  While
not strictly required it would make reviewing what is consolidation
vs what is new code for the on-demand buffer allocation a little easier.

> +	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
> +				ATTR_ALLOC|ATTR_ROOT);

Please keep space between the symbols and | on each side.
