Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD6814D439
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893708; cv=none; b=HOGLKvNEtnk2FZoggFR0Qv4lDyAyx4E1+N7bMwtBt0c+Xw+DS+1ftaJ/bkHJm7P3H/kJGUyDa+FH2Zpk8nQ7ARxXVVOvp8yOmUFrw2Uww3Y0ScJkwGGKaP1jLB5kQ3s51mz9yQHFLx+GJRJrs+IumEM7J0b/hAi/zKbv/dFcUeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893708; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyMkivKl2J6Uh8RMdSpKd/vOxbm7/SjuTjoYOHLdQ5obT/UY4tiOor1L6CXZ0h5BgSCV+lrtxxu2e0l2YatOVCQXZVlBwVcO0xMjAEHJnERSyrsSSFmkXPHvGEc2ZV4gSDOW8NHiKRMOTdjElYpmNJuNK8jPM4lSqLCnl3Vx4QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RQAVnU9l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RQAVnU9l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RQAVnU9l3COvH1mCpt0lIHMxf8
	+7uZtNMA+OzbGsWgnRHSXvTfRjC3oApRCL6JAgurA/cHpQlqsf5+DOAFRWWDl3mUCmHWvaWulRZQu
	tznI4YhOgHbO1/r3AXKIFGHuK4j1w5coniNn/+wlFOtIb0qcN/Nv3UU51vPhsbJAKEyUkNzlLzVTW
	NS8W7wDK1vh+9hQESAlFZWBf773BUxuxR5K2ep63AaUzvGEPTEZGS3uLl+r3ZH7baqZgh5GvBMT8f
	R9TG3FS9fIPRFVAbtIkQBPvsrqK9izW4BPuNLHumDgZzMNs5EoV7xEfO4SmYVsDxy59Nx0/cLZ0a8
	cRRToDLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GEN-00000004E7B-1Uoy;
	Mon, 14 Oct 2024 08:15:07 +0000
Date: Mon, 14 Oct 2024 01:15:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/36] xfs: use rtgroup busy extent list for FITRIM
Message-ID: <ZwzTC7bZO2h1azas@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644865.4178701.14743583176720902710.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644865.4178701.14743583176720902710.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

