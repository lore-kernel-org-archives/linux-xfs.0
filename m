Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF371C3029;
	Wed, 19 Feb 2025 07:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950936; cv=none; b=BWvZef6cnu09Qr+bpGdMBlKIS41jH4srmmQyux5OVHrp2ilb74AMYniz1jvzlnwTnd5tOEl+DN7zlCacj0hRaUU3bQzOTssWYbPyKpJWc4WkGKoYZcG5JhI6k07TMiPJ12e3C68gw6PmFhkfsbFJG7lsEq3ygywiCFIbfxmnI8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950936; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBLf5PTtZELeCD4rKd1NH2Heeo6pivys3ZglPNT7t8nkb7nuyLZaRZ6ZHoO1cxSdWWy4JY4o+x/hw9+PjZX9afiQtbcW7gL9eo9/iN2xL3kVTSoZRhFk7JG23SByRVVxzE24BaxSRVUD0V38vhRgTh5MNpEw54KYwFVtMCVwzIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r7Y4+Ka/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r7Y4+Ka/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=r7Y4+Ka/beotCxmKOX79HEYch2
	gLKhwer5f1fdBSrIJ2FoCmpntgrx8SfKgGvt0jxRs7RTaFgShrCO+my9Qv6IPRYDTZvF91YhKSxQI
	d4CAJzfjCeW66lxLdVcLmLAUOplFeQM52aMOjtWSqk5mIRap2WhBKWmbRrWU4Zy8qJrwoTAwh+pZj
	nefdxE7HPz8ZARRfYIuYvxBYBnpR1cUcyeMF0rQt5BwddBmI3i5qeZdGvmSkY08UQDUzGy4yPwT5I
	BjJr9tOb7aycx/rqsVR5W5kVBye5eXIrljeEyljrKhfOEemJGZMIFp72QkfoKcZNRQYJnopXpdCdm
	P2JC7veg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeil-0000000BJKh-0O2Z;
	Wed, 19 Feb 2025 07:42:15 +0000
Date: Tue, 18 Feb 2025 23:42:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: create fuzz tests for the realtime refcount
 btree
Message-ID: <Z7WLV-fmqdOTWRku@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591790.4081089.16064589606169363675.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591790.4081089.16064589606169363675.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
