Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EA37DA9C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848651; cv=none; b=IfJWBpqjhWMVyQ3sl2E4Oy4BWr16mf8T/FhZyvs0JY5R6+2WX1MAjNKBOPzuB+0KnqJNljyhuQsB+vjYXGqdeD4SXpAnvlZwpNRn84YepkrQxIlJeKA1RNOgBdUizBPOvqyp6ZvTtozh2xlG10lPzVlqS2Cr3PFOPNgzbaS9hGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848651; c=relaxed/simple;
	bh=kBtNsnwdpu7ZEM6/eATdd9QyGcNJpYjx4mQ2jgfAqcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9SJxTyG6QUudG4TAjS4vf3+iSAhdP74HwasMIogKaI9TgxL64Fs2wrg1W3K1jgPWKymGSGWTKJ3A0EiXryv439LT50w/y1CHXxYGxSWYoMZ33z3EfXjDx4VyJQUIXpi4dbRQP77fsGCOub6MNQvA5Io1dXzf89HRHkcv8jiyac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lm0aNqa6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lm0aNqa6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0EUo//gPVawFGI7j2Qv3+oKG4X6oAIVsA8SzG/ZkmGw=; b=Lm0aNqa69QURSFyIEjI4M94Yax
	QfCHWO6BwknnNA77HyrnPWOeo1DpgZ4NpVZ+fbN2Kgl/p1XweFhf4h3WyYloRG2hr91jEzlos5Es7
	osirYhX1AfuBfW4w1HgyB3XTuWT4GitAKlRYtoA+oJVWnt9i9ATjuhveDH8Q6DA/aCCuQBeyw39t+
	52JTd6bfjmqsdP7uWgyYBmOLkthAXM2EGJnFjkiIyo2j+IRpiZtdn5t1WDjwOjROLLkx7okMHK75C
	g7Y65P6gcGsgeyD8876NSE6fPiyGr9Qov99VHkwwVrOErc3sQPNG5QwygolIMZDtCkLTfBlwA1PXT
	v6ushvcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsMc-00000004suT-1iHA;
	Wed, 02 Oct 2024 05:57:30 +0000
Date: Tue, 1 Oct 2024 22:57:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: fix exchrange upgrade
Message-ID: <Zvzgypy-73T-CaA-@infradead.org>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
 <172783103393.4038674.368177237231285654.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103393.4038674.368177237231285654.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 01, 2024 at 06:25:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Set the correct superblock field for the exchange-range feature upgrade.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

