Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926251BC094;
	Wed, 19 Feb 2025 06:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944859; cv=none; b=Wu46QXu4GoiiDqScII1gUW61K3imrZXExHl62XJcy+rfyZX4x4gw8NtIc9KQtnNoSTE4XYQ9bkaTaA5XADhqvRncEnAUceFrctixB+DRGGYFcs6oezLGeJy88lvgi5kFOt513wVM+Yp2yc1awcKMcd8c5v8vt+v50KSI3owtZiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944859; c=relaxed/simple;
	bh=WiJBmEnEcvY48CAMZpuSS/iCMDRP7Y8TRUie+FGCx38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdhAZQpJ3RT6XaUx4spmQJ8y2F2lVYd05h+rMDKCNneFcRjU4KtrvpOkt8VV4FsRvih90GfFPDzJjHRzaUcEApt90+uiyFWpyRSNYydtMej3ObtvQfGAPD+7iln6awiUX+QkiSKNw1ArL+wI19frz/SBmC8VRNf+xD6iYzGTbgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mOlISgQR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mOlISgQR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=enndT7hYp+vMCCl7+qOBjYeGcmLTLIp3XBeH/GQrVtE=; b=mOlISgQRjJvwG6QAiuhMujZDMj
	HUw971paOEioJG+665zJGk+yFnpWCB53CZgT9Fa7VFBeti6qJGB697eUksz1eh3ydDm9xtMN7zoWh
	8CPoIy1ml/9HU9iP9p41Y9d65pdtZHWtnHEqk1rxJoXehvFheu/iCgNWaBzVVOOYNeOZEF7AGsOXw
	BYzWiZ8E5lItXih4rj/xxhLEDU6BR8ida9O37lFFjGYK2/lC85p8HxppAtDCLBQB291IgY/AAC22f
	Lyp9WNpfwMfQaBCtzzRMz+NAmszY4FjM5VQNCMofx8U6EB4J9UBBP2z3kQyQ6Kt5NZ2Pi3tmUjEwT
	/2iC9efA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd8j-0000000Ayh1-3qNF;
	Wed, 19 Feb 2025 06:00:57 +0000
Date: Tue, 18 Feb 2025 22:00:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs/28[56],xfs/56[56]: add to the auto group
Message-ID: <Z7VzmdxUtQcNcgzS@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587607.4078254.10572528213509901449.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587607.4078254.10572528213509901449.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:53:11PM -0800, Darrick J. Wong wrote:
> fsstress tests and two fsx tests to the auto group.  At this time I
> don't have any plans to do the same for the other scrub stress tests.

Can you explain why only these four?

