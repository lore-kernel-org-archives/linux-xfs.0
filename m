Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA12C3524A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D242D20674
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oJKdR3w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgBDGTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:19:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgBDGTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 01:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BciDLkRKARHMhytHIYBdBLB/IGNWzUR/qb2TldorBJo=; b=oJKdR3w9D+eDqSMLoYHAPiICVu
        z8YzvuRNeq0+RLrHIrusHsKj7UCCatajw+bvbDQEgwC2sYhrSZhSU0j5HwP2q2Su3IN6ED/LTbTkG
        XrxbjBlOEu0otITDvQ/KY4nEjERJeq9rEIUvvD76/P0LH0+5YV9lxSkePooQzZWbiVeQqHc5Efwyb
        hLvfpHcc516Ty69s5oSHY7bIEqd4Nl+lVJpMS9Sz3RgCDRaFQZk2YUkXZ/znB4ia1xbgqdbBccKEo
        g3ur4phssWV0LZw9FK7QPtzBVt+Y3Kedgr4FotSaIAROVw31W6u4tRUR1bV2t0qqjvoRT42d7Ht4X
        VWtTbz9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyrYP-0003ZV-Pa; Tue, 04 Feb 2020 06:19:21 +0000
Date:   Mon, 3 Feb 2020 22:19:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 1/7] xfs: Add xfs_is_{i,io,mmap}locked functions
Message-ID: <20200204061921.GA2910@infradead.org>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203175850.171689-2-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static inline bool
> +__xfs_is_ilocked(
> +	struct rw_semaphore	*rwsem,
> +	bool			shared,
> +	bool			excl)

This calling conventions seems odd.  In other places like
lockdep we just have a bool excl.  This means we might get a false
positive when the lock is held exclusive but only shared is asserted,
but given that the low-level helpers can't give better information
that isn't going to hurt.

Also I'd name this function xfs_rwsem_is_locked, as there is nothing
inode specific here.

I also agree that this function needs good comments explaining the
rationale.

> +bool
> +xfs_is_ilocked(
> +	struct xfs_inode	*ip,
> +	int			lock_flags)
> +{
> +	return __xfs_is_ilocked(&ip->i_lock.mr_lock,
> +			(lock_flags & XFS_ILOCK_SHARED),
> +			(lock_flags & XFS_ILOCK_EXCL));
> +}
> +
> +bool
> +xfs_is_mmaplocked(
> +	struct xfs_inode	*ip,
> +	int			lock_flags)
> +{
> +	return __xfs_is_ilocked(&ip->i_mmaplock.mr_lock,
> +			(lock_flags & XFS_MMAPLOCK_SHARED),
> +			(lock_flags & XFS_MMAPLOCK_EXCL));
> +}
> +
> +bool
> +xfs_is_iolocked(
> +	struct xfs_inode	*ip,
> +	int			lock_flags)
> +{
> +	return __xfs_is_ilocked(&VFS_I(ip)->i_rwsem,
> +			(lock_flags & XFS_IOLOCK_SHARED),
> +			(lock_flags & XFS_IOLOCK_EXCL));
> +}
>  #endif

What is the benefit of these helpers?  xfs_isilocked can just
call __xfs_is_ilocked / xfs_rwsem_is_locked directly.
