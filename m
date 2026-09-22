Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BF23F4DC7;
	Tue, 22 Sep 2026 07:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061503; cv=none; b=kXhaiOC0UHngEkBrl1yqkTSx3ztpmA5bNCwVTagb35TeHOj8potlSRWfYO28h7zhMXA+Dbirl/QWsVqY+nq/5qTiQ810PikShCTLaORdTEOFtFcNN9YZh1582cRMY3MjH8ib+o5vAG8KjzuNw3Jow0qg5O0LdYSDf7qCyzc5Tms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061503; c=relaxed/simple;
	bh=zV6px6e6eGJnuWLCxzVqZ95guKn2916z+9eCrCigL8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmjH9PWbhEu9cpFUjctvaN2vWFFPuUSMqKWxNaFCKnyeB8AFDpgqokBOPqTnijk4erTAX/xQxHxetKrD6vIwHugHf8C+MWPUiLmrMr/2h7bIQ6fstvGgGqP+mjiY2gPNwTOsb2neii9hWYauCImBdVICcO0N8j6yjFYWGVbExko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uGSDq1Yq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uGSDq1Yq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pe/ERqmYRi2QAlziIp0yfm8w1MPUF8QGYr12U1BWtJk=; b=uGSDq1YqsMBNpr8mYK6BJAwp09
	KNTopK36KF1cx0X6vGoaatzYejBcY7nLZZMdRzy2+5cOnbGcIqwcF+gYVh/M8nF/Yu6Rv5TeuMnIj
	JKahf/LdpIJX04/FoHv5rkHUIwjIfHUxntMODRmLeFfe0wM+EURKa/pzAyTvfjQHX6oSFwoyhVib9
	Z3YJbp42BUUPBT2xEtw9qzeCmh0+3bJQE46BXRUVooFLh+SWia5F2fpxSHmALbcscQgSYwLh5BL7w
	M4uDgGA1q2YnhRtk37iF4goUVqMAZQFtOg4xdFBu9bu8EnjoxSEAIfDmHMZhnzGpQtYUv/mzdH90z
	PKudH8jA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ula-00000004UAE-2QP2;
	Tue, 22 Sep 2026 07:18:14 +0000
Date: Tue, 22 Sep 2026 00:18:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, ebiggers@kernel.org,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <arIrtgZ3-9zNuru_@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-13-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 18, 2026 at 01:15:24PM +0200, Andrey Albershteyn wrote:
> +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
> +			fsv_ioend = kmem_cache_zalloc(xfs_fsverity_ioend_cache,
> +					GFP_KERNEL);
> +			if (!fsv_ioend) {

This needs a mempool to be deadlock safe.

> +				iomap_finish_ioends(ioend, -ENOMEM);
> +				return;
> +			}
> +			fsv_ioend->ioend = ioend;
> +			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> +
> +			fsverity_enqueue_verify_work(&fsv_ioend->work);
> +			return;
> +		}
> +
> +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
> +		error = blk_status_to_errno(ioend->io_bio.bi_status);

And I think you always need to do the offload because fsverity can
synchronously read metadata.

