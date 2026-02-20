Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D5527144B
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771601739; cv=none; b=Jb1svgu1HmBgSqN66GpzWoqBZ7LNV6qj/kP4mVEPDpr1cIDYaq+kVIWgCJ9aTEEpM5KdN630gd8KZX1wmmH6RPHrYEWpHhczwOKK5bQj8Wjb+O/CCfwUIPllCg0grqZxYAYYJs+2+4SnYX1LWEGdHXY+HBhYhKS+Y6Q3BCidx18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771601739; c=relaxed/simple;
	bh=0cuGeZWEUQm9duk9PKAi/Mf7CKlX5bbzbqYRVenEEPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uumQnE6kzy8pxiRkmZUz7S8kPDQxzwZBbUJ6l7q055Cv9wEzjNtU3KiD/SXsV5nk0sYiktBk0JB0ahKG22wi4y7xYnfne4VGmzQtjYjgyjjW6UhT1oi3XBgRDQt8eF1KpyMWiETbovQlZLoaa7tdIH1bFlrijQ6W63CmVkUA7+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X3BosU5K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X3BosU5K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0cuGeZWEUQm9duk9PKAi/Mf7CKlX5bbzbqYRVenEEPI=; b=X3BosU5KqNRiEuFDEydtEQjtLo
	hbMcgLHyKGMAXN7Bj+fz20qDfoX/1YNjdd/5MuUvcBcANeJUi+nSp6Lh3jwKmkHwB8ryPESUQxz0A
	hruTgqCbbDION1+e7suMoPcU3wWxJHcmsE/qjz/CeD+HCBOhtrjJul173GG/0i+mekyCCN7iA9274
	jK07huf59nJYSfKvavWreFnFEi2IRt47AJmIQq6elBFwmjW4y1LFDHo9jvIz/BgdJaSspdiuIdZjW
	wGD1BTJ5uBpCHK2f4SugXP5KARrle5CJxDgyAmjp+J99eP6aXlH3yScwqIZyO89wVO+4Ykr3nl6dr
	k0zmLR/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtSXV-0000000F2xs-1Bew;
	Fri, 20 Feb 2026 15:35:33 +0000
Date: Fri, 20 Feb 2026 07:35:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 2/2] xfsprogs: various bug fixes for 6.19
Message-ID: <aZh_Rb7fGsXek6GE@infradead.org>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This all (or at least mostly?) seems to be in xfsprogs for-next already.

