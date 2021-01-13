Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71C9C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E6F23600
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbhAMO7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbhAMO7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 09:59:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53517C061786
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 06:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0r/39prUBzGaYhusSZO9PHuOpeEQ8fyfNH1+zqY5GCw=; b=ro8k7bvm3seWV81kaKKf/lIxKc
        CQT9Haz/W8wI9DTIZI5Gv/oBu3rgX1P9ly6VrbhIqvHQJQ6G17BWpxksG4oMiNxcK2x0+XbD1V91P
        WHRJiRu0jVJjiMBnx7fYhT+EdPXF036UGBsFQdISLxy1yGhAaVk2E9p3lxzn3bjsYFqyh9dmp1Vt5
        9nP7hPV1qDcPcprXH/+FEK7YRW3vua5NMPqCR6C4c0ePSYKZK6tAd9WrRyqP3xk7gPv+kLekGgbLl
        InnchKdtwvIgPoC/BEmuMwyDis4XFyDbAWlXF/njZ2nujzeoQrW6oxTTTAIuBNFeZD1p+C14Volli
        ozlJRQOw==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhaJ-006Nzy-5D; Wed, 13 Jan 2021 14:57:54 +0000
Date:   Wed, 13 Jan 2021 15:57:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <X/8KS4it5LAkN6Xr@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740813.1582286.3253329052236449810.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040740813.1582286.3253329052236449810.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor the part of _free_eofblocks that decides if it's really going
> to truncate post-EOF blocks into a separate helper function.  The
> upcoming deferred inode inactivation patch requires us to be able to
> decide this prior to actual inactivation.  No functionality changes.

Is there any specific reason why the new xfs_has_eofblocks helper is in
xfs_inode.c?  That just makes following the logic a little harder.

> +
> +/*
> + * Decide if this inode have post-EOF blocks.  The caller is responsible
> + * for knowing / caring about the PREALLOC/APPEND flags.
> + */
> +int
> +xfs_has_eofblocks(
> +	struct xfs_inode	*ip,
> +	bool			*has)
> +{
> +	struct xfs_bmbt_irec	imap;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		end_fsb;
> +	xfs_fileoff_t		last_fsb;
> +	xfs_filblks_t		map_len;
> +	int			nimaps;
> +	int			error;
> +
> +	*has = false;
> +	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> +	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> +	if (last_fsb <= end_fsb)
> +		return 0;

Where does this strange magic come from?

> +	map_len = last_fsb - end_fsb;
> +
> +	nimaps = 1;
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	if (error || nimaps == 0)
> +		return error;
> +
> +	*has = imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
> +	return 0;

I think this logic could be simplified at lot by using xfs_iext_lookup
directly. Something like:

	*has = false;

	xfs_ilock(ip, XFS_ILOCK_SHARED);
	if (ip->i_delayed_blks) {
		*has = true;
		goto out_unlock;
	}
	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
		if (error)
			goto out_unlock;
        }
	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
		*has = true;
out_unlock:
	xfs_iunlock(ip, XFS_ILOCK_SHARED);
	return error;
		
