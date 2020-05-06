Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D407EC47256
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA29B20836
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="APyy9s8Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgEFP0L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730132AbgEFP0J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:26:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A71FC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jfeevm56Bb9P9qfXFh140MA2rvtJ1Fehq0GAMn1okKU=; b=APyy9s8Yv2EcWBM39eQxpS85WR
        8dPiQik9cGcGbmk+eqocYu2z+utmbQWkAmqlXrKt3FbB7gtkxny28L0K//4JgFLcuWx4Lyf46dqLS
        oZCf7yvTsUT17lYNBMGKXjK3JrwuycgwnQW6GKRT2S9EzjsLJy8GPJhAKxIuL+Z7j7h2At2aoJbjj
        C3Hl5MoZEdmyQroS3FNRVhUV1+lBwR5hlSroOvfYFfBmJXcdWTmKFzN9FV80OWRGGHUKc5Z0UEde1
        zv03lhhV6HAtEJ6Z/9DgW/A55bYAsc/QGZ0sCHg70RCbFhjWcJkru6FourHwq8zyKiIx06TIG24MQ
        rtfFEOWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLw1-0007rS-3z; Wed, 06 May 2020 15:26:09 +0000
Date:   Wed, 6 May 2020 08:26:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/28] xfs: refactor unlinked inode recovery
Message-ID: <20200506152609.GW7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864114901.182683.2099772155374609732.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864114901.182683.2099772155374609732.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that processes unlinked inodes into a separate file in
> preparation for centralizing the log recovery bits that have to walk
> every AG.  No functional changes.

Is this really worth another tiny source file?

At least the interface seems very right.

> +out_error:
> +	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
> +	return;
> +}

No need for a return at the end of a void function.

> +	struct xfs_mount	*mp;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	xfs_agnumber_t		agno;
> +	xfs_agino_t		agino;
> +	int			bucket;
> +	int			error;
> +
> +	mp = log->l_mp;

Please initialize mp on the line where it is declared.
