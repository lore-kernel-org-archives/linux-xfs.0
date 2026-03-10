Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C03243DA30
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773135000; cv=none; b=rIYTtF0ydwdVby/hfJgzSJ2YOGSzNk8jaLt1LDfWqRiDiQa46Pi2mT5iJJPy5oOKzyWCuJaM695Au+YzVFl18L0YMtqu7NNtZ3WPkYWBHi7GI8izdPviIq3fqnjHzognGy9tR5dc+lIvx13NlzL/lx21fWx4JBpd0jJ4F+1XY90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773135000; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iMp6yOwLRV9AWiNyb8F75nL/j46McSEVifxPq9YtGl97KSgZSwdSukeLJxelLYEPDp8ymfk4h+DmTejOgq79GBSXoL6E5djbof2nZUtI6Pl33io8gI2WVQeEWyUHiNUBBNMRKk4dERRaLgdsAut+mHzoCkORWZnsx4k+li8PuN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SCCIEcKp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SCCIEcKp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SCCIEcKpSTU4OF9cjD6aNu50a8
	f3qx8CwfQJhqgXb8Ee2/PpxmZI6nBzUjzDpXmXcIEvFcL153xkZfKFtCxufo/0GKPU8l7wFLo/IXn
	9g4qhHVpfvv7ccAJ6Jam2dZR/9OF5RBK4Awly6SGbySAueGLXtz4nkFeX61vm+pKL3LEZEn/UD2ii
	gSxWAynmdxDFFowYIW8MoxPC35dBSKOWEJ1JR2ddCiQ7pjLY56785P0cYXOvM49lSjS+7/pgz7syC
	v5LCd0FRtiWs32VTiK1+5gik068ZJ9D+AwXlgqQk5dB2f94T1aN3I50LmK7Od5hbtQVD3l9qS5mmU
	XddpgT2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztPa-000000095ka-2bqV;
	Tue, 10 Mar 2026 09:29:58 +0000
Date: Tue, 10 Mar 2026 02:29:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/28] xfs_io: add listmount and statmount commands
Message-ID: <aa_kllRaiNDKxwn2@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401912.1183235.4457290707960864446.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401912.1183235.4457290707960864446.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

