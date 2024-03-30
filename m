Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531601C0DE5;
	Sat, 30 Mar 2024 05:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711777192; cv=none; b=rUivYEGhp81Miw3jQLqxbGpADfB7MpsnTnwrLw3wOvxJm18S5ixasMDpi85x8TjGJR18nxs8HhOQH9F0hGzAhDYbl1FTRTZG1eMIkz9EzYkqU4HI63Q/ozPWARbE8uoAAD6udChla4Y4I+5Sf97Rbq/3zhuY+2I8W4srUVXXC44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711777192; c=relaxed/simple;
	bh=G+CO8/z90R3TvW7IaXWxZGUA9Bo9GWW3e1lvPvBjTEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iI5HcaWg3jutbcgc303mZn9KCyVgPKg9YTAt7Phx3O8GhE23mmU86HMjx7dhAt+CvsQHeLfQNgpfRXXO57tQMD4IXI6NhkxfIktzerIw27sY3m7/JNkQ51fHbKponWDM6nryfIVd6yR9lUouR0AU9c8gAEhZjrlrKfSILAlZU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rD9tpJIY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rD9tpJIY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MmsuwzixfHkgPNEleoQN2h0ku7uhrLBhFoUvdkCoQSM=; b=rD9tpJIYFvDT7PTB43RvhLW50m
	shqmlhccVFGa/5BCdGIlePs7HBSKan+bAwaTJBvUUzcqEXUY6ROQNA/LJqm8uIMm/Z6Q5IYi+0m4K
	0RgPiZiejVHCcrjFNoWtd9np/aQBKyip83XHPQT65romhmS7LltU2gPgDVDNfFOvVvePnWy+ykAMU
	muDlR9eb7NsdwM+QtegxSFTKXzvZWN8SrEyfdoOEuaZ2QiSuk/HutD9IKMra9QnNvvU5C7Wbolhlr
	CeMw53EjFu9hL9Xj8BeLP0Hsgjc8dl4eV7iLLGuxl6P79SkD8w7FvH0VLcun5prz2FOOzo26y/Fzy
	3UFx3Dug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rqRRU-00000002qnp-1jCp;
	Sat, 30 Mar 2024 05:39:48 +0000
Date: Fri, 29 Mar 2024 22:39:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/4] generic/{166,167,333,334,671}: actually fill the
 filesystem with snapshots
Message-ID: <ZgelpI4W_e6NyyTA@infradead.org>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150741593.3286541.18115194618541313905.stgit@frogsfrogsfrogs>
 <ZgRQYV_uc94IImTk@infradead.org>
 <20240329230720.GE6379@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329230720.GE6379@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 29, 2024 at 04:07:20PM -0700, Darrick J. Wong wrote:
> Hmm.  Well my initial thought was that the snapshot could fall back to
> buffered copies of file1 so that we wouldn't abort the test well before
> actually filling up the filesystem.

Btw, can we please stop sing snaphot in the test description for
reflink copies?  That's a really confusing term to use in this context..

> But you're right that my solution smells off -- we want to test reflink
> dealing with ENOSPC.  Perhaps the right thing to do is to truncate and
> rewrite file1 after a _cp_reflink fails, so that the next time through
> the loop we'll be reflinking extents from a (probably less full) AG.

That does sound better.

