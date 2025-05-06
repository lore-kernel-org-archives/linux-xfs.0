Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96E42D8DB0
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 04:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746506056; cv=none; b=b2r8TVw9eJtcvMq+88RzU35qJg02F+3fDozerORr4nA4RE1juUD1+itfi73sQMSUpHLDrtr3YuaJrtSoeBBI8zBSJlooLEZtS4rJnMcWuilYe4okLRFEDb02WPr5n0zP+JCeK2DbqlR2710zJvJ1o0xGeWGNJPp6pwzpzZturlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746506056; c=relaxed/simple;
	bh=laGw8HC23s0mol2h13zY6Dkgx9nnapo85VueWwI/Xrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWpDO/NJ4h/zc4AaMrvpKIPQmtUaJjD5dY9EjIiJlmmjx+0EsKXguFdIJMys1O7RZIXgNtk1zJWxowdfT+GncmOPGDICPE+G10xQ5QKrtCi/bLKOWjOwHxOVJxuGXlqVJsB01MIwstwLkTKw6UHFZTvl5klvgpNiIZXGJygT3bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lUA0nuUG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lUA0nuUG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rh4o2V51OGibAa56/OcqR+gS3BmGRoOtgGuFAD2hKh8=; b=lUA0nuUGbA34h/TqOsCXmuNmD6
	xg6KUwKDmFBujEgYfnJslgo1fgYVjiTRT5XG6VDyqmXgLc9yulLJTjFaScXTWLY0QPiB4Zfzei6r5
	G2sgraKKwFfvUG34+a6Vz2rs/2UdxacC7cwVRFpnROQ6RLzihCKGzET3vQmNy5uq80RcOvltEOo8I
	NyNm/Cw7HHsF0p4wj7Fg0J5A5MLwwUzx4eqZJKuPPfyaK+fRRsz94g1fPfkFDmWRczhrh1khLvHtx
	atwK5W9xGUdoPhmk14JeRnNdZ/lv0lggBtxW+U5vG/Qy76bWLE9gXiBxjeluUuVJN+swhE9M3nW5Q
	s6f/9CsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCA0U-0000000AExP-1mbY;
	Tue, 06 May 2025 04:34:14 +0000
Date: Mon, 5 May 2025 21:34:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?B?QmMuIE1hcnRpbiDFoGFmcsOhbmVr?= <safranek@ntc.zcu.cz>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Question: Is it possible to recover deleted files from a healthy
 XFS filesystem?
Message-ID: <aBmRRqCbqKX0bMln@infradead.org>
References: <18512e-6818b200-1ab-59e10800@49678430>
 <aBmQaN5EAmwfVYaP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBmQaN5EAmwfVYaP@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 05, 2025 at 09:30:32PM -0700, Christoph Hellwig wrote:
> A long time ago there was a simple xfs_irecover tool to scan blocks
> for inode signatures.  We never managed to port it to use libxfs and
> the code repository for it seems to have disappeared.
> 
> But in general, yes you can scan for inode clusters that have not been
> reused, but it is very low-level and dangerous if you don't know what
> you are doing.

If you are looking for specific file types, PhotoRec
(https://www.cgsecurity.org/wiki/PhotoRec) might also be an option.

