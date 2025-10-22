Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35FE2153ED;
	Wed, 22 Oct 2025 04:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761107057; cv=none; b=DjqmX2vGfbh6TXaUkaP1O8BPmg1mQJQMyLhk9fJ7+AfCiMpyeDptMHM21ak+u+4CGnu3KcrxNuB/e0Jr2Ze9HDXqu25arUK5TfNfaerlqf4Zhv38izcZEEWQGeDdlLWzJvjrpMxvplu1gSsuJ8CtnZ+77VRklrxZo528lYh00Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761107057; c=relaxed/simple;
	bh=bP/7K35dYsa6JnheplL2rVAY4PaGuM/Kl6Q26mkbm0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHNXuVLyIJHFa7R88zRzSicQE7Zlbm+mJnbYplLH4y8Rfy1Z7F4hovaSst+EuOl8NTbdgNj7TN/dY3t2qUZuZNKBjxM/eUiZwUb0vlz28kWwRxOiU/3a1S22dlt9B6K9pHjs1gL/0UwiIcMdvedIws9DZelSQggdVWnExv+fwhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n0oWgQUc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n0oWgQUc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jvWLFBmYaQRFLt29NEjf1KQBxVIPAX/KgnsT5VS8z4A=; b=n0oWgQUc83fRxu1piR/ojKrOT6
	Y4oTOjfGSDmykR3v28tRH0glK+1fbPJMZNs5qzfO2CkEoC08OEXIbuNbwXQ2UIOq/QApXLa+TNqkJ
	7THf6h4a1TnxSe0dq2CzlT/uM6JnS26ax1BQEIIwN9YJAW8YNI7j9F7O9TN43jtWGDZdWf6LE8A6F
	Oy3+JJWa0fuGh90D0woGZbjYdETEIdwhOBcPgOIB+/YIMcfnTi30iwCNu6SYpZ60l6+WI3zV6PgPx
	LVZeKoCVi9E21v8tcHXts62NE02sYCJWrqazirzvCErTH7FqH+pGyl6bPFza4mddNpy+wxAI6md/8
	2jl6X46Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQOU-00000001QRe-1Fgp;
	Wed, 22 Oct 2025 04:24:15 +0000
Date: Tue, 21 Oct 2025 21:24:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] check: collect core dumps from systemd-coredump
Message-ID: <aPhcblEhs-8YXWkB@infradead.org>
References: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
 <176107189073.4164152.3187672168604514761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107189073.4164152.3187672168604514761.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 21, 2025 at 11:42:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On modern RHEL (>=8) and Debian KDE systems, systemd-coredump can be

Only KDE?  Most of my test systems don't have any graphic
environment set up.

Anyway, the changes looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

