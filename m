Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6071039A076;
	Tue,  2 Jun 2026 05:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780379809; cv=none; b=c2ztiLQGvefTCytW0BGmv7OIlsCF3avSlVriJysXqByRkuB+g84TOTL4UfmpVCsmDoE+mt7UATSz4BEIT6jSIysJ7sJ+pKVXZ7mdkkkPcHihsfROVRlMlaewmjzBnwvLyuod88WQN9gR3C2MjqqSXGnqmECl8knnqBqr0IBXr0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780379809; c=relaxed/simple;
	bh=Ae+clnVLdwzEJCQHftrNjijx/po5BB5s5ebv9yLkg/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=juLGkQeU2OoRNmw+HMjgpo8qzC7ybcHmy4YyR1cLysEAli57HPR+HAc338mM1Bbc6H9UbJGqBMAyaxsEncO/ThaCerBUsEldx4qXoAWR9u5BU0vuNYB9yuEmpjFgmThRArBum7ptjOPCDhkDxDiNhmOHLTb62MJ4TJ7qzHvSPAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aFXZzDEP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aFXZzDEP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ae+clnVLdwzEJCQHftrNjijx/po5BB5s5ebv9yLkg/c=; b=aFXZzDEPnbQA8+vlv/pIYelMHg
	hcdYbPnrOBDfiF166RTyceGEyTl5CJjbND8Tr+Pw0Ju8fsvtXF3WHOEhC2fuMe4axieGEEiz4ig9Q
	JuFCRgD4WyhDeG3n8BjcijHVQy/LZbFDNRts925gwNDGviiYW7fmiLfgCh+7EPNVLfOK3kn0Y1xs8
	kMiGsNYXtMlTT1RHCLU9QnKlBZAT1zCfjYDqpLpYZw+BY6ud4SHrtG6tB3/rVXeNIxkDijpwvDSZN
	cCQJk54CcSjAEW7oZNoa5LMlsFZ7cdLB6oteO7MlwXniiLSZaP/eYAy2hgaWIPsTRnigpVbrxifAu
	0e5nQBtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUI7L-0000000CLvQ-3m9w;
	Tue, 02 Jun 2026 05:56:47 +0000
Date: Mon, 1 Jun 2026 22:56:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: William Theesfeld <william@theesfeld.net>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: convert dquot iterator map allocation to
 kmalloc_array()
Message-ID: <ah5wn3fk1ijxEVNy@infradead.org>
References: <20260601191858.608270-1-william@theesfeld.net>
 <20260602051444.GU6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602051444.GU6078@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 01, 2026 at 10:14:44PM -0700, Darrick J. Wong wrote:
> Macros these days...

In in the new world order this should be kmalloc_objs anyway.

And when we touch this, we should probably drop the NOFAIL and add
allocation failure handling.

