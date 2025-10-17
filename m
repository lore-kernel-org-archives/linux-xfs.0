Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF0233468D;
	Fri, 17 Oct 2025 04:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760674719; cv=none; b=mKdaNYtFuYkJno7qDV4UUKP97Wti+uJGF5Up9lJTFHi/6GDlpE/n5AEtsFdvLB9fwWb+TNWCvFo/m4x/CWIG9xMr7ItIL+0sseBBuQphp0C56wWZgVJiOyDyzNLSCejFflohnde29dJw/TiBAZ3thbeJRi6NuuLsFGHpdFllQVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760674719; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6egPQQ4JFKef1wA3K9Aib880HIfizWGqaw6faTEOuh2vnlRFfjvi9LQDFbA2+23Fm0aFPQNuw5X5pZLFx0rTCXwKUXbiZOOfN3ZpyJhjH9OIV8ZFVy0lyZeRjkrYjrS3TZpzFKI/BWBxi72kJEeWJD11O5rxnsHB3N3qNjQ360=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jz6ag/22; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jz6ag/22"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Jz6ag/222EfzCKWlB7Q5pLy0gF
	DxWTzCIZl8lObkFRtGFWubUtMA2+P/b1INB+IHFoV17BBreZkFveUutjQkdqNXfQzKI1CMJwYcu80
	nl3DGsmzLSqSgRB/ivzdCB8oknpp8gP/zOe/OU4Yt0AKMyGb5mMrq+kBKqe5/EJWM8KP6kCT1LgRr
	xqWx3qdXvXuv+4VF/8VUryznQTXi/Lr6bO3ojPnTXz9WBJs5vW4fvafgwhWj0Tv8nmFCHbEesa7p7
	8zvGXKjoJnqHCcQ8QufLbdbNCGiQ0ZHUmT32klb05RBcftpSzBAfuFpwxTC9FL+G2VlrdVv5FqUbs
	/p0iSw1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bvJ-00000006Vu7-0sAK;
	Fri, 17 Oct 2025 04:18:37 +0000
Date: Thu, 16 Oct 2025 21:18:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <aPHDnSQJIYR1bhOq@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617913.2391029.5774423816009069866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617913.2391029.5774423816009069866.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

