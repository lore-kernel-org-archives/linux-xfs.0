Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF6155788
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537957; cv=none; b=R4K3WAZ/928IANQKfjyTVFe0SIUs/iUkDMItIhn4MaIOxnn88uf24pQsZChbPFn9BZZkOXnH5Jv3bZT4OjJ27KjsL2kdUGk3LAibMmG6Ib1HDabrdps/g8ddfMuV6ebfmuEv4X972Yc+MQNrCT7pAE35J6e/Sx5Q64FkUIe0q5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537957; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7M+7GRCqbnasEwb7VLtK+FZw0TGKUc4uDuOdAoRiBnqYcbMoGpXW0+ldZQDjVAq8w648hHUkQ0T9Btj9xnFMT3VV0hGZdwrhmxZUoBBgNkwqMCDp+JuUnwDGt7on5l1DLUbpMYrpLd2Dx/qXs87XoqNDKjxYOBfnOrj2U2e1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jV3SZ2Np; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jV3SZ2Np"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jV3SZ2NpZzoaZAmF59IC+awoxl
	yBshF/Ex9FkHvGheWiXaTCVsRP2xJryxcl2eKzscECKqETNsfAkqGQtejbxUkFIZSDopkpH0whC8B
	9TQKFFM5G6p0JOzKisyLf5qqc38Y4qskkOduMVhYqzoGJXPjpXk2NPbnKMFSc8PQw23qxQ/atcTK4
	ZLdH/zV1pvQ43VGUG8+FsubnBbfQu1cjU8nDHwqej4cwD7jzY+qPKRHkLVH0plxTQaJFOklJybUtk
	g+utzvjrkITZWzM2r3CXXZwNdzR4tuazLzYOpL69djwy6lGvDVtwglxVT94NTa41WSKwNM0YKju/t
	w1w+25uQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRCu-00000008Yxk-0QFx;
	Wed, 27 Mar 2024 11:12:36 +0000
Date: Wed, 27 Mar 2024 04:12:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
Message-ID: <ZgP_JICAFSwf-_fn@infradead.org>
References: <171150381244.3217090.9947909454314511808.stgit@frogsfrogsfrogs>
 <171150381270.3217090.1064500138522339556.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150381270.3217090.1064500138522339556.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
