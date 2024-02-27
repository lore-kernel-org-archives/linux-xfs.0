Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833754BFE;
	Tue, 27 Feb 2024 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045623; cv=none; b=dJ3CmK541u1ddtdCXL89biqaRYivOim+MUd6DAiVtFArYuzEHcLCVZw8pNtAjDeVsvmgJb3SB+F/HV/Cs4j02Q5gLbKWgmJmHRrI/Xh/HWgMjdpg4c8h53+sE65hg0BhnHj2UdWLvFJmgPv7exHRO+iNMRwQdSoRDEMBlu9OTPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045623; c=relaxed/simple;
	bh=Gf9x5mdjkLLeRDh/lwYWhvWfJziWCRYR7hraweSAAL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/mD7iGR/rJ7yZm6TbLH+d2XwlQxH0iaANZE8UsqPTFXQADbUAQJx9eeLoeNm2yMKUzrO2o4ooyKJmE0yqr9M9eI38kpogf6onkJSoJfPptimm3BCHnnPaNV39orFWqtAAqqZ/e+d7tCN5fjsgS7hINWLyKgmEzLDWDZVzCTzng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=byYd7A6j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="byYd7A6j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UYhN7idIMF1kQbJvB9Tg64y6bjKW0B6Un/Q0Iq43eK8=; b=byYd7A6jme7PHSlOW60iP8GCH0
	w/9+MRSrYrB9BiTLucqkU6VxjXT+m7b1OVt6SeyiG3OUaSyZs0WNqITsK5U6l1+d1bzVh+nBHkE7J
	vM0NpaHFnF5WfpP8Vvd7qQNwg6Ohh+YKKonax4fqE8BbZfImRchx73U7aV8ZYZHFSLL1MF65Xk6W5
	utIos336JD/FxcC1jb6JnuRKchmnbqOpm+29raY9HUkh771ezcDxfbbFtnOWw0k5LKqFH0Pq36gsD
	7HPSo6h6q9s6TkWcJhWFFQZMp9fMr3G8zYegsZeFqW/Gcwq4AIhYSi7+CR2N2jaY4oAZdNt+giB6L
	FfEQCdng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reypy-00000005ekx-0teU;
	Tue, 27 Feb 2024 14:53:42 +0000
Date: Tue, 27 Feb 2024 06:53:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
	fstests@vger.kernel.org
Subject: Re: [PATCH 3/8] generic/192: fix spurious timeout
Message-ID: <Zd33dtmCIWVoltWt@infradead.org>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915261.896550.17109752514258402651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915261.896550.17109752514258402651.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:01:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I have a theory that when the nfs server that hosts the root fs for my
> testing VMs gets backed up, it can take a while for path resolution and
> loading of echo, cat, or tee to finish.  That delays the test enough to
> result in:

Heh, I've seen these warnings quite a lot in the past, but not recently.

The change looks good to me, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>
