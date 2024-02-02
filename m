Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48F31754E
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855328; cv=none; b=DH8t+DxHkSOou1TvsD/9rPH4ttbqEERYtZIk71MNWOcTuVTnPqborcFK8M1giOe3A7JRfORxczQDtDwV6G0L0T1NEZugMF8oh1mHY0UXiM4v3B12FmUznVO0Y1N+ISeciNbpvrxw3NDMPVacMSaPVRpXsBmUVuDqW9vyVv9vLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855328; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jec3Fu6xlOGr8txinK7WkkHhx9ww76Q5Up2uR6PZM7m6cVAT5uZu/ybc0X1+uShbRyM1kAm4QA8++GJu1SoAOIXm4Gv/UA7n946//l+A9vKspvlgGxNa7rqWZ9OEOKTkERWABnm+VfRa5CApQk0/LjwHaSmuVqDWU8myeyhQO0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LSyjpD9i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LSyjpD9i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LSyjpD9ivRIc5Q+/jTBbh/emPG
	h+tL6oH9qqWTAqiF2jQEbh1Aw2H0IetOtuXzEqE9BsKGTx2zc7jJuCyIsI7A9D/cEZ6LKiFlXCNIR
	yY9yXLnKhRTQuPEoRddEO6bO1KtyaKRJLO1tpSaYi/hRIN+OarypGplu/0hXn86eJ3yfUEiiE9U1T
	gd+pBTfUMalMm0pLXqdPklCk7XcQOx9O3nrltQIquQEE3RncXjNtmZV8MgFZPMtU998yT8Y7M52LL
	hHfMbxUd95efmBBuMVVhh2AJK5y3of0PaiA1vP77j2vg6EeStekenA8vvQ0H/bHP9Xi6KWXHYuFEj
	xGuJnDIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn2c-0000000AQ2O-1sS9;
	Fri, 02 Feb 2024 06:28:46 +0000
Date: Thu, 1 Feb 2024 22:28:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair the rmapbt
Message-ID: <ZbyLnvrZaiw7qOMK@infradead.org>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
 <170681337472.1608576.11362850463593250241.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337472.1608576.11362850463593250241.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
