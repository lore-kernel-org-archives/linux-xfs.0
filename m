Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E781BC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5D762389E
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbhAMOul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhAMOul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 09:50:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2380C061786
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 06:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CFM9S7VpSAslkZGmNo23z3ALhVypRlEpXUh33nEtnXc=; b=WUORLM1ZU73GPRuir4fQDu5C4m
        lT9r1Qrb5zB4eMqn/xLGUMXDPQnDG2EdiCkfJhYSAuUT4r091v3JGsPD6r/TnIc4haZX/YydY9Ih9
        mljSoLueuCN6o8Unx3i8S8ySIDH8suxoJBJEHG074VKbtTQGk1FkWCbiFkYcQEtyIdFmBCdlbNJqm
        jQnoTgUsHadHrdGBuFpRBBq/sySj9F6S/HgGzYnlZUvHVkZpxjp93Gwx+9KzlcUggaSFhEB6tcNJD
        EwgkfitbtCYRK0XdqCXDu8FU9S3P8YQN5tKwniHne5xVJMUVDMedLWj/vCIrt9EeD3tmG8RIPjKAz
        WrV9Vi4w==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhSo-006NTW-Ue; Wed, 13 Jan 2021 14:49:39 +0000
Date:   Wed, 13 Jan 2021 15:49:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <X/8IfJj+qgnl303O@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040740189.1582286.17385075679159461086.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* Estimate the amount of parallelism available for a given device. */
> +unsigned int
> +xfs_buftarg_guess_threads(
> +	struct xfs_buftarg	*btp)
> +{
> +	int			iomin;
> +	int			ioopt;
> +
> +	/*
> +	 * The device tells us that it is non-rotational, and we take that to
> +	 * mean there are no moving parts and that the device can handle all
> +	 * the CPUs throwing IO requests at it.
> +	 */
> +	if (blk_queue_nonrot(btp->bt_bdev->bd_disk->queue))
> +		return num_online_cpus();
> +
> +	/*
> +	 * The device has a preferred and minimum IO size that suggest a RAID
> +	 * setup, so infer the number of disks and assume that the parallelism
> +	 * is equal to the disk count.
> +	 */
> +	iomin = bdev_io_min(btp->bt_bdev);
> +	ioopt = bdev_io_opt(btp->bt_bdev);
> +	if (iomin > 0 && ioopt > iomin)
> +		return ioopt / iomin;
> +
> +	/*
> +	 * The device did not indicate that it has any capabilities beyond that
> +	 * of a rotating disk with a single drive head, so we estimate no
> +	 * parallelism at all.
> +	 */
> +	return 1;
> +}

Why is this in xfs_buf.c despite having nothing to do with the buffer
cache?

Also I think we need some sort of manual override in case the guess is
wrong.
