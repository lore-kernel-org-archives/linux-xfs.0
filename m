Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6012D2D81AF
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 04:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505835; cv=none; b=e0NwjfxlMvVymuuZIx6vqd2NWyKdqFmw20ThNRMg09n5/N9URGJyIU9fpTneXUzVaReqFLKdzHIriIpZr2j7XI/eN6CJL6lEag93nljNdsgPabjszKLCj1DWL0bdfjQNJa8+PUk/YXMySYLECD/BPjQARStYMUuBTAYFmKppXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505835; c=relaxed/simple;
	bh=YHK3e0VALqqaZWnt+3AEcrxDKfFCmmwqoS7iULy4yls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u23GLy6qBS/S/xG8EIDEiMm+T5y0o9ce3dhjOOA+A1p3CS/PwITOp0O0J/ahz8XOQl1aUBFjuhh9Pp0kzdxeoXLfzpSRqkINvQLZROvizyCn23pEhZxolwofKo09LbIv9Q8PjSIZVfmKs5I9+6n18inUx5oKtfGxjIwxY4BXrMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XOx10+I9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XOx10+I9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lAYyS4cuaLhm0jON4Z+NFtZ8bdZ0U3T0irjgZLZ7uHY=; b=XOx10+I9iMHm1yRkCPoyVsVn+k
	J3P+6X0Mu7v2pRaqKeEqg0J5Lljfxe5jDbhY94h9IlNO8kTkDxHaZmQBArVnIlOaBXWxkSFzbL0RM
	5DfshcblWTKRI3JtZRoPgzko5ZpqXoB3RJ7S3IUKsVR2fhJb4LQclaHJ8EliNnA9JmeqQKm3AWYhq
	mIwxol4qjdH1Q9NYWhaUXUmBRUg/CXxmXNEKnwrv5jHghpD7YtC9TuJwdQj6fBGFHzit8j7xHgWdu
	LqS75a7pFVCcxcvPC+URiZtxvMz3sAaoseDhu4UkU20IFNkZBJH3ppvJPn4+JHO0cOyReuKKXNESi
	zGi+wytA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uC9wu-0000000AE8t-2bPR;
	Tue, 06 May 2025 04:30:32 +0000
Date: Mon, 5 May 2025 21:30:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?B?QmMuIE1hcnRpbiDFoGFmcsOhbmVr?= <safranek@ntc.zcu.cz>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Question: Is it possible to recover deleted files from a healthy
 XFS filesystem?
Message-ID: <aBmQaN5EAmwfVYaP@infradead.org>
References: <18512e-6818b200-1ab-59e10800@49678430>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18512e-6818b200-1ab-59e10800@49678430>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

A long time ago there was a simple xfs_irecover tool to scan blocks
for inode signatures.  We never managed to port it to use libxfs and
the code repository for it seems to have disappeared.

But in general, yes you can scan for inode clusters that have not been
reused, but it is very low-level and dangerous if you don't know what
you are doing.

