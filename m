Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CD710F2;
	Fri, 17 Oct 2025 05:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760679931; cv=none; b=N5m0MUr+f+pYjJUd+eh5GvHPnDe7vvgxmTRLGBgY2pvb86g5LVgZQlNwWlxgDjDNziCKrCqZ+yc+DnnZ6l5PsAwzmwK+CNlW6Zad2N29li2sgJjuPVRY6GqcjHK2ctY67ikWz//l4obT5OM8f+te9B4i2fbIlHUop5TJUDwamu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760679931; c=relaxed/simple;
	bh=1uuzDn0GT71dh/ktbzd/JTAdLfrKJJzvs7F8icuP93c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCpOawiYjmMzq0PdTqN9OqlIBfvT8qDUWvMnLApuEPraLoVoY0BXugqYOXmo774b4K2y0iOqVoqymhr2522Nk6J4yCbKdhieV25GAWRarBjaOwxTT0zhPDU40NXWReEFlLWqUYx7edYRpdZ4+NWpBv4o8AlwqIg8ydrfxnrEyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JiQ6gRez; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JiQ6gRez"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vZ9xee/ukSucSamVxyglLx+zdlZLqJBw/ptRINWoxPY=; b=JiQ6gRezzkLSHv+TOaGM5lc+2Y
	HsJA6Jk5wd6SlEBJcj1f+Quytu/JgjiacjX2/ggqOlz7XhlhL84HLdzHur3oEeof97VtDnxIZA0eO
	05YeSDQ/4tWugHocypB4WExdykJopoyFmCUWXPMvZWex7+HgOx/zMUAEodZopP6DQzCfdaqRJW8ZI
	8++QSvK3bDUgNkAc5K2xo1FZmkrfvklQA90ALk8IB+yWI9se8Q1jvCarsjdVgro+T1DQk/FH3fAKY
	YvD63NK5SAlvjjIvbfZG5K55NiPSqvKOaJoMtUDCREev1/JRvDYHUjMVjAaiLiZcDQv7iLDc9yFpy
	ZiupVT7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dHM-00000006eIY-3Hc2;
	Fri, 17 Oct 2025 05:45:28 +0000
Date: Thu, 16 Oct 2025 22:45:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH v2 3/3] xfs: quietly ignore deprecated mount options
Message-ID: <aPHX-Iq2KOccWw-h@infradead.org>
References: <20251015050133.GV6188@frogsfrogsfrogs>
 <20251015050431.GX6188@frogsfrogsfrogs>
 <93c2e9a0-f374-4211-b4a0-06c716e7d950@suse.cz>
 <20251015153702.GY6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015153702.GY6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 15, 2025 at 08:37:02AM -0700, Darrick J. Wong wrote:
> won't have to deal with attr1 structures anymore, because V5 always has
> attr2.

There's isn't really any attr1 structures anyway, it's really just
lex flexible (aka) dump partitioning of the space in the inode.

> I think you're right, we should keep this forever.  It's not that big of
> a deal to accumulate all the dead mount options via fsparam_dead, and
> probably a good tombstone to prevent accidental reuse in the future.

Agreed.

