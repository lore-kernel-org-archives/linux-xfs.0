Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A3430EF95;
	Tue,  2 Jun 2026 07:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384038; cv=none; b=TLaLZJf0NcxO5T1K5fecEVDp0vDN6g6rdqg3u5Vec2cHrOrRQrIh6abwvsNJFfPyOoOg9VBFS7FVVExxV6MsMmwq8Pe8z2c+2wr9FhGKy33VCOdVjqBNyO0XlzWxeDvqCRicHt1s+ff1Hrhg7Nxm7uS7QqVOIhvP6/t3j262YTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384038; c=relaxed/simple;
	bh=sd8+wtIXL9d4vn2RENMDxzMtK5OOTQHoTXX41GOCiq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8RParsIFPz78GRl0zxsvsnBtNeJjzx+fqDJDkO0keiP6j76LOZuIkGW9rrV12X/S28EZ+EeiGJWtkNHSxwXJUiB/AZo+UmckCtppkbfX2zU//9KdnteP+/CtuduKZJYXFE9ct62cqMtD71vfxs8IlLbcXPnT9RtTsipHcYqNl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rqKuxHxU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rqKuxHxU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JSo6t83JEgsfHYAPDYHjcuFTnrO0WBP5pDJ67CZXD4A=; b=rqKuxHxU/Ye+Be/5B8kjCzYV0y
	K8HcmEMWWB6ESqJ3WxJVopA1fH7n9Y7uFAyURh2HsNnEBbvHAFwbtV3pQD9E9VAn0MZhJPWAbaxP5
	Jhx75oWq0WfoB6B/+GgM/XbJE3yAgNttWXWCYJoTLeaPJ999ToBHQbXsKcn5Z88QqDn4ELustK8Vv
	XyVKKW1tepc5uziw+tMMxOQ/58Td6m9hyHrRg/0p99+rCt96Cf+ZaO87Rqv3XLUtfMci0qA24h+ws
	4QpZ/p35BqM1gWyg+alepBA54izLmxYr0xiA5cT8iRFGvf5Z2/GYJDdd0SbaO/vIZsAtM60OqTvWk
	szrNQREg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUJDW-0000000CQVN-2cof;
	Tue, 02 Jun 2026 07:07:14 +0000
Date: Tue, 2 Jun 2026 00:07:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cen Zhang <rollkingzzc@gmail.com>
Subject: Re: [PATCH] xfs: skip dquot attach when m_quotainfo is not set up
Message-ID: <ah6BIsvEitNW5Edb@infradead.org>
References: <20260531155211.43803-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531155211.43803-1-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Mikhail,

this also seems to be somewhat related to Mikhail's fixes in a similar
area.  I just replied there, and my gut feeling here is that if we
are in a mount failure path, we're probably better not doing any
inode inactivation, because well, we failed to mount the file system,
so we better don't do anything to the persistent data structures.

