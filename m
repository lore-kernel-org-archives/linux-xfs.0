Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8551BC066
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722440601; cv=none; b=UgvGHwhQHESYBEhe3K1hfwDpVSU7VZ7m865dUD+iNY0DysbY+3s+tYoPNRoFNYdMdhDuUDa97NwrqubOwfgXs9715zr5EGh/hbk53XfNLZKbdbE0SNuCgfssH7nnKPGjOJx/N+8JvcrF6bxEGBBEKsUyhK/f+zs5OXoyZhqzuf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722440601; c=relaxed/simple;
	bh=ByWoJd5cTO1aUEZycv17+6f0CBhjK2wGvoe5IVcR3vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCbLbzWIaf24SI0KHxri3OLUkxHkdnintovOfvwUmI/1T+9ze877LQPUrYU/VdfMb0RyTr8/oOpxgg9fcejTNbf3RS1IW9uAt8WuH46qwWH2d9WFwK6xfskegGaB133PYskpRzBDGy6fSKUyhhav6t7wIVxrXmr0qOaRCvBkqew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mAp3fXLT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mAp3fXLT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wq27gLoSJeV7eR0OLfYsuHwDl2boeekTME1MOs6WQpM=; b=mAp3fXLT10VO0lwRc68Krx7ZT8
	LnbB1vi16uV1ozzEZF6AeFZIgk73wEvKhSqJZ2v9aJ2pxD/DLvUuAEyozX8rXvMCakHaIViROO0tK
	TQINp4nD0y4AuKayRwd7+QTTBHrGLqUAs+XI1BLIdxNDJxZW2XQFwZT95V7zfXdvp4kvJyS1YiNB2
	ipd3bEDT0S0A84fS+ypAnNWWaPNXF/m0Vh7fDVh9XPUzUUWUSdcTUO+FFcD8MwATXJjh9eHnek9n2
	LKf+aOKMv3w3OQYLdzFTuQQUWWpeKRByNhBRNkzLC8vL3AvzU4xUi2WozeSV675X/yyNS3igpUjE9
	ZwZaU+YA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZBTz-00000001lKp-32ku;
	Wed, 31 Jul 2024 15:43:19 +0000
Date: Wed, 31 Jul 2024 08:43:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libfrog: define a self_healing filesystem property
Message-ID: <Zqpbl9cc_nM60I1A@infradead.org>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
 <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
 <ZqlhopUMJNAyxuSw@infradead.org>
 <20240730235103.GM6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730235103.GM6352@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 30, 2024 at 04:51:03PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 30, 2024 at 02:56:50PM -0700, Christoph Hellwig wrote:
> > self-healing sounds a little imposterous :)
> 
> Do you have a better suggestion?

Heh.  Maybe actually make it to separate ones?
auto_scrub and auto_repair?

