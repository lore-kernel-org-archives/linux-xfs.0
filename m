Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B11C381CF
	for <linux-xfs@vger.kernel.org>; Fri,  8 Mar 2024 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709905130; cv=none; b=br3xrtamqZjUlunxQN9RDbx6gjVXfDImdp6sLrCndqw/5PFnRtKQgqWCTAB+/L5smUECt5bj7qbH0OGs6oGZZJTLbwZKxACMuuLGBd9X4XsFVb6OnecG90XWbIOVv9teul8Nqyvq8hmxVSiDis5g8yErimheKMI7Ic5jxa03FF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709905130; c=relaxed/simple;
	bh=f/jByjiru1JoHDplkLVTvmfj/+uFCChrFqLl+soIScY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuwPUmIGFlNjG61dIxXnSNXvwUehZm4rO+bbjGm/EKbS2JuPG6BCak4sZBEa4fI4qdOvhVRu9MOTsfPlY4bdu8obXwkPAxaaS6Ra0pRToZAgWDguZ5YaEqUozlPHeI2Ba6JCYAiO/t7jYPy3BFPYFcqYx4YFC7FY0rk4QEj7qVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z+0NHJll; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z+0NHJll"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=go2BoGsSLL/g7wUCPfRsZDA2R42wbsfSAdWG3EU37Ms=; b=z+0NHJll71pJJz8PWBPdYgbqnW
	8rCmBeVXxZln1TbL3fj5oYxvtm9WHl3VEOL/AyyxNhFzGZcBQU0ocDAwcRAN8EdsVAbbjoUcTT5SW
	6ipf/3bs2k3SrArUvKnI1o5Uuk8iODW7aG+5Y8fstd3Y8JR2Ebw6pZoldNVnu4xVQdexqAWjSHjSD
	wSU0hzkL3RbZuG2CR5NAd94GTRXoFtmtbPPUXa4oy7vLJE0hoPViBqIKo4JB8dTBCyLiRBmj3/ama
	B3SPe9/O/C/6cVJee5RGli5fdGUcsF3L+DjIPR6Gc9pnX0Yrz0ycVADTSYB1dAfCbeevWSdqE/FMa
	scNPx8OA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riaQw-00000009Kol-3Nho;
	Fri, 08 Mar 2024 13:38:46 +0000
Date: Fri, 8 Mar 2024 05:38:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix dev_t usage in xmbuf tracepoints
Message-ID: <ZesU5t3DhVO8HbFy@infradead.org>
References: <20240307231352.GD1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307231352.GD1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 07, 2024 at 03:13:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix some inconsistencies in the xmbuf tracepoints -- they should be
> reporting the major/minor of the filesystem that they're associated
> with, so that we have some clue on whose behalf the xmbuf was created.
> Fix the xmbuf_free tracepoint to report the same.
> 
> Don't call the trace function until the xmbuf is fully initialized.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
