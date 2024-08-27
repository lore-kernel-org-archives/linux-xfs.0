Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D767917993
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724734857; cv=none; b=NMurXnwxOvg8fd4BepXVBCwEe+K3XY5ZInOCUUv7u0ySqU5JMthkfLUPyB8yEcVqol9Uyk8JT1sXXS1b5dUjywxvsEQTXdCrdB8uvjqd7iF6YhbziU9L8HXm8mi77k716YUe0zHCSKwuHMlBWb6C9XJ6gAFLiXGKgCwdJUeFqjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724734857; c=relaxed/simple;
	bh=Yanl68HTcF4Pkprfw8ks7zPDvThFhGQOUtCvDrvnZ78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YS2GF9tkcPZqAFn2kWrlgdF+8By8NSelH4gi/ErELtBz4vdqOmxt541RIW8sGs7WN+ek9Et+Tfgw4EQJEtuycXdWFQZHFvIbT4UbPa4HLWiQdwUlYY8uaJMoZeg7qIlWNuMkPYIUSIe9yupW9o6a3EV6o6oGZbqUHwisbOworN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LskAk9iV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LskAk9iV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tQZVRwwqPJyavRIkdAEYxDBJIY//D88orWn82mARc/M=; b=LskAk9iVF0oZhnUm2uuMACKCDO
	RuSecGFIvUXu7XXe3mPwoee3O39rHqfErRH5DdIUkJ4x4boLprL6d8EMEF0tFB0M4mvKYtrzZYJHZ
	nsXfiUnJTFgs9wpj8OUtFPBVniZSaNstMBY1DNcdKhupd0RdovGeupVMAxeYWxXip5OZv54oyrm2q
	Qhk1n9dZIJblI47aCbS8JLdBiYBCaKYgeXrAY77SfOLbtq0GW39bPjVmynCC9/bqAwNDb9BJXzryl
	2YRgUbnAzemOLOxWXOdUS2TmHmD75dzqYTItf6j/vaUSWkenas1mfKgLksQp8bMuNchft1ZsjMFga
	ETAdCZEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sioK7-00000009nZl-2MDo;
	Tue, 27 Aug 2024 05:00:55 +0000
Date: Mon, 26 Aug 2024 22:00:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <Zs1dh2ywt4Wyv1HG@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
 <ZswLBVOUvwhJZInN@dread.disaster.area>
 <20240826194028.GE865349@frogsfrogsfrogs>
 <Zs0yT0T8fnzQgDI3@dread.disaster.area>
 <20240827021609.GG6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827021609.GG6082@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 07:16:09PM -0700, Darrick J. Wong wrote:
> > Hmmm. Could we initialise it in memory only for !rtg filesystems,
> > and make sure we never write it back via a check in the
> > xfs_sb_to_disk() formatter function?
> 
> Only if the incore sb_rgextents becomes u64, which will then cause the
> incore and ondisk superblock structures not to match anymore.  There's
> probably not much reason to keep them the same anymore.  That said, up
> until recently the metadir patchset actually broke the two apart, but
> then hch and I put things back to reduce our own confusion.

Note that the incore sb really isn't much of a thing.  It's a random
structure that only exists embedded into the XFS mount.  The only
reason we keep adding fields to it is because some of the conversion
functions from/to disk are a mess.  The RT growfs cleanups earlier
in this patchbomb actually take care of a large part of that, so
we should be able to retire it in the not too distant future.

