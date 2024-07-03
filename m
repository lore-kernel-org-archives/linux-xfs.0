Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51452A1BB;
	Wed,  3 Jul 2024 05:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719983684; cv=none; b=T7fw7GoRABcZl93QCT9xHXpE50IGadtLVQzIzfdex2n1FHGWuUM/b2u9J476gFD9xhV61lTJkcRF10gtQmw6/A2jZCmNtChQj/995/mRc8ax0i3MdhTUEGz6joE9Ftd6g0slG4G7L3poMaXP885pSU2CAadC2lQIubxKCVILXO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719983684; c=relaxed/simple;
	bh=yQ/jgB5w8ykRthzCo3lkYnR7JWtrYJyHftPr8n9Rj1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJZOpcc3KPUIyiY24LhRMjHyJDiARII0qb8eorC/dTJ1ClOM4g5ONuYXfO46+XNtlZd4EgcXZH9XVJZAbslcTWHm8tVIw9paWfdHHKjd5MsoRYdbD0O3GATBaszbHbaANiiyw9nbdUSWFmExThpn10iAeC4OjdHyX7crs9z8nKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dPXa+X0X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dPXa+X0X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MxOCgRV33b3vLulrz5mCfJi9I59uWLFDz4ZlEWWk6Sw=; b=dPXa+X0X0JPPlydiKMqdDXASIX
	poHqYH0GsftCbbZTV44/6n0otNyGqenAK70n2+te59m+ftba8pi7A9SB0WuRKAkXR5AgqvYkarH3d
	wpCGZvBdACRjqEkmGlCHp2gjTE6Ix88t71YSYpuFSXHJcFnDGSOzGZCzDtYRlkpl1eWKqUQvdKcCs
	qRmPo9+QMnUM0aHSDKZy/3poMxhcVq4cPwAmUPmbtbIwIIkPRWwiTZY/f/ONDgBY1hD0sy4lu8DbU
	63vC1sOtMWYejOpcR/q+VvQBJDJGHT0f9J8Bb5Dcg0K+1MafNkZyAah9gmY8xhdF+Q3v0gojDXYcY
	+baxh3Ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sOsKD-000000091py-2oJy;
	Wed, 03 Jul 2024 05:14:37 +0000
Date: Tue, 2 Jul 2024 22:14:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, alexjlzheng@gmail.com,
	chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: Re: [PATCH v3 2/2] xfs: make xfs_log_iovec independent from
 xfs_log_vec and free it early
Message-ID: <ZoTePWuRKxHXofGF@infradead.org>
References: <20240626044909.15060-1-alexjlzheng@tencent.com>
 <20240626044909.15060-3-alexjlzheng@tencent.com>
 <ZoH9gVVlwMkQO1dm@dread.disaster.area>
 <ZoI1P1KQzQVVUzny@infradead.org>
 <ZoSQ5BAhpwoYN4Dz@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoSQ5BAhpwoYN4Dz@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 03, 2024 at 09:44:36AM +1000, Dave Chinner wrote:
> Ah, ok, my bad. I missed that because the xfs_log_iovec is not the
> data buffer - it is specifically just the iovec array that indexes
> the data buffer. Everything in the commit message references the
> xfs_log_iovec, and makes no mention of the actual logged metadata
> that is being stored, and I didn't catch that the submitter was
> using xfs_log_iovec to mean something different to what I understand
> it to be from looking at the code. That's why I take the time to
> explain my reasoning - so that people aren't in any doubt about how
> I interpretted the changes and can easily point out where I've gone
> wrong. :) 

And throw in the xfs_log_vec vs xfs_log_iovec naming that keeps
confusing me after all these years..

