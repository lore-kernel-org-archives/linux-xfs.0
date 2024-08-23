Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BF66E2AE
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389351; cv=none; b=Ar00lo3CG0J1hksjFntv9mI7h5HkH0p4vuaQfME9mJsaHkUyJfZFVXzFVR+3X0hMSCxF7Sfy/HgfiYbwF4O20BYwsGpnVCz9DVEFJloUJprsnbDMAPw7ArEt1KAcsIFxvaGc3ctC3PUeGg6Z5O9HQedRrgpM69Ur4BMKUvVC0Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389351; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcRo5lJ0LTuxKaF63KxZeo+kZgRrSDpMSe2QiDp7qcTCJPIGfqkOO9LmH9lId7mYhSu0DAxR2p9XKdHtUoRhR2JKpjTBb3qc/o0riWRkdfRVZ9NbIRKnlgzwNh1x8GtLkpeThqIH7HEOSKqkrL0OpkqwZ9UILH2UnGQ74nZ4ur4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ohIu6S22; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ohIu6S22"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ohIu6S22sQilzYa5TP0GSRLJXU
	/v4huPp6Nwn6ApPsl9HmVWfNJYOx2gep03+6acmyRI9YpSU2h5/V7nkySrTGXRveL5qvVQ9hhX8wE
	apfwObXtnohsfAmteCTZ18de4SspmrQyMitUKlNb8NzXVpekax9cRgcLlKVqhLox8qKI215NVs23w
	mEQII7r/sFUXJ3cpISs7o8/DtxrVYumXCUoY4PyekYZ+iwaKH2p7iydnLZBsO23oS+13Hhzx3595A
	dj3rnB9RHH0GlKoEe5sus9AqSyUH86+Osl4G9NTAGmBWDjHKRyFXe5MuL8/OP4/3cb1pDz8cp8ryZ
	OWV72/9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMRS-0000000FFZR-0g30;
	Fri, 23 Aug 2024 05:02:30 +0000
Date: Thu, 22 Aug 2024 22:02:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
Message-ID: <ZsgX5jKUJdMDKtxX@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

