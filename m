Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CF11FF1CF;
	Fri, 23 May 2025 05:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977207; cv=none; b=N0PWw04odiBVZgbYWBYdPgxpZpkTqCnqJdBbGQwpTygfCAXlhYNHMkflikR6ekVsEi3OFM3LM0/YaGNE0J0415DRZC7LU8gOkmY0CQaBVeG8fXW8vWgspU5UjXadaCw1ags9E//QSjFhbcN5ZTKqO7rzOARQRnRslsUVxlHmFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977207; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdAHv2NeMgBSbLBb/RJ5A984cVFNBTI0JUtAIofBjVVbsbJCrZn0OBxnVmCi1vOidAIvGobVM05OgV44waZUnq3dB756fMSL7nV06NzOBjiblY0ySIkN0rYRHqGaMqZUL4J9RCjsG8cgiBeA+ryupLn+ZGUuCG6dl4BViHJYyeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HYGX666F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HYGX666F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HYGX666FMkGwrgqFrAOaBt5HUv
	WcHCkEeYYUvqfeBqj69A9BmpxuS6+xz/gq6inhGTxZpSXSB0kT0/O6x+Wv5K/y2ILgCrBiH81ZySR
	iHYMuajWAOzo/GrabGajQ5DKOOM3lqc99yWud1lGEqfgUjT/FfM+5Nv0p+BREdT2WrxtqFLg+tlra
	ndeMTkqincon6AHBDGUBuTKAbVt3HNCAig6PODAURhL+nlJgpLm6+G/GWtv7WUEyUGdJD1SiB7dPO
	GQnZSLsG4LGduuECK8VS6FTJjf3rnf+RePDV/4+ejC8bUSKRY/A4NSJgdymMbu5E0/qcVdVswHk8O
	q+x5jEvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKij-00000002yit-3pq3;
	Fri, 23 May 2025 05:13:25 +0000
Date: Thu, 22 May 2025 22:13:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] generic/251: skip this test if fstrim geometry
 detection fails
Message-ID: <aDAD9RzH_p0tuaNg@infradead.org>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
 <174786719732.1398933.6661596329740320998.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719732.1398933.6661596329740320998.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

