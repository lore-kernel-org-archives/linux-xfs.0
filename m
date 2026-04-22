Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D26139D
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 06:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838419; cv=none; b=miEzguuz0Wmu251rwW7XNd5AW6Ybw0ivxGCyY10BSc+seAx6or320C94hvsLhoqb45JzUQGZK/5xZXw5hBwhRjf4pkAbQKgyDzr5P3lbnPTFd2UFMqxmsaNWyiUG8oDkPhu2OoaNn/oXDc+Vz9ee6QZfHOrw2Rh98hWu4cA1N2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838419; c=relaxed/simple;
	bh=+5GeUUFOb5jCQQJTIkSLmZ2vX5/yNxBCl1/rkIo27f8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5RHR1kXYD7ofXKwBIZzbaneF513FCXmO8+h9Sff79V2kpjiJ2+bMd+15Q8LT4ETL4LVmhUpntym9yIa1CgMi5GTYNTdA8kTLoCwmOlHr7UVMYrTfo64WPUnxpOpyC/hJAvCcM+mqaMM+5xJMEByJHG5et10zSDArSoMecwmrpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w+QXvhwW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w+QXvhwW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+5GeUUFOb5jCQQJTIkSLmZ2vX5/yNxBCl1/rkIo27f8=; b=w+QXvhwW95meSPnHj+uGIUSTV+
	gHlv9E37Km4S1S7wtzMgGlwYYuVw4inzATCnRLIQoAWziB4gY0mcYz++vnINj16IB5O7z+jqXqpZg
	ylKTow2F3K1cONbT+5w6DnXsDULSN/bJNiAOk1FzAh+yVYIKAuzebxumuISZvI3BpJ+/j2gver+6N
	8pHNIbBRp8a2fDa1jJSvAPabIpxBQLNs7y63iyDYq85zX9N7xQxYGh/cCd4dbQtBuPNBKk8pXAVpa
	ITQgkyEthrv86wCHocvAIbI+xziAZj6yIZsI2q+kp73fWQIYhTZIGTclubTl+3gJpWURYOYkG/CwW
	uJeZem+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFQq7-00000009eG7-0S0x;
	Wed, 22 Apr 2026 06:13:35 +0000
Date: Tue, 21 Apr 2026 23:13:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 0/3] xfs: handle ERR_PTR return from bio_split
Message-ID: <aehnD1676BWy4nD2@infradead.org>
References: <20260418092715.375850-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418092715.375850-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Apr 18, 2026 at 05:27:12PM +0800, Long Li wrote:
> bio_split() now returns ERR_PTR() on failure rather than NULL. xfs code
> currently ignores the return value of bio_split() and dereferences it
> unconditionally, which will crash if bio_split() returns an error pointer.

And none of these cases can trigger them, so NAK.

And yes, we need to replace bio_split with something saner as the
calling conventions make people send these kinds of patches way to
frequently.

