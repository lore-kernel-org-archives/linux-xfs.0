Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F33DC87B
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933803; cv=none; b=b714tlqAAf2I7ur83cCJRkFCZgfL0rk/xV1hakGBVaYnMfS6RJhhbndGngFDtZUHQBCkAFre54CH4t3cerawRtoUh2hf36R/vtpPUTglcV3cnY4GSYapv0S2xkVPy0AUm8uEl73LBxApELo/yB6HzPUlStznj5hr0iKtqCf2v8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933803; c=relaxed/simple;
	bh=C8ghdGKJ2JjHqQqb9RwsPCWc1lQMbtS+BHnsGY6udZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ae/jvErOODERd/CQwO6xtM/rxfjYgSsa+SAwnq600wwgE7oQrSbRZEdIZzZWXMOLr8X92ycG9J60k4BqZHfJagB4Yst4g4X/74DyisYGF64oxiwnJ+NifPOVSJqcwOd+J2WdaGY8bNiDiJK0A2yiaOA55LlbtKYrddY5Y6qpu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S/9fJLBv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S/9fJLBv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w0BRU2C8dXoYwmdTAAgaYStznuJjgJi5hHy7fcaJIZg=; b=S/9fJLBv1R7kh2LxK9/2darpLP
	8H/fn6cj+t7WB4YaykgShwR4DvyyhxoLA1tYkrIx2y56ekrZHelGPHneUegH7/bgikiOX6PP1y88z
	HMrQ/S/xFsm4CX5e+VlRqRobi1OSaJjr7e+l3m2QkWLGoxcpg83Mr5/UP2w0LoZ5QR881RSp58eYc
	2DA/yBHI4AMLq9WlThXUM6BWWAhyB0d0GsF8/YwQwC0z2NrFec4KKcl3RtlzjCowYtFyILIRz9kPo
	sSP61ArU+pospvmmRzLF0bKl9FSE99BFlh2YZUC7O1kFdY+7ufZerSQta3Hf0DY7q2eCPG3P19zEc
	XxHwytwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCfo-00000008fo6-3B0G;
	Mon, 13 Jul 2026 09:10:00 +0000
Date: Mon, 13 Jul 2026 02:10:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Manognya Singuru <msinguru@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@redhat.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2] mdrestore: fix extent length overflow in v2 restore
 path
Message-ID: <alSraBI2E3YwS6ZK@infradead.org>
References: <20260713061808.22518-1-msinguru@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713061808.22518-1-msinguru@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 11:48:08AM +0530, Manognya Singuru wrote:
> Aisle Research reported that a crafted metadump v2 extent
> length can overflow the signed int used for length,
> leading to incorrect size calculations and a
> potential heap buffer over-read in restore_meta_extent().
> 
> Change the length type to uint64_t and ensure all size
> arithmetic in 64-bit before converting to size_t for I/O
> calls.

Looks good, although you can use up all 73 characters for the commit
log..

Reviewed-by: Christoph Hellwig <hch@lst.de>
