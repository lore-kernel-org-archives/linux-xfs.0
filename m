Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E128351C20;
	Tue, 15 Sep 2026 06:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453522; cv=none; b=NTozS0x5f3JwtgFCR+LdRIbULoHHgl/2MwmEEcBVSwNXXAqoiTW4VGZpyLgBeMBiYXqFmNLH8PDlUP54no5Aq2QryN/fiUs6ZczhXwrJQvllnfOeZshUAJWttO/X3mMNi5VfM/jUl4ya/kU2si0BibwYumrqQCeB5nPXVTuk8d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453522; c=relaxed/simple;
	bh=UaLL7E8exdKkDGIKN5bJ+zF+vWOQ/w3PoxG2NF1d3dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F17feV8Vi/3REr9v4+58DKDoCEzFjLCJJNUb93K7eSAjrAhB9bbPkn/DgTgRYtJZdpbsmu/Lb11DyA7PhHj+iNz+KBMXowhRe6/gRioODADlZKcD7Bg4t+pLYLpQpr13b3UMQ5RTnTjfT3n480mBZF/PFRKoW4nu0lYxYq9Tugs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AHDWeyxJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AHDWeyxJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9ehzz/wfXd/1cWI7Md2WGXkhf6JVZJJR+sQLls9I0eE=; b=AHDWeyxJNCoytIdMAnYg8diZXA
	vssDI5zr9x6AVMe5AuHXG7VF9GdGPOJK0kCA0CvPQDXT2cVxscyaLrkCZhHeJPFpv6rj9TyZOLSKn
	Kf2378bjKDLzA8RdRhmkR/32uHgAOMHeG2sspQuJVHsKPrn8zF6SYiRo4uQah5rt1TOU3sllOS86f
	X6umuMsmKnYrf7hMH2K1ujnBW8N97ubqiM1N7tNQNjoEpm+ghEPil8MQXkaClIK/8BwIsCHGu+PIJ
	SIYP6z7mSKiW84+X0PcdT0Ki7r5UrjVp2Zi1mbZleLlVfrz6dSr/mbXxDri2a+0lDwIB0l3VJgpzy
	sV/HL1Rw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MbU-00000005LHZ-0PsC;
	Tue, 15 Sep 2026 06:25:16 +0000
Date: Mon, 14 Sep 2026 23:25:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: always call xfs_qm_adjust_dqlimits during
 quotacheck repair
Message-ID: <aqjkzGLzYfjrWI3Q@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048522.3061055.5283654279910692050.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048522.3061055.5283654279910692050.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 14, 2026 at 10:36:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that everywhere else in the kernel, a call to
> xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
> In particular, mount-time quotacheck does this.
> 
> Looking at xfs_qm_adjust_dqlimits, that function is in charge of
> conveying default limits to a dquot if that dquot's limits have been
> zeroed.  That's quite possible in a repair, so let's follow what
> everyone else does and set it.  This requires us to add a new predicate
> to decide if xfs_qm_adjust_dqlimits is likely to reset any of the
> dquot's limits, and to set the dirty flag to true if so.

I'd vote for merging the two functions as they clearly always should
be called together instead.

> A different LOLLM noticed that we have no way to force xchk_commit_dquot
> to call xfs_qm_adjust_dqtimers, so pack that in at the same time.

This feels completely unrelated, and could also use a much more
detailed explanation why we'd want that.

