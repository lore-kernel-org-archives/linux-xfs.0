Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816A51614D
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 13:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984045; cv=none; b=FC/nsd9N8JulTAlBEVA2+6psR7ZfRXeVSsjZ0273FSk/qL7U2dS5RENmjrW6nqhqpcMLlbuAXBQ5j0hyvuq9geRG985z/yjP1aAeZHr+6fBnTjgYBjum2j0E1nOztb95JL4uyUv8BhqlvHGue/ldIJNIkeNKBdzjh8lKvo5oFwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984045; c=relaxed/simple;
	bh=5Eug8sMf3bcXlggtcqhDFnfLlTG4h+8E9gXs5VVyEIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CgXfKst0WxvjrqTEn5SQZICEoo9nYTydearHGLgQ0J4xoXS3gMgHSqiUsn185GaC4o8OnHJJh2EwgYSarZNqzR26n/rDwxDyseswIBTU2vq+92K8FGc+d5qKM4OvgcJvgcaazQx+cWQ/2aDp7uHbzPWCai5vP0Y/PLDal2b/Tbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z5DwHbOd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z5DwHbOd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/Qzv9bvfqevrEvqTL2R8FG0orVr6nyXxn+hKCUePg9g=; b=Z5DwHbOdQmxs5Yo/khaq9tj77B
	zo4MosKB1Xd3hPUdUmwSwsKq/smIIwAnlLyhS/WCcz8POfqIz6zdkjOK7ZZwNhD4QIp15mqbU9Qn3
	c2fxST5RevE+LcgMnRD2hFP4TuMbnuqfoMc+1tLh+kwztdKSPNoJNumBfFsTeM363arloJBZl5voc
	S4wBOn4FtPfe6p9R8U1mTJd0e0r7VpyZrqIEbR10HQnpW9ivEajZZGGDS2TFfWFhZdFKPoi6JSgR5
	kb5GfJpcY1YG9mtsVQhtXw2VIYWnVIuKcAAn8pAhm7jAefJ6Qa2xGOkfVqEWE/w4KhkKqxYJJ49L6
	gWv8+4RA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGyuO-0000000FZTj-07dd;
	Wed, 14 Oct 2026 13:20:40 +0000
Date: Wed, 14 Oct 2026 06:20:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org, djwong@kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2 V2] xfs: add missing cursor status check after
 xfs_inobt_get_rec
Message-ID: <as-BqEmAVgwVsYbS@infradead.org>
References: <20261013211851.641256-1-sandeen@redhat.com>
 <20261013211851.641256-2-sandeen@redhat.com>
 <551761b8-51c9-42fb-8992-980a72999135@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551761b8-51c9-42fb-8992-980a72999135@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 13, 2026 at 07:16:39PM -0500, Eric Sandeen wrote:
> The xfs_inobt_get_rec() call in xfs_ialloc_count_ondisk fails to check
> the &has_record return - if the record is not found, the next
> conditional will read an uninitialized  or stale irec. Fix that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

