Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3F11AE01B
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081057; cv=none; b=L79hXjo7m1haoqhD45LzdYYU2FSu9sENWwg4QSHgi02pwHEDcYTmG4KbxJKu6Fu7MGHR7sGsoUbM/79tiLzqR2jHR5MEIi10AnJgdN4e2xoa9zlwSulmeZE9sK0TVYgrrCDpMjmTT8l9xmp6MihpyR4FLz/zqNZqdtqD7zPuS2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081057; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhCu1rDXTMyF3YW/3vQ++VA5C5H5A/NkleZ9Y5Uewo6tJ1qkBjCofvG/HMzQmXoPAkDp0ScDmwP9dXj/rWcr4mkzsbnYn1MS1lkYCx2PasONdEd/rvlaeDnVfb5cDmJhmSz8Dq44jk0L766zczX1H/Y7URELMHNphACQ7iCM6oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lIiwyV3j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lIiwyV3j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lIiwyV3jAkpmGaVlHcsfaN2Xmd
	Zodh8pfbVPJDlOjSL/Irz4iSzMevM8kLPbal2TeG7xpE2/MVFcRrIeeIX265G0Bp82G/IucHBZXOs
	Yz2YqRydoNpeo/8wnVxHrEyW2AqiqiLVCr0DcDPuAhO0MTCrM7dhCAnerMfuqYwaffHe9hRx/TKSx
	tMfXwWC07uvZ6FlxT55TshL93oXeL/bhOn2b22f+j1GoOHi6Q6FGYKoHYHpN33/agUlbaULAX5mZH
	OAzAwu3v38Hj7AYeSDP16RHOBu9yo+IKzDAmzryjj5uU14OBNP9W3yvBSeYrQUjJjAEE82vZhjjQe
	l220HDWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1hI-00000003CDn-1xj2;
	Fri, 13 Dec 2024 09:10:56 +0000
Date: Fri, 13 Dec 2024 01:10:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/43] xfs: add realtime refcount btree inode to metadata
 directory
Message-ID: <Z1v6IF1uWu_54DQ5@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124739.1182620.2706215775665123492.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124739.1182620.2706215775665123492.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

