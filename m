Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F226CE1D;
	Wed, 30 Jul 2025 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753885130; cv=none; b=jXAo4zKMN3OF54t6y5inZpCXkQxZTJeX+2vIhWAzpovdaDMwylfN/dsjinlugsSE5GsckBvywzYlqBnsPnFqwSx5ga0qNiCB1Bzaia+uZSVoJXzA75wJZQDn5smBL648/ISCDyBap+fzdI3GjEGtsR0E30XrQ2Dh4pIrGpeBuAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753885130; c=relaxed/simple;
	bh=LM06zyEsuw5zS1Jlmdf30ry1i+NOrjgnfJWJ+sMYvxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rG0tCmvwjkQdDuprrRO0o4/0dQt68YeMr+Jv+OS/S9ENflPujxgripB9P3EYjs4GjdiSrScA/Mt4ZR2F5ztYQPb1eYD0m/ZFxLtOqMV/0lSOGXL6LKVA3UHXGhFu0/4bMLoDgVtcGYAIEMLbMX/ziaZQ/LlwIURDzGdRKtH0PqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JimnvxRb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JimnvxRb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1SLinhCNImfO2gFMc9jg3UI23/mSSu6Nfz+qHjlQT8A=; b=JimnvxRba+5lwlkzmU6WtrK/v1
	tgf69pZAmLDKd7WdfUKOgHf/ormCYESnZxdQzK+7YMXwUY+jFCuHr5l79AAA27aiqfuOkhwcol+A+
	ILmyZ2Q5a8PgGPgDuUqLxnnlHpS8gXjgj5EglQCNV7Krvp8TtpDjbhusrB6sJAv9rhbzhsMMvgNok
	9bWtJtkgmLcTbCKxFq9n7t1Jl/8Gz2MD6mbpsGqkSHcjOSZdfyDeES3GVeRi2olyLEsVnGFw6cYkG
	pfxR03ZwFmyi96hADRM9/FWE7gDYyikIP9BDV8uyp9TdQt29jbihE/Wz+ENrNVrd5LImRPkDaA+vQ
	8n0aoURA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uh7do-00000001ibD-3i1t;
	Wed, 30 Jul 2025 14:18:48 +0000
Date: Wed, 30 Jul 2025 07:18:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <aIopyOh1TDosDK1m@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 29, 2025 at 01:08:46PM -0700, Darrick J. Wong wrote:
> The pwrite failure comes from the aio-dio-eof-race.c program because the
> filesystem ran out of space.  There are no speculative posteof
> preallocations on a zoned filesystem, so let's skip this test on those
> setups.

Did it run out of space because it is overwriting and we need a new
allocation (I've not actually seen this fail in my zoned testing,
that's why I'm asking)?  If so it really should be using the new
_require_inplace_writes Filipe just sent to the list.

If now we need to figure out what this depends on instead of adding
random xfs-specific hacks to common code.

