Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2F94848AA;
	Thu,  8 Oct 2026 11:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460474; cv=none; b=l7xd0GMO5/9MDcXr3zZeSGpwDh8W02bWUY3LFn+C6d56tICYNXupvf26i9dP1gyVIhKzekhY2lfpVSmdcl2IM6l3f5wiADOYgpJcYxrPlWHPrgjgyXYXxNNi8GukCfbcgiwXAtDGCXTHaO/wv3DjRIcCNDImB2vgR8Rdw6x4WTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460474; c=relaxed/simple;
	bh=1hiZOH/po//qHGQrAW+4ZtdJwczCK1Noxr1zSw/ewpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npqiBrNpF+JZ4o4Qbj7wJuR1RTaBYH9GC/6IRN89h5j6qbs8mva7IwKaKHHWLrVUR2Zzo1lG/Ux/G+SrtNmq04jjV021wDxMkbfGq3yyceB1g5uy4WdaSfb8Q7co+1LULIVUfNL48DdvmVjeQdEBHT92zGq6C5yoeum69/6IQ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Edmwjy7k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Edmwjy7k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SR2NWW12K+p9EijUEHPYpuEoQTjw7gllOM5HvQGQtds=; b=Edmwjy7kD3xytAsJhACH4Fczzg
	/RR6Cz1FjESRvKdlCjoruPXhTICoIAtppeR3pf+hbli0kxfm1JE629j2K+i/GPJfY81YHJtyHIPCi
	NpFpjp166CtjmFKWtLxmtOt8valyUsoguH9jLwQm7/J3blm8s7pAygVf32P9dRIdGy/0iMw89gnYm
	zN+tICv3mAiu4qE2SAHiyHvpphwoTKRSRPb4qFsByc3CAd+BnunhPjT8fEBkRlqk2GpLB9Mej+bb/
	sAROqdHSjs5ChZ0go0+Hv3tT+0evFKl+oMrYK+vZq6UOxh9rm5zQBv0RM6/IrpxSXWQH2hMXiYGkB
	uTRzTE6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmhj-00000004IKj-2iWF;
	Thu, 08 Oct 2026 11:54:31 +0000
Date: Thu, 8 Oct 2026 04:54:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: abort directory tree repair whenever
 dl->aborted is set
Message-ID: <aseEd0r8KTEi6s4_@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521320.2728617.14446583476479033597.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521320.2728617.14446583476479033597.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:55:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observed that if the live update hooks for the directory tree
> repair code ever fail, they'll set dl->aborted, but then the main repair
> code path won't check it to exit early.  This can cause incorrect
> repairs, so let's check for hook errors and abort the repair.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

