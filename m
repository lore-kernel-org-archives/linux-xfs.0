Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CF31802F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1FOkFNBo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cNRoBIbACL+D6V0YtUFhlSfISvYiRMYKVFPDQahCB8c=; b=1FOkFNBoFYRlbRGOnf0e8qR4UK
	f3iTErSSlM22qVNXJLP7AxH0I7mzpLtQnz/nrNfV2YYr23ToYQZBgVTIOUXeW3B/iF+PwPGi4ivwv
	zVj+AIBwnho1v6jTmvKhIa+qfg/jwlixSVXirTbW3woX5XMk+TqNtntOshSw9TCfy+ti5HaT+eg9g
	V3JLqT+bpjRwrzZA1d2luSF6/+ceimU63OUnVkmYc++gDXBvMMy31ImEZjybYuV/pxQMI3lOuxuGZ
	7ezjqBrhL1xeHBEsMe2HWkbRkZSydt/r40ohCqh+pFVAPOjhraecbrTJ5xvYE84mYdnzc6I+biGBJ
	HcxKlCuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKvor-009zkB-0b;
	Wed, 03 Jan 2024 07:37:41 +0000
Date: Tue, 2 Jan 2024 23:37:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: allow blocking notifier chains with filesystem
 hooks
Message-ID: <ZZUOxQHqt7WFV8/O@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826571.1747630.2096311818934079737.stgit@frogsfrogsfrogs>
 <ZZPlNOFEfG7KnEk6@infradead.org>
 <20240103010747.GB241128@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103010747.GB241128@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 02, 2024 at 05:07:47PM -0800, Darrick J. Wong wrote:
> The main arches that xfs really cares about are arm64, ppc64, riscv,
> s390x, and x86_64, right?  Perhaps there's a stronger case for only
> providing blocking notifiers and jump labels since there aren't many
> m68k xfs users, right?

Yes.  And if there are m68k xfs users, they are even more unlikely to run
with online repair enabled as they'd be very memory constrained.

So I suspect always using blocking notifiers would be best to keep
the complexity down.  In fact I suspect we should simply make online
repair depend on jump labels instead of selecting it when available
to remove anoher rarely tested build combination.

