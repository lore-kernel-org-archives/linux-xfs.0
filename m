Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F57353EC1;
	Tue, 10 Mar 2026 06:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125141; cv=none; b=dsOHDrDPROQLmwl6Tl4WN14ndjtUmLy5MSY0Ltw2zaQXd16pVLtj17Es+YMbxuAgU6u7weiYi/YSHH6fV59c2lzv4yvRHIavO5igXgzM9tLOSr+RC2/flakd5REs3fBOH7P49r6WzAAg5ZQoSMWqekhRX2BpGAELY0RBYD11ho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125141; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=otZO6mGOZJgA+kV6UuPi0O0+ckwLpIv2Boo13O1gO0zTENG1psywxXVMKxzUf2cquGL9Jn6uaov93hURCtikg8zXvtUw63NXUMWFvu3pLGoXZxrZlTGC9DktxvxLSOfZFe0RbgAL3eR076mxA20FA2lIupDMrTckw/EN/ePIFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J37o9zBr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J37o9zBr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=J37o9zBrLj50/cp0aK0qFENEVx
	IAMFNCA6ZYeAZ22EBV+hL8XEkdsUuIbTyONBAFvvK3IemehuttIXBrzfaNZscJgGZm9a8KyP+s9n0
	Jw4oHFRNKY30IUqkujJJGPWaero0+ROxnFJnyEYg/6EC8epRXnyQSYZMABAHPST1hzAFoOI7X/SGq
	+tfDRTjQv0n5Yg4rfKBsPesojs/YSk4fUL/pWvUm0PaYvt3tjPHmJ29qzXASRI6pwdHGIyXOtOFsD
	dO6Lks9OaFMalX2V2+dZF1K4YSM7/bhZtjeBEw+Lsrmsft7yN3UPq869HdvvxtQhYtYtKj8BN1ZEG
	84lAhPvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzqqa-00000008neb-2Fwz;
	Tue, 10 Mar 2026 06:45:40 +0000
Date: Mon, 9 Mar 2026 23:45:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/8] xfs: flush dirty pagecache over hole in zoned
 mode zero range
Message-ID: <aa--FCNLVuq8VCT9@infradead.org>
References: <20260309134506.167663-1-bfoster@redhat.com>
 <20260309134506.167663-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309134506.167663-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

