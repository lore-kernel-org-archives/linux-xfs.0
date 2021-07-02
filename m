Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED983C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C576B6141E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhGBI1O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhGBI1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:27:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB38C061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ty2m8OMNpfhaIJH/bLoY6G70RQ6bhCBvO5FWb8X3oZU=; b=Vi8qGpzYCTcLN4nG85UWF8LK6R
        Fw6KcvBJS9N+BmdtD5R0kP9EGZ6r8HO1R/vdVAYlb2aNCjeDYDKsuAVLmTyBiPha0lSB5Hwduek/x
        iXLYfzii6uX2sTc91KryIw1MphtJGkcNTzHMXHnP72TAY9oa4IYhfNCA1Vgv4TeRttZ5iS2WZA4uz
        0m8fLxSZvVy+u3mDQzxTd1UHjCkdOeTsHstWUXy8xSeu4zlUQjZCu5g1pMwN3TXNdjVIXd0+evC3A
        cqyaAOJX/tPOMRcW2IvOgd+pHi8H05hpvHw34+sSScpVncgLHUSL0NG/cYSVkr3XAJQmbr1+FP1+Y
        PIlB0w0A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzETL-007UzU-7y; Fri, 02 Jul 2021 08:24:30 +0000
Date:   Fri, 2 Jul 2021 09:24:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: make forced shutdown processing atomic
Message-ID: <YN7NO5tAn6tVnyIb@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	spin_lock(&mp->m_sb_lock);
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		spin_unlock(&mp->m_sb_lock);
>  		return;
>  	}
> +	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> +	if (mp->m_sb_bp)
> +		mp->m_sb_bp->b_flags |= XBF_DONE;
> +	spin_unlock(&mp->m_sb_lock);

Any particular reason for picking m_sb_lock which so far doesn't
seem to be related to mp->m_flags at all? (On which we probably
have a few other races, most notably remount).

> +	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> +		xfs_stack_trace();

This seems new and unrelated?

> +

Spurious empty line at the end of the function.
