Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A0D3613E;
	Sat, 27 Apr 2024 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714197407; cv=none; b=gJ+2zJzQQ6gXllyQW19VMX7iayYIsarAH7lUDqKmSYWNkl+5hO1PPpHKC6TVvkFn79inBjAwIujjSgFyyxL6/nciuzx3m6jx635FvAeFv0zRHy9HWrxIGlPMFGa5UQA/zh6+sIX4Ju4ZBbgAXjwkZpE5VbMDJ17aAVMCNfLyfD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714197407; c=relaxed/simple;
	bh=ifCmRoCuifRwOAn8KyOhJeBAIlHoij5W1CclBwYKMGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0kUXaohg6NDWDziOgkp9AENTXWUvFg4vi6qS8ktAfQHnK5l9qA/cnHTXf9ZvD+/9W3u88STcLTy2IqszhVwjrlIvFwDJsJgTr4IeBGANoO8ZuKYw0quHrA+4Kzx4Eq4lnhkcK3HUQjy93soNw5g8R2IIfIa5j+CiPHGUjA4XiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s+09236g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s+09236g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=493wgnpOJqFydWUTV4V/S2Y8tTPRxpsJi/rxEz2QTo0=; b=s+09236gFo5oebAofXuiWPelY5
	7DRn5a2tgg1n0LpSJ/Y/SH6rwNlMCzISERqDUG4QJCZ+SFKfrAyciMyNnV6Lp4HVr/ZX9tkemaIH8
	UOVfPxeafT95TpmYxKa1+zZUMOXpdYuqUWlxXiGGD4LTWtgn6PRziE6msCuXR3NrEy3hRgodCq25U
	vT33BFgzQXPCGnbtbBdg6UCjaPLWINc0TabFbZUEUWnLjiqpSV75l7eW6+7xhYfT83dErSqdaEeym
	oUVnIc4Fl0XAHdWaeZ+ZugoWtWfTwzjDK1sMW/uxO0rzXfKyE3d8ReQYxb9wY/nfJhut/EdNmoUVL
	P3H5wsEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0b3F-0000000Eva8-1Kn2;
	Sat, 27 Apr 2024 05:56:45 +0000
Date: Fri, 26 Apr 2024 22:56:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Disseldorp <ddiss@suse.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/config: export TEST_DEV for mkfs.xfs
Message-ID: <ZiyTneFh5GWM6Rs_@infradead.org>
References: <20240411063234.30110-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411063234.30110-1-ddiss@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 11, 2024 at 04:32:33PM +1000, David Disseldorp wrote:
> As of xfsprogs commit 6e0ed3d1 ("mkfs: stop allowing tiny filesystems")
> attempts to create XFS filesystems sized under 300M fail, unless
> TEST_DIR, TEST_DEV and QA_CHECK_FS environment variables are exported
> (or a --unsupported mkfs parameter is provided).
> 
> TEST_DIR and QA_CHECK_FS are already exported, while TEST_DEV may only
> be locally set if provided via e.g. configs/$HOSTNAME.config. Explicitly
> export TEST_DEV to ensure that tests which call _scratch_mkfs_sized()
> with an fssize under 300M run normally.

As for fixing the immediate problem this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But adding the xfs list as allowing to create a smaller than supported
file system just for testing is pretty silly.  If we don't want to
support these tiny file systems, we should also not use them for
testing.  The best way to port over the existing tests to a larger
size would probably be to round up the size to the minimum supported
one and then fill the space?

