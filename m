Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C91140E30;
	Mon,  5 May 2025 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746423430; cv=none; b=PM7A0c8JhYV+jVaW/IgUaPQZWEhwZBO/4lV20bFV5pprqTuubrKMWFAhDNreyM6c4HxQELDdxT+L3Scax2rPgdPJH3RcS795cdtE/6NF+P5B5cW9AC9YBdNtbwqq9gF/bUiwwhN47b0d68UYgThD62gcM68N44bDOqC18RGOtM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746423430; c=relaxed/simple;
	bh=kBBO8xM1m0xiDY+ATVZzvUxw52r+3Af7/qxmy7Ue1t8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcZjJ02pTFq5dA2J5LU3m2NJRWUPHqVJ9W7PuOy8RsxoLWdiNunzIPloHuaxz+pz4Xpeh1fHVY5lJ+KPqsX6IHx0dT0gJRNYTdkKW9LCflNYjw2rlKii7Ds92ssxnQ1h2AcaqC+H4ucaMqLQejk//24IRj1Y4Le6bc2VUMiDjvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m3COmVJ6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m3COmVJ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NWzlsEkfRx1oiyZRAMyy2S2MG1ERVHQEuyv1wUN0Hc8=; b=m3COmVJ61p3aCZMSSXv8FL//le
	x1A2Nn3so4zzwxTC/WKqhJQs2wyHTvA2IWT4fewjjl08Oqaw4JSR0m/YTD2omiPoOn3LMVB29dPyT
	fDwmk+UtY//WyzCX+CrbJo/xj/luNVV9es5HVdVNXUe097oz9phbQ4TRpmBx8kl57cwSXQOuhIYVa
	puRRGyt8iODPeTA0ZqO/4vUIhGojdecRcl34JXzUqHgF0fNQl7viaLLBbSBaxW24mOGIFp0pwpJzy
	B3DlwxWeYRva9z5lwdz3LW6h9qxiKycvrQ7sx2o4gthcaBFZNTUJYjYOBbilBq+wR4NUMrjqBB9V/
	JQuxWGpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBoVn-00000006S5z-0Xhp;
	Mon, 05 May 2025 05:37:07 +0000
Date: Sun, 4 May 2025 22:37:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
Message-ID: <aBhOg_jB4DWSz1A4@infradead.org>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
 <aBRwTFxik14x-hyX@infradead.org>
 <20250502193942.GP25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502193942.GP25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 02, 2025 at 12:39:42PM -0700, Darrick J. Wong wrote:
> Me neither.  We can't write 512b blocks to the rt device obviously, but
> I think the whole point of the separate "sector" size is that's the
> maximum size that the fs knows it can write to the device without
> tearing.

The sector size is really the minimum addressable unit.

> Maybe there's a way out of this: the only metadata on the realtime
> volume is the rt superblock, whose size is a full fsblock.  Perhaps we
> could set/validate the block size of the rt dev with the fsblock size
> instead?

We still allow subsector dio to the rt device, so this would be a bit
of a sketchy change.

