Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4485A1C0DE7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712811163; cv=none; b=l74WV0CFsF/R/lUgAIrFH2B2za/Lu4FHnbKZ8CSUozaBTxMu9VUOofpvZwGOZwo78i316/32J0aT4s2pUCs4YYRS611NK/LtJYvpPHBilmSA42gZ0y4n+JuJQLM3Wa3BGs43aspRLoUw4s6V8ML7FxarVPia/0rkWZMwiZgh3gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712811163; c=relaxed/simple;
	bh=YjSOG9wUDBocAbbFGEXHTvxoIR4Q/K17GOEiiavXl2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ul1mz1VmE25cNo3aP+JU6M3T+O84cmcjA/tO04mgp5cgpEcrgmow1eBVCRp+dzJYPtyPSs5ud9NmtgDqPA5YSv6+rMs9rbRpBrxJn/Y4wBntPZ2AmWRmwDIjpAUZekPdNvdy1W0tC+Y4/zBYzh0Saues53accX/8gaMGPL4LthY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h+6KSGoi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h+6KSGoi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o95AEvnq5kO+tJ1tnUFi4YjoEHjAYOD7JTozNgpQ0ik=; b=h+6KSGoiYQmNm25VuCmbrGiMYq
	2qfCbNRWFbVI1kAaqoP/hkZ6k967f9+Evftdi9Z2iAIWHv6uvyxJK4srKxmg42UR+xE/0GSgAz4qS
	zhLnt7hQeu+wbOa57s1EYdD/XXLEWAaFyrx4epfgzTMmz+U0hwTEkP4fKp9BbZEawhkZMwMKufOX0
	hJ7EzgbmT9D/hphbyy4D6RXK2v85SZaLrYB67OkombRyL6h5M0ySMbUv7OGn3o6DcgB1BQrryiDe3
	w6x+sNCFDeNfbKxTyYKNaQ4WLKTR473LnoFTfvChzvLKnlT1EIbpqtMqgEBsRQIUdpEFBfREOPW8I
	qQc7zBwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rumQT-0000000ALk4-2iwg;
	Thu, 11 Apr 2024 04:52:41 +0000
Date: Wed, 10 Apr 2024 21:52:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <ZhdsmeHfGx7WTnNn@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
 <20240411044132.GW6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411044132.GW6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> How does it determine that we're in a transaction?  We just stopped
> storing transactions in current->journal_info due to problems with
> nested transactions and ext4 assuming that it can blind deref that.

Oh, I was looking at an old tree and missed that.

Well, someone needs to own it, it's just not just ext4 but could us.
> 
> >                    Talking about the in transaction part - why do
> > we drop inodes in the transaction in scrub, but not elsewhere?
> 
> One example is:
> 
> Alloc transaction -> lock rmap btree for repairs -> iscan filesystem to
> find rmap records -> iget/irele.

So this is just the magic empty transaction?

