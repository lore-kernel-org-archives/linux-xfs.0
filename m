Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7208224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807174; cv=none; b=TOOkPammSxSBerdSc+YhaOnVFqYl1zpPBb/Dlnj2l1h58C/aickRmHCmz+i63VZYGTSAa+N8md0dR0J8axcIghG9s2sgAE7MxBwVfRjyrOBBO5MoHa/vGMpC/Jfds6N6PSN1c74ahEG1rkYF1NCNeoqjEJwvSk0CpJvgI814F+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807174; c=relaxed/simple;
	bh=eeJoSWFCbcU+A8ZjizBGRZB2VSaHkmkjILp9wrK7pVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsNtXqNYM/MA8Kf3MIEBTjdn5LCPG7QPjOTyOzYffai7Q4+l58yuuHbaVUVwTlVzwpKyttjuu2LjtgVQz9kCq9jYVHXMtKl5kv440GdXLXJOpgjPEmkwFCfZjhCnPCCfBPzm6c21jDkK2fp+yhmx9RrFRlk+Woc4HXFs30NGApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4nBXi5HH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4nBXi5HH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=//imKcddUwC3iH/DhNSk60zQfzY+oqEzcWQra+tPoLY=; b=4nBXi5HHzWGeOJ1G/QntajTePt
	5nVa+za8zW0KGDcnVH/F7fmqi6HcF6cisJS3Wuv9PJr2Z7Hy1tBUwpr1CqG+bhiKpkcxZXQuabWi5
	NBcPo3Kod2BFY8optwLav8pfsxcgAoSsgg/xivBOo5EUzbhvUKBRZcDYM/4ML9ql9gIJD87oqQtQe
	V8pIIyVF7XtWciRzYeojJvh4nmlw/pGRbLRo3C2q8ONyYLRo8irUrmSJXc826pn4V/TXOWV8OsNUA
	Lve5RmjnpUi23Cw+qjju580GEqU5G35gSTwOK7Kd2oqXHAnuXsbK/D4Tg3mZM0VBfVgIoenOyvBku
	AKskL+7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsRo-0000000AFKB-1gK0;
	Tue, 10 Dec 2024 05:06:12 +0000
Date: Mon, 9 Dec 2024 21:06:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/41] xfs_repair: refactor fixing dotdot
Message-ID: <Z1fMRIsKtLxUK4gn@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748588.122992.770780373114325109.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748588.122992.770780373114325109.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:45:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Pull the code that fixes a directory's dot-dot entry into a separate
> helper function so that we can call it on the rootdir and (later) the
> metadir.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

