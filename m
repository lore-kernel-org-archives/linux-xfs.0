Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03429B764;
	Mon, 15 Jun 2026 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530389; cv=none; b=fqpzqH8wgwF/bmBDJm3c0nHobClK1Bz9diAuny/NCsUDAGtIYhGT7kFInAPwesUbJeBAFReClwbMoyQPKIr4DRnJ6GmI75Jp2eJkodqmEEbJbRfCRhcQFafK+qrMs5w9GHKwg/doN0NzaDjcRMVi8OtIGRj5wrd2bBPjra91B2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530389; c=relaxed/simple;
	bh=Z2E0wxAL4iHaecn7IK4v2WLKJZ2WM/POSrbE9RezUds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sL1CBvt/FAlcg2N2nMhIjbnNqEwB/FvQliTw0mpu1Kv6lEtGQPEnH7jNaaai5Ef5BF78uWuqWMFkZKLpJgf7PdmhpGF+J1j4Pr/UGLmgN6Rls95F8fK6ytf17TurCSpzbDwvHmNDDGwYX4yAAgKQMaeIF/1ItI8ORRoZzfrZps8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3TglS3Lz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3TglS3Lz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vryDBMKqci5XgJtP3AQKzkH29Uo1eWQHC5xKZUX8mkc=; b=3TglS3LzzyOHGJiDybG1dhiAld
	mk1emNpc5eEKTUZWP7DPV5jzwMIsK6LGrXp1Ye5up/DBXojSMb5xEtrtO+tOPSF0m0Q+mpaeFlxpi
	lxTM5wNCh5ZE0Qb9FvfWtfgA3VSD7vrkPbrOD9elVkEbWThFVztB0ooFJQHA+fzFoLMeKfW3lTkpZ
	LSU3N3xlWVtHbFHT0YnvP2JYYxbhI99NB9lcBQ5E574FjFJlQLY6GuQ7+Rsiy2lUuXNAXW70NdhwN
	ZUicFR3DZ2B94r3VRgKoEPmz37DTO6riaPZXOr5lYc9uYnm2xu2S+5gC8MphfBiVvLDboTm6LLFDi
	DaIN3kqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZ7Qw-0000000EJHa-2CEe;
	Mon, 15 Jun 2026 13:32:58 +0000
Date: Mon, 15 Jun 2026 06:32:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Yao Sang <sangyao@kylinos.cn>, djwong@kernel.org,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: shut down zoned file systems on writeback errors
Message-ID: <ai__CtK_5RI3hya2@infradead.org>
References: <20260612024430.253758-1-sangyao@kylinos.cn>
 <178125341409.29986.5501338776712506668.b4-ty@b4>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178125341409.29986.5501338776712506668.b4-ty@b4>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FYI, this causes errors in generic/441 and xfs/665.  In generic/441
the file system get shut down now before the error could be propagated
to fsync, and similarly for xfs/656 the file system gets shutdown
before reporting fserror events.  In both cases the behavior makes
sense when a file system is not intended to survive data write errors.
I guess we need to introduce some way to check if a given file system
config will shut down on errors?

