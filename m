Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01178A5F
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 19:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709235753; cv=none; b=SR1xiQ/62K26GC6f8/OFEELs7SJwlvjag9YTooPAGF+chupsK6sJc/PLyil0D64lUiSSMtXJBtXj/1FKHcBYR7jCod3GUC4l9WD2nM4Q9i8+e/+rG7A5qawNCAP+GFURX7JoJ+E3LLyGP+JKZmHlSJvE8TmkNhUFgqi6kXnuMSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709235753; c=relaxed/simple;
	bh=PPgWoXMs2sHEyNwozTa4jrnKu6ONpZcGKtUzHU4qCbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCoLHZOo2abQHaecvOvVb2GMBtmcEbH45uGA6vhBPwAQZW2uyCTOIal1fZol0ujrG0IzmLbRrbaAdOMgbjjjIEKWEP1oCoGx/zMWzF/LwPh84CyuGWndzjWvq7ysqo/nMJrc6B06yfgv47Ysg4R2OntCXoWKeIafltT1halqZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UyMh8YAN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UyMh8YAN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IZuezpf0c0LMEXLH5wNwuAksRcJIbCAjU03oSjMxRP4=; b=UyMh8YANmSwqGBLjkPT3NuqZKf
	MJQf1KiAGWtvKCZMr5P7itdOG2VhdyX/FOl8QjqaOlOmKOzH3Rr5pHFyffDz9dn922aaOqUehzOQ7
	gf1lZDjROIz2FnvLL1mFU5JDTxBvsS6g2MLwxslLO5Q+ahRhkBTR1n9UFOIYDpuYSCoaDgEZrdhI+
	Tlp/ptgFITdToOTi1a1WHXzqGJu2/4atSSjXlUu0Ofj4dw5nei3PVCdM4O0GrbxsZpjF5tEhRQDbK
	+QSz/EPLoPhvfcFbsNCVBZw8eVOWhotFo8tp6VdbEmKeHNZwFrrH42wjv02d9ZzsJhYF/NehC08jd
	8pgQqRDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfmIY-0000000Evp9-2UXA;
	Thu, 29 Feb 2024 19:42:30 +0000
Date: Thu, 29 Feb 2024 11:42:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <ZeDeJuL54ZiSBCM-@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
 <Zd9U4GAYxqw7zpXe@infradead.org>
 <20240228193547.GQ1927156@frogsfrogsfrogs>
 <Zd-LdqtoruWBSVc6@infradead.org>
 <20240228230057.GU1927156@frogsfrogsfrogs>
 <ZeCFBZVX2yjAw-5n@infradead.org>
 <20240229171043.GZ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229171043.GZ1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 29, 2024 at 09:10:43AM -0800, Darrick J. Wong wrote:
> You mentioned it in passing, but I misinterpreted what you'd said and
> took the signedness in the wrong direction.  Here's what I went with in
> the end:

Looks good to me.
