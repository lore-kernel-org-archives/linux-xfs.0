Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5241C07F3;
	Wed, 19 Feb 2025 07:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949264; cv=none; b=Le0/DgD4mbaUyNLF7iEr7IO5oVjzM4uNXiq0qj9c4h0TEmFurJjiralAz4rb+7Jf74fljQ1BtLcgKjAOcUcVx7lryHx9KB/Lom8WDMFX6nPG3z43BhTfJPGhcbachKDmThllHJge4zT85QjQVr+6CXYjuoB68/W3WJ1G4D1aN4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949264; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdcGkQmmCPIUWE7IaPeCNY0vJg+cdNXI0//Vmb9kpwhrcQLOROZyEZOSgmWpvJngcYRJFinv4nKpkurmPzs0U1X6PCvn1JLAtyWc/GcXON2nqBKB+9reZlUl5N2eeWm7GRH0+HZkPLc9RIYNDiITuO01IOq+n2YtsxbByXb/CtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TMdDIa/T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TMdDIa/T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TMdDIa/Ts33ewbuVnVOo9csZJz
	l1rrBFmtxrIalgo7Ihp5i0GZZxVjLwpHIid/g0BFhBN/lEploGzzTaocxeNfwNG9NW972bE53PXXS
	rRcBCrqlA1pcIzsovD6fG84h2WnI8fu2UdRjn+TPUm1qbI9mwYlhko9gMtl2nzQyDMrFweFCD/dwN
	Yh5e05nBDQxDs3owthXFxfAYsoyyP9rWwalGYuez06Bbi/c6tXvASt/IwJWi/amcRfSpzJNYVN0hf
	nc6f8+jrhCHYVdtJqiixnUTCRghPG2SHNB8Dpgorglomk4jq702WrOjF92iBgAPNu/IKVi5TWhyRw
	C4oQArzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeHn-0000000BBR6-131k;
	Wed, 19 Feb 2025 07:14:23 +0000
Date: Tue, 18 Feb 2025 23:14:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/15] common/ext4: reformat external logs during
 mdrestore operations
Message-ID: <Z7WEzxuZ5HV8WWY8@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589272.4079457.17538661785920086668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589272.4079457.17538661785920086668.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

