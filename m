Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C673BBD7
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884778; cv=none; b=noueiLFWz1cvqpHB0PtYP36Cer/EY29aKCgx68SBvfvZ9luuFHd6wcg3L8KXsi7MPtyrVLfu9Rq0/xMZdoDLXsEuEtJ8AhyTwjoo162qNEKu3tf2o8i4zXZ4+qEDLlRveS2n2EeFlYLI7RbIqiF5PLvPuahxOMr4qddyY0RHVtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884778; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKWjbWqub2BdjfJ/aRi9EcZpNOpxsKO3knzqzsv9zqGQhoEHtItlz65d8nwdoLD95Lg18HnGiY86qjIB1qnUnJWhPR21eaHEF/cMaccVNUZVnVExBMnFTzpbJiHymoNbnvfjVV+C2uokekTMgWeHaSF8OMUUJfM8KT4Iigim+3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NrbTTgRW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NrbTTgRW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NrbTTgRWnFvZ958moBkH/13Ngp
	yBZoTLeuIm3qOnoHhPSUEHVBZX0vYbbOSVR+BpLNtspuKF+JsoL6EOkDwgGW0Di2SRiqjj7bnj+9/
	usNUa1p2u0rtyKFZBDEsmVZ7aScWJVMMCRwWBdF1+MzRSwGoNYFwNHbxuX+yPYUTU/grzs0nF3HJa
	xotPEAxjyxTV3Da3Ei4Yvjv01a795na0gCfkYVZL6l8eiABEC5UcyM/uSqApNZyH/rV8DZdzyWWX8
	NXNr4rH32rjNa5fWEvVXPE7dKQZh2Z/AuiAslGaOMNwMsGGmUuHETGownxgIm7nUmYvl8NAI7lEus
	0/UMmkug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmhHk-0000000EL61-1fFG;
	Tue, 19 Mar 2024 21:46:16 +0000
Date: Tue, 19 Mar 2024 14:46:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: recover dquot buffers unconditionally
Message-ID: <ZfoHqHRqothHDM6Y@infradead.org>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

