Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04B1946C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727227; cv=none; b=Z67Aam+lmlhDmoYporY1aA/CXFvYUMnIauyBwi5H8Net10oGuS2phNBx5WnT7UNVs+IBGSxwME8ijoK1nlmOsBAW235mmEvnPTnhrOwvVYHJBwd7nzMFF/CvLVMXgonxa7tG3oREkdVBk5OZFy2t6+9ssIcSUJIFk45VxrbiKYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727227; c=relaxed/simple;
	bh=KA3RThdk6G29R4851ddDd0aJHtMGs5PwHh3pj23XsA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTCTsuAPvir5NFur2rh4hwRs9V8T85qV90DuUP+nwIoYrUnJPWH/ZSzIVTxmLAxwkdq/DMYvWHfP93R1GtXfm7w4Eo9kN/AZlgVXpzF0sGURN53qzYyWw/YmiH7dy8mTVuMmTyR//8UHk889c7SLGBW75EObRB9SlCbix+vJbcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=clWMxifM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="clWMxifM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L1X1zLdWWEsIa3oXb5SlIDI/XiDlHAlRtBvGq8W1qkI=; b=clWMxifMTULxJigSGkRBeoh4r7
	EPaGDCWff8i0zJDe+kf2Zh8SV/NfUvU7j6/oh/4BvCS9Mk85u959zSM/H1CgBr5wj7oEnYN93u/9g
	uO6/LvoInb5VcGjU4OYQhQ+moXUZMpcOWC9EV7yUz+iz6c7J08JgCbFkAzRQCU7n/Q7PnF60F8/Ul
	d1PWG5FsAMDU72BHWH0adaE2t9/xvxoV4FVbiryY02nzm89jruah7/mT4rHji8UIcKphzImBft1Mf
	zAdBaW9Y5FwCm2o3KXgKogKCSjuN7WUaOyrvE313p2ZDoASx9fHx44hYOrQpBdhbjCj30mbgWldUe
	xNS4m3PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQaf-00000005DAW-2mIR;
	Wed, 10 Apr 2024 05:33:45 +0000
Date: Tue, 9 Apr 2024 22:33:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/32] xfs: create a hashname function for parent pointers
Message-ID: <ZhYkuX5EuadCR7kv@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969823.3631889.1348496929393481589.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969823.3631889.1348496929393481589.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/*
> +	 * Use the same dirent name hash as would be used on the directory, but
> +	 * mix in the parent inode number.
> +	 */
> +	ret = xfs_dir2_hashname(mp, &xname);
> +	ret ^= upper_32_bits(parent_ino);
> +	ret ^= lower_32_bits(parent_ino);
> +	return ret;

Totally superficial nit, but wouldn't this read a little nicer as:

	return xfs_dir2_hashname(mp, &xname) ^
		lower_32_bits(parent_ino) ^
		upper_32_bits(parent_ino);

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
