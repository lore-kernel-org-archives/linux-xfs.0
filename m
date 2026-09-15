Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C9526B2D2;
	Tue, 15 Sep 2026 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453963; cv=none; b=syBs0Ju0HlIGmQdiNqjXXgVODceYkSNAtl4zxUTsq4Dj6zELnr2w4KUq/9ipn1oCWXg82yhm62QG/3NivBpcCRmKlBJ/7jRnbiQA9gqG2bYoEJ+ezhtoEkC5dtjgvyur3OWy9i3cVV2l5+dagoKTOgkuRETEq5ApIKhNcTHbrEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453963; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdU7vOWRqA2xry83rVZK7LMSD4Tv7MFUB10x34J5c4DDp29JK0iLhJ+w9imd7i/qgRONQh+7cRU2h0ew/rz7qhYODDkUZct78/jLeQZd9WDTbVIHEeOZmsxSXRcZL6OlKzwGbioNFJ4yrSVH8dEukW595EXJNYH5cEO72u7v0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oeOZsxwM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oeOZsxwM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oeOZsxwMJn8DV21YD9nBPZHB/Y
	MD7sCueZay9egmbc/yKjX8zhcKwMNDtP0Ehm8r+UjH8+lB31DrasdvWw3w2kvgpgiwuQXaxZDMIhd
	x0B4tFUwJC9V0XdNnthQBp+1iNZdGo0EnWVbZR/OE+zh6oLV9Egy+QwKmFquphgs1NJly5jRbqFop
	nk35Db6O0U8lzxnHJgVl4bH3psv84k++SPaMIbS7g9E+B4sMjchSIkWgOafpgJBRWy1M7MYLHWTdp
	IFtHDy8VL6Ip6B7ebiyMpO2JrtFJxgBUU+w8LxVvUnUhHmgQCbRNMQuAFatJC6grBKbvxynCMhg8K
	yLrB8qMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6Mie-00000005Lol-35JZ;
	Tue, 15 Sep 2026 06:32:40 +0000
Date: Mon, 14 Sep 2026 23:32:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: don't let hidden_space go negative in
 xfs_metafile_resv_init
Message-ID: <aqjmiL3Z0ATYoihy@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048710.3061055.166604831227371652.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048710.3061055.166604831227371652.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

