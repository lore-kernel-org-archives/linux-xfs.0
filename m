Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CE735C1B6
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738864; cv=none; b=U7NRU8B5PzuNwoQbGji1xyrgQXUeotPwPoDr7ojAtSPNjRv2OawOSD5Ee05ThXweU8RDaem7elYdU/ihbUhiCp80DhK6nSo/Ehg88Yf/qYHSVsrJAYnfZozq+OiJkjOK+GD2kl450r+8JaTyBXSykM5OUGBr+Dw8PD3fcLu5TzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738864; c=relaxed/simple;
	bh=5709YY+hJ6gX5zTbaK54sshTSwE0dffY0fBVwpNX6Yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdEl0ZDqKLyQ1+kvg3F+NNYHrZEkqT25cG3YLW/U9KBYfdPHsnWZPqYjRv4UvH+zI1uuVh+2LJ/CE1MhgpxzzCGkWdc07QyRQewIhvT58DwRtoX4EkLbyYTijNK9usLMMv+qwnC3JoWxViqVWBfBXdEM8MUpfc8ED2hn9fKLY7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mCSn0hZv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mCSn0hZv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MKSdayatIySGMLKiVIMZzYBqziRY0HJN7OQBTC/DoOU=; b=mCSn0hZvcznVshTqiBdSx6iLc/
	lcHiKYzyFXWIdCPzQWpeySepAU+RB1umvDMzj0LQopxlxdrL0GWsMGQnt7Jr/HeqgUx5XlaIJV/+3
	+bGew+89d1CkLvXiJJvV/QpWZjCaEUr1+soQQ/ZSkADMQ92GqjpuwgNr3iGMGEyIrMSlXNsqbyqZL
	TxdrgoZNqVOckEIXQOl+a1Pj3m2+atn5coG+Q9aBQsw0bbKH8Dj3h6v0Y7xN82dzv8KGuEmT+TseD
	jrKRhp6HurOg8qFVjhOIS46BuvQIfYFmQbHqMHRVDOyYiw7C1f3VtUbxSgCXhXMTnY8V5E+Le61bm
	WdWOZUdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2QVK-00000005p9n-1fnT;
	Tue, 17 Mar 2026 09:14:22 +0000
Date: Tue, 17 Mar 2026 02:14:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>, hch@infradead.org,
	ravising@redhat.com, leo.lilong@huawei.com
Subject: Re: [PATCH] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
Message-ID: <abkbbpJ9sI_SDhfP@infradead.org>
References: <20260316225033.GP6069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316225033.GP6069@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 16, 2026 at 03:50:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's far too drastic to delete the entire attr fork because doing that
> destroys things like security labels.  The kernel won't show incomplete
> attrs so it's not a big deal.

This sounds a bit lax.  Incomplete attributes are very much expected
given how the non-logged attr code works.  Maybe reword this a bit to
not make it sound like we just ignore a problem?

