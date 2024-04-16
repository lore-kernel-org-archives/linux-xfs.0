Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4439FD0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243359; cv=none; b=Tt7vwlFwv834R+i4s82kIslYEJ4cxsfpuyqRwGz5zcgJjA6Q2s41+2BfBI2VvLJHTEevv6rBF1F1/07/KJhHVsn718Zqffc7OxpMQet8Jruy1AQZW/dsg00g86Bc0nsIgax48UmbESSGDK9Xfwl2mU04hd6zvPeGluZv2MwgSXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243359; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzcPw4+fHZO1/RvbjyJQcj9ZWwW3Lkao8E7eq0N6tnKX937RC+Htpw7oG+sp6umEYPnqwEZ50rQjjl/8H6Q2LADdnsPvHzCmc/aWqk2FxDCU/xpAui37vXcMi0p8Xn6THv00yK+SLRz1tlhaAslTyCHMY4sJBopruuR9EtpxlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lMhZvLdu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lMhZvLdu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lMhZvLdujYwaycf03X36KFRzTg
	EZ72PdhORZZc2UloGaupZI5rMq8EvE4xr/Ew+HJbqgFjxsp6N1pYRrmUVK/uq/oRdJF2322TDv0pq
	2SI3KRKa+QSbqny5V0RDCqDgKf0nJW2z2gK3zwtBnMOQlucsGBCOuQnTlJsyaO3MQCu2/d0HbMpEA
	cO5ZuRD3mchF6ayg+I3eWxi9qeHMMFsFUvk0OdoqP//kv4P1hyK5yHW8M/y8pOnsVRcLBdWrqK3+t
	hiVt1OvFFZlEBy6V95SHTeernnNf/sqX8aPJUbIVEEUvy9lWQiRTnT2mQ4wLm2sVJskQ+D7/dyAms
	7Kc1uKZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwarO-0000000As9S-0ljs;
	Tue, 16 Apr 2024 04:55:58 +0000
Date: Mon, 15 Apr 2024 21:55:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 3/4] libxfs: reuse xfs_bmap_update_cancel_item
Message-ID: <Zh4E3n0vtNnJ9p-U@infradead.org>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
 <171322884137.214718.16353340802853919533.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322884137.214718.16353340802853919533.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

