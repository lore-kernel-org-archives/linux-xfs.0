Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F008C0B;
	Wed, 19 Feb 2025 07:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949692; cv=none; b=YGcK+lic31WNxlXyD/mu+sjttgP7ozInRFpmtmW0jISdiHJixDs5SVOLcsI556ZEpEtwJVfUj+WynzZ0UEeEfhEp2nVAufC2vI/ScQFi/gSdB1roPd7mBl4OJEfx45GlEJSZ9Kvq5OF9PTgWN7DlF220IjVRm0U3qs6NJeMiDMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949692; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sbgsf3gebVCGppKwNPqvoK6JhgG7DMdDg+rTM+yeKFT9wkcwLYYTERAhx3WueL5Nu8ERAjtNlm3g3iQomyAVc6yz6RdDh7BHBf7pf+iOxwsoA0imVSWqqtxWd62qY2rFHDdflYqDFNb8eSxxi7xCOC4oDfYnfYTPlXev6UQksIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l3zFBLuu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l3zFBLuu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l3zFBLuuMiTYRCIxbgmsyTRpnY
	BLwIRns7Ai+NJ/uBaCIciBe6ZgxLLuWXVH9cPutv699A2ugFwYKaodYM0RL1vruh7f+TgmwEF3OT5
	XbLy7ye1pV/G/23UUW7ZJcUoMNTBB1P9S7mR/Utup14q5JQajZzZoLfEDPcLJRXshLRFSF8NAX9cU
	9AOqS4CHaQpgP+pN34sTZ086LsTGE979YGdyhiIS0y/aSfMLzlKwSwu0TTZdedC0sBGVczhLtEvyH
	5xdEMEZ1KYoSv3Mc8XLVQxlfgsHnXUQKM5xEy2uCp6OHvAY+SLCdYi7dInbsrVS52+CKMk0P7qJS/
	aivFdOtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeOg-0000000BDJJ-36u2;
	Wed, 19 Feb 2025 07:21:30 +0000
Date: Tue, 18 Feb 2025 23:21:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix quota tests to adapt to realtime quota
Message-ID: <Z7WGenUU7lGs_RXl@infradead.org>
References: <173992590283.4080282.6960202898585263825.stgit@frogsfrogsfrogs>
 <173992590332.4080282.10618286150841183831.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992590332.4080282.10618286150841183831.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
