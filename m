Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FF517CA1F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 08:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731487704; cv=none; b=n4Pqb5Du6UuNwYuZzXj0XtzKjMdMWgxI9j9ugcNMAmNOe6Su9z8NCntXSXyPQqbt6SK/L88Nw8gT1hDX9xfIP4L2REjXlngwrf4T60kAYSr138JYy43nV8cIsO9rNabmVXfnudVCFElsn7oQg7ls96rS7QP5EDmOFlK7jycG/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731487704; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0QIlwJwEZj7Dwl0qpNHX0m61KpZ68YNogbDH26TNNS8WfkGZiJYRSblCnckisDInRrQG2u+B1Zve2VFbnxH6uDNXZTux+yJfbG6gp5+wNdvlbVc6uYN8GdxplQDQys1utHffww9kzRLkYw4DmxdeTdVIV9p8T8BL87gG5GEy6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P84lIVhA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P84lIVhA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P84lIVhAbxXWkBqy5mD3gNOc0h
	OH8nnbfYzFoSoevdaf34jYBvIkP7vchsWt2dy461t4pMY02VXFaj0ZuKdS6l7VrXOKVzi/Bc05hrj
	gVdNyNxucaDpNO9Ngsk624IHgUnabPO6a8I9dybvyvSN9Mun3VMQg2dGmp3pf4CIEXdUAvxFXt/di
	khVBYZPGZgegg4bZgjMsGG/eKgs2W9UyrhTCZUElX9sZ5/vOnVd9+tzuQ6O1OAs3dr53qpNQzdlc2
	SG8FQppc7v0ZKPhgJo1IQjn9X/UlanvHXaJWXM2hnJDxjRxvGd6/mdiE/xIYaYn2NYsONPom4SSYr
	jjCOjA0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tB931-0000000697w-1mAQ;
	Wed, 13 Nov 2024 08:48:23 +0000
Date: Wed, 13 Nov 2024 00:48:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 2/3] xfs: delalloc and quota softlimit timers are
 incoherent
Message-ID: <ZzRn1wMgNAdOIz3j@infradead.org>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112221920.1105007-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

