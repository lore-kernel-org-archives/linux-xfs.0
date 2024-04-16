Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C248468
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245039; cv=none; b=J04ElBjq3TkEpRktYePT71c+7TYtNtDIeb9uTz20cgmiPTeesojzpwOOyzuKo59MTnJh5nFuStUWFPtZ5V9oaIJ10uy8rrQM5ymcwauXaHtxDSKefQss36rmg2l3GeyAaXAHwUAU/1u3g3JZSzGYMC99ULrOfekwuSeTpRLn75s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245039; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=erMZO7WjfIzodtHTqki6UEtzsdQ+SkCb3eHEYHTK6USvClnPbZ5m3IfAOFUuxZkTiNXNx45LyHWjEAV53TS5VtnVgjL+rKHFhYTVvK0QtIRP5/8YcEqn7G8mgPm7KBSFfL1kRYnq6D+2qtgMWqeQ6ZqLVKrkDEcAVgWt4RwKRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hP/au1Jb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hP/au1Jb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hP/au1JbfKhR5VxJ/0UEn4kOrr
	kyAZXjD8KInO2NSbSyi2aZ8jT74V+PyIwI6s9l720Sk2bO/UB08Hs9l/yQEwPBab6q7xtkfMfNIrl
	HIofaznWRtZRXvflfn8mIkHI1rNMEWf2jvLnKLXVCQJsmlRn4u3lkMVAGcbj4lwI0ZiIaXjfhPiX9
	iKxJlGku8qdff0R+wRnlQvXpQPytGFvJH22cmk15pnPMD71hX5zdxUm54eUWiruqsTQr7Vs1fgSO+
	J13DCcXtta55e4xoddIyqgOOCulJr0YpI4ggQYGaZ3l0Bji+r9+fvBH+6kh7PsO4RbbAo2yd7Px0t
	tWCPuLbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbIT-0000000Avsn-1wqP;
	Tue, 16 Apr 2024 05:23:57 +0000
Date: Mon, 15 Apr 2024 22:23:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 1/7] xfs: revert commit 44af6c7e59b12
Message-ID: <Zh4LbSs84h398BhF@infradead.org>
References: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
 <171323028683.252774.4862531675710024941.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323028683.252774.4862531675710024941.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

