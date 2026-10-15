Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14A33EDE60
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043816; cv=none; b=g50kP3KdqbO5cnnRE59WO+224MTlscC9drHwFzjkY9nQjLyMNoof4WiY3ZgEa8gJhh2qNIemzv/AG6EIdm3dZHfK9QLzew8hWeu5sC0ytG+RPCBgjpSHB+N3qzierwPvqiaiKDNuGYDc+mFH5vKowgD7BR3VbOysm9ICukkdof0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043816; c=relaxed/simple;
	bh=VVceINUb0KMB9A1itHgp246hjQpuOFnbXb2EkP7dzts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGxooYMhczRMYkYDBiSSq2ufojnfPDJRQPmSZ9HIFJ3FOcnPIFo0Eut+FfPgPVd3aHeLZ5w7aF6nDD5GEW82nVBUaXKE3wv4Ou5u989duan2Ip+QsCp+z+NKDFL7HTo8etwUE/KdMHaCYcBw1+xrz7KjJfYiYrFoSLhRv24e1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QRGluDLx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QRGluDLx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Y0Y5OhQpYR07cZfxodzHzjk2GeV3/KcpnaBRuj3iH0=; b=QRGluDLxnHhUE+goQz18FLcOg7
	Cqbw0Kn8BA4calGg13R3YBQqKO3scwq0lVCtCdOy+Db7dBlg6on1H7ctzbjikiHl31IkAAgmLPYfy
	AkanFLqh6vchloFfoM+OujIPZXMVbYpcW5OnQGrQZkhtflIyZrHuGVNCrMPO/wK4jZ4CySCru+0sn
	WiC7U2k4o6GZ+KGKn8MjfJ3maIfB4aECYCI4ZaT8kHrDvGHPOMtknN+psKliP4l+rmksQ9teXGVQU
	ENSzRd04n/RzcakfkPoGkJzH8lqvzBl3oEfB8pZA6i4nlpLHcUq1KDSbsu/qHAD1xaet2Sj7ExcHH
	ZQrEVYlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHESS-0000000GuMW-1O6w;
	Thu, 15 Oct 2026 05:56:52 +0000
Date: Wed, 14 Oct 2026 22:56:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix compilation errors
Message-ID: <atBrJO9owC7yXsRb@infradead.org>
References: <20261014174442.GK2705364@frogsfrogsfrogs>
 <as_IydSHaWCYgnLJ@infradead.org>
 <20261014184212.GE1615495@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014184212.GE1615495@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 14, 2026 at 11:42:12AM -0700, Darrick J. Wong wrote:
> Add -Werror=missing-prototype (or -Werror) to WARNINGS in
> include/builddefs.in:
> 
> WARNINGS += -Werror
> 
> Then rerun configure and make

Ah.  This is not "compiler apply the default function declaration",
but the compiler warning about not having a prototype for a non-static
definition.  Which is still somewhat useful, so I think we should
enable it as a warning (but not as an error like above) for xfsprogs
as well to stay in sync.

