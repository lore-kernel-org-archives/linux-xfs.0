Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F3967C71
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 13:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709213107; cv=none; b=rBYWD4G30NPOHZv6pJ2/9yK13nYafTP1sotHg2Um+GbrjHf8DMH2lEBr77zTx+tGwTHG5tllg6V6iBgnHamrNR6A5lThU5IExRmrf1jpT4sq1wJxyhm+1S0Poe+Vst80ls98Abw9tf/xaAw8l7aZPDRLpqVk/DfymJ9moY42Hic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709213107; c=relaxed/simple;
	bh=ArbwPHcQYv2I2SDq3Ym1RGAW3+smDVZ1T0VCzhJJK8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEuz5qc0v/klQfzpNd2E74LLyVI0nMYz8OS+7i0+b9X7gn87CVem3GfkIegLBNgNV/eVhKczfdbGKZffr2FoPpCMeVbv1KoKhOMflx779iRhQAnhPimkc8iXXfx/a/kFtrRr16eLYEr4DJ82WAOC8jfEo0BL1lu9WMXTRM13jaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jOM/A4LQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jOM/A4LQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NaZ4f8cBIvfLBYYdWeF5ISNztYke3R9bKVgxXlJSndo=; b=jOM/A4LQZBJ/HOmzOjVrrwJbbn
	pflHiGOV13/pQm4UrdIFg3QZ52Fr/Ii8WdyxxK84eB+iPF9zj0s2zffRAMRZEfS6gV24L8gT1mWcG
	IMnl12R+noZ9/VcXniVjDV6jVLy7GjFb2FbvHR9b2gN728rtUZbjHWfucILOwMQJkvsLRx+riJr7g
	AA7U5W5r4zUnSUA0Y32afYsUkb5VfdFdkBPJCFop+8rOp2ipG3u+GYc+7cgL8+WuXM0BmseX4zC7k
	mar7tUufPvdMRFSash/ETHzOGxv4jnrswuzzO+aHDORVlqgOlH6Q49vT2yxODitFNqUNUbt06yLYE
	d2uoUlKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfgPF-0000000DeTL-2JR6;
	Thu, 29 Feb 2024 13:25:01 +0000
Date: Thu, 29 Feb 2024 05:25:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <ZeCFrUVJ54Grt8qy@infradead.org>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
 <Zd-BHo96SoY4Camr@infradead.org>
 <20240228205213.GS1927156@frogsfrogsfrogs>
 <Zd-vaC5xjJ_YgeD6@infradead.org>
 <20240228234630.GV1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228234630.GV1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 03:46:30PM -0800, Darrick J. Wong wrote:
> If scrub (or the regular verifiers) hit anything, then we end up in
> symlink_repair.c with CORRUPT set.  In this case we set the target to
> DUMMY_TARGET.

Yes.

> If the salvage functions recover fewer bytes than i_disk_size, then
> we'll set the target to DUMMY_TARGET because that could lead to things
> like:
> 
> 0. touch autoexec autoexec@bat
> 1. ln -s 'autoexec@bat' victimlink
> 2. corrupt victimlink by s/@/\0/g' on the target
> 3. repair salvages the target and ends up with 'autoexec'
> 
> Alternately:
> 
> 0. touch autoexec autoexec@bat
> 1. ln -s 'autoexec@bat' victimlink
> 2. corrupt victimlink by incrementing di_size (it's now 13)
> 3. repair salvages the target and ends up with "autoexec@bat\0"
> 
> In both of those cases, something's inconsistent between the buffer
> contents and di_size.

Yes.

> There aren't supposed to be nulls in the target,
> but whatever might have been in that byte originally is long gone.  The
> only thing to do here is replace it with DUMMY_TARGET.
> 
> If salvage recovers more bytes than i_disk_size then we have no idea if
> di_size was broken or not because the target isn't null-terminated.
> In theory the kernel will never do this (because it zeroes the xfs_buf
> contents in xfs_trans_buf_get) but fuzzers could do that.

Now why do we even want to salvage parts of the symlink?  A truncated
symlink generally would cause more harm than just refusing to follow it.
