Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A11400E1A;
	Tue, 15 Sep 2026 06:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455367; cv=none; b=WtPVHr2kAVY0ZG+o1gSzOz1Vx27qeCWWFuCaVjsTCqIWjREwXuqo9cN7Orgpj+0JGZJJFen9anfs9ZaxVrFYcQEnaTRnFHqca4JcIbQAsh7MLvaWBNxiIKsSMUXrWHtLssmGXg2zuhmXJlKaoJ3p9Feh1r94+eSqg6YCOZmsRzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455367; c=relaxed/simple;
	bh=8IdLlPXvoe31kO6jKmCMqgiDXCZ5lM0ZDO9Hn1L/k7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OuKbS64DDGpajg8BDbwfqz4bYl/1HhITyQUNI9XSuOuq5L5PzLThvZs/Q7LvK84PilGrmGPbhmAdMzzNvka/0vGACCOYGw1k7RSmsup2Lzrn47lkK+Vh3R3ofAGhF2AKAEgVZZWrvAyv3Jrl2WHLvgvEofuhilDSSLBehAee4Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ztwZ5NKQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ztwZ5NKQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AY83ECO/YDlPLhw6AJgiaR/IIzS36P8IDca1RoNPMsI=; b=ztwZ5NKQmPq7CMbG9KCDQbCKFo
	PMfaei3Q/Scd4P2NIHEHR/4xon9ChquFI6c3Nj3eqHhOSmCkRgmTEnLejD83p/TEMHqKBblLuDHLL
	h4C0vi6/qu4nxjNsW0vEtc+r2FTXRz1fI352uv3kyR4BenZMDpyOH32+wFgCR73DHl+hQq8n1ehSx
	7LGu4jkwyJ3Ix5pfzIm2KzkBn2OrZLqpd0akBSMK8YBgrZrZ0YEl5Rk5JArdl+I5PEKR9PdJAkkXp
	t49e5ZUz+3G4j1IQxQUauSXxkO1x8LxkknbHRYkDHMM+7Aa+34J9NCOFr9oLxPKknBV9ro6PlUZEQ
	Z0Gqn/0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6N5K-00000005Osr-0ay1;
	Tue, 15 Sep 2026 06:56:06 +0000
Date: Mon, 14 Sep 2026 23:56:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 1/5] fstests: consolidate _require_fs_sysfs and
 _require_fs_sysfs_attr
Message-ID: <aqjsBs6QUtIukk05@infradead.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
 <20260914172509.3799016-2-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914172509.3799016-2-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 15, 2026 at 01:25:05AM +0800, Zorro Lang wrote:
> There is heavy overlap between _require_fs_sysfs and
> _require_fs_sysfs_attr, and their ambiguous names make it difficult
> to tell them apart.
> 
> So merge them into a single function with "_dev_" included in the
> name to distinguish per-device entries from other paths like
> /sys/fs/$FSTYP/features/.

I have a bit of a hard time understanding this message.  From looking
at the diff this seems to:

 - rename _has_fs_sysfs_attr to _has_fs_sysfs_dev_attr
 - rename _get_fs_sysfs_attr to _get_fs_sysfs_dev_attr
 - rename _set_fs_sysfs_attr to _set_fs_sysfs_dev_attr
 - rename _require_fs_sysfs_attr to _require_fs_sysfs_dev_attr
 - remove _require_fs_sysfs

right?  Maybe spell that out and split the pure renames from code
removal?
