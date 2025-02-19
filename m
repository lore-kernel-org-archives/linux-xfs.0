Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15EC169397;
	Wed, 19 Feb 2025 07:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949328; cv=none; b=cMc0OwHm2HsHL101JdT+wMrwFGPXM791DOF02OLDGowZuGiuHdghDrd7KaTdHKdJ9uyaSaJnArM+bXrJpXje5LUVlXMTuVN/djFZYA7GM27tRdkIUdN+As41enKglUoPY+N2vWhUg4Ez5nR6t4GIvpPLcG9uBIth01aS0VpIOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949328; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4JxD+YzYTPNh6q/Cok4hDtbOv4MXVHKdKQJkBWtsL9/QEaiOtY31bnX5eqyP3dkyRGUqWvTuc78pjMgJSBKJfBcBIZasuqDH/Hz0T3AjFMPODZv3hLA8Vls2jeAasUZVG0AIF4z9xjpkbNlahed43QvD2OxJzfT9Zl9kj7c3Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=trmxLp/S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="trmxLp/S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=trmxLp/SXC7ez+Lb9M9QQueXHi
	DN7UEqijMczw0Fjqh4iXR88ZEj6pSlB5p4O4hemWYTDkSQuWMXrwF0b+nSEhEr2DwiG6HrcHvL9GQ
	H9RjNjHt8xe6cztZC/7onIE+XzAycexu6DNwGk31ZEzOVKBjyn+9QbfJ7QBall9139xFxHFro1h4w
	Cv3Ui27zgJFqqCHGTzQ9yjlv3QgizGhliaUMuvXg029WttkoN6XX76mYf97ldliE8q0X6fe3D+hGG
	9CnzWKDVDximtM3UXhOIQXjoGU6GKUJnYGrMzYyC4EzO/emWcTfUR7EkfnazmSv8dZ41g5yGvYZQh
	h3iIeVCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeIp-0000000BBrH-2Dmz;
	Wed, 19 Feb 2025 07:15:27 +0000
Date: Tue, 18 Feb 2025 23:15:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/15] common: pass the realtime device to xfs_db when
 possible
Message-ID: <Z7WFD1IFFRRKykZH@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589345.4079457.12014427831544220477.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589345.4079457.12014427831544220477.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

