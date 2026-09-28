Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0537A836;
	Mon, 28 Sep 2026 08:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583010; cv=none; b=TsQ7UAYJVJHTz+DB+x0OLtDtgPaNTM6IzvH2YDH3FVAPK1US+RjEsy3GUGLbFICN/u/dNMdCY1d+tqFML5/9AcBDUCCpIlZODy8/5rvDA1oyFGGYgiO8jy/WSkelBm3V51cDRohD92TFYK3rkMOixiA/6AsLR1SdzQMl33HpENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583010; c=relaxed/simple;
	bh=2Jc3KSsoC7Z6P24jDSm8CCz1K4cFWnp3jjRvlGJhEgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4VddX7LzFUBTeVlWnxujKPVGg86tQH6Dlx//We/9lCuFVTaU66p9MwwsZnObAWh8Yni2W0ZX9p6VMZegyWRlt7COu8TIsWMarFTZa05bdV+ZmBEjWh4ZmLtKRnAt/koifuZG5B5sYLGQS5SFkMAYCd1bJTMYe0n6kGiWJEUEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4IFi5jA0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4IFi5jA0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VZgI7Fxbqnz1kTFAB+sDoc9pETt/d1O+dZhfqjMWH8E=; b=4IFi5jA0wKy+QP9Ai5Df0O6Vio
	v0liiyxfyj86kLgrezx/qAeUZY+8GF97pFh+iHHTkeYpZVYQjAF3nubQDuJM+/JygoK5djT/qSIsx
	Tzp89HxKIx+T0YpvUTeocoNuSo0O2KH5f63hn0cYbe4lgtVvJbfD+MoTDt/JoLsCOJDieIJ+vBggD
	FkgbW6rlfd1gSVY0wZUc0b7sV6quwe3Do+nrbYZUx31a2O3Na7RyEaeGuIpa4xyQqldtPe8Nk0sjL
	sh8xFnpLJMEtTwLoGc9JuhiQR3vcGa5bvYMHKe+oBdRkJLcONLISSbl9Nlc6imqtxhD4L7FT4SHs+
	7UCSSmhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6R6-00000000212-2UbG;
	Mon, 28 Sep 2026 08:10:08 +0000
Date: Mon, 28 Sep 2026 01:10:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: fix skipped inode mask handling in iscan
Message-ID: <arog4KcPtXlRAhV_@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612809.479634.4326694692538999212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612809.479634.4326694692538999212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:18:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_highbit64() returns -1 if none of the bits in its argument are set.
> In this particular callsite, a totally zeroed mask means that no inodes
> were skipped, so executing the if-body is incorrect.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

