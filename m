Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C46FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D040223129
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbhASHKS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 02:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbhASHJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:09:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A38C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Drr5x0nHwp2oKbNDAvmnyb4jmnfjzYQXHdvXeVHHIBM=; b=mFT2Tw0jMH1EeLLQe+r8X2aCRz
        F3sm12dNYK37zVfU51fNEnDMJFI4SqXwLZLaQLO/FjJQe9VxyQAyicbq17rrmdePes0QXdrX/vcnq
        Zk0mgiJZNZJ6pa2aQCRIY8XRCP6TKo33ZVmHkh9c2uMblIf8XOi982VYZNfbictlj0TUVbdQKBwK8
        CgdGokCXAFneuB8dzmKcdEMwFEYFzBSj4zKFfPf3dFmsUoy1twlMciJhMgrHZTAhTwDgSpLQh6sUm
        RJzRvyVU8mquiw9WSjn87yQOPEZmpA5u78urTtRcNkqWeFh7Tq1WseJVkW/FOexph18CtvEkJWez1
        ZZeNap2A==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1l8A-00DwSC-5R; Tue, 19 Jan 2021 07:08:48 +0000
Date:   Tue, 19 Jan 2021 08:08:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <YAaFfUxZjXAabnoV@infradead.org>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100795124.88816.6644776235251695171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100795124.88816.6644776235251695171.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -351,13 +351,14 @@ xfs_reflink_allocate_cow(
>  	bool			convert_now)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
>  	xfs_filblks_t		count_fsb = imap->br_blockcount;
> -	struct xfs_trans	*tp;
> -	int			nimaps, error = 0;
> -	bool			found;
>  	xfs_filblks_t		resaligned;
>  	xfs_extlen_t		resblks = 0;
> +	bool			found;
> +	bool			quota_retry = false;
> +	int			nimaps, error = 0;

Any good reason for reshuffling the declarations here?

> +	if (error) {
> +		/* This function must return with the ILOCK held. */
> +		xfs_ilock(ip, *lockmode);
> +		return error;
> +	}

Ugg.

> +	if (error) {
> +		xfs_trans_cancel(*tpp);
> +		*tpp = NULL;
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	}
> +
> +	/* We only allow one retry for EDQUOT/ENOSPC. */
> +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> +		*retry = false;
> +		return error;
> +	}

Id really don't like the semantics where this wrapper unlocks the
ilock.  Keeping all the locking at one layer, which is the callers
makes the code much easier to reason about

> +
> +	/* Try to free some quota for this file's dquots. */
> +	err2 = xfs_blockgc_free_quota(ip, 0, retry);
> +	if (err2)
> +		return err2;
> +	return *retry ? 0 : error;
>  }

Why not have a should_retry helper for the callers and let them call
xfs_blockgc_free_quota?  That is a little more boilerplate code, but
a lot less obsfucated.
