Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60631B87F5;
	Wed, 19 Feb 2025 05:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944791; cv=none; b=TUbKf3TlXNx2xjkvukQAeiGKEVBY8hCk3B3bJFa0NtaTBdu+pVujvUPgP5IS+LInf3hZfJAxYJKO6E01DKd+VcdxXcn9NqYtz2w1QzwUuTaCO3rSbqi15clPbkJnGxzYcz1Hnx3XXb+1TaLhCfDc8PhhNqo/NbLAzestK+X2d0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944791; c=relaxed/simple;
	bh=Uyf8EPj7GvSKtqef+F/3jQeuhrS5Z0+esedXUWAjIMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWFPFtZc8/xJouqaXQpUBxf1tXrDblcWulNevFt7MKA7ClfJ4YZs732BwFgSmyRHaGehv7yjSaIuOuAEkHrzgQmB1IMrfbFCrXtBY7tlwZ1SCyrAsseS62avJDRdcq2r/jzD7FlXUs2G1dVNk7+BUA88cPobxYqVVRjYZLVb6JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LR8aU2qS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LR8aU2qS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7XZA5fBE/bqaEM9fdES9l4HgB0AI8biUQD/z9xflxSY=; b=LR8aU2qSNaPxF3x0ZbVXs7nh7x
	9x4YjDsFdWAsBWmW0/h+vQIKSj6EhZ/+hglnrNsZHUHXEsMptM9nwKg459I3RuJpQQ9W3KGNGHGTJ
	/QRaVn+O1ZwUCENrpoVidFWeo82etwQwn8/lVA4A1L3L1dWdkyvK3UupH/zW0ETN1AnbFrxC6LY6b
	XNDLmlO7CTD2Kh2EQWreCXsZ7wyI2/bxZRlaZdSwnj9gBB3avq0eRQ6/h9xj7+rQQiJHkASjkVG0A
	nE82rgZIJxbdjXrFekYkoirTqDEgBIdjJx+QjH6rRY/0QhewZ5vXrtmeisV9X+bf49BC0N+/Jx/zL
	dxmax2Fw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd7d-0000000AyRy-1pR5;
	Wed, 19 Feb 2025 05:59:49 +0000
Date: Tue, 18 Feb 2025 21:59:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] misc: add xfs_scrub + xfs_repair fuzz tests to the
 scrub and repair groups
Message-ID: <Z7VzVXBPe_bD79j_@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587570.4078254.13226450369679038040.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587570.4078254.13226450369679038040.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:52:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All the tests in the "fuzzers_bothrepair" group test xfs_scrub +
> xfs_repair, so they all should be in the 'scrub' and 'repair' groups.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

