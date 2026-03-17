Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F127D35AC12;
	Tue, 17 Mar 2026 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738811; cv=none; b=JE8E7l2TqDBpMpb+t6PTsHZSXuq8VqozbngfC/005kKI560ua/tR3/fFeoQTQA6R8FlGAS9ImSBG1n6s3JYad3jn/M+wKP7pKphKmoHWH4bu4xFtNNz1zZ/9RM2VLTL5T5w66EcFxnjIUCBfAYyxDcrNbu6Kd0pUiAMgqThKHxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738811; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YSWD+1gB5+UOvK4wyI5MAvI3xzcVvCIHOg1CVH4CMT+T36pxSCBml1uluNBZ5K9bkoRNt+cxhxe75FzqsnIueEs7HYbJAJbm3aurd3GJxzRUM03LZL+4ep0o/omoqXZs5r4pIQGjdMmVPY1WPqTBpbehnzWvKsWhMWYpm6ITuA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BZEfUmjf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BZEfUmjf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BZEfUmjfEtUJ/ppUv3sy5gJHDW
	4nkO5/iAy4HmYsWdvUbqxTuIZMYcBuTPqPM3bWoQ3gLlnAVQ504BoJXqITt7lj0qJCijJwMK36X5f
	2vUo9MDBa/q4O+W8oytFMuQBaANnjDOF1/IvTijxBnmvWnCZStN+uc+FoVSIk7gTI98xU/Z8RUuUZ
	fOLDL8teHPCK2ce9YN0F5AyQt+CuS/mhFZ7DkPBAD1ijCHGiZkoek4SBUKaJRGhRMXBsulJ853qHT
	fKmiutZ816Swlsf+57a5wY9fM991aVxVmw55pYd4EYWmt6CPC5Qkl1Jh1GX9lHGxZqj8wAT1TJtEL
	JB1g4qlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2QUS-00000005p2C-1vvK;
	Tue, 17 Mar 2026 09:13:28 +0000
Date: Tue, 17 Mar 2026 02:13:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill Wendling <morbo@google.com>
Cc: linux-kernel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Gogul Balakrishnan <bgogul@google.com>,
	Arman Hasanzadeh <armanihm@google.com>, Kees Cook <kees@kernel.org>,
	linux-xfs@vger.kernel.org, codemender-patching+linux@google.com
Subject: Re: [PATCH v2] xfs: annotate struct xfs_attr_list_context with
 __counted_by_ptr
Message-ID: <abkbOM-UbuMCRkWE@infradead.org>
References: <20260303015646.2796170-1-morbo@google.com>
 <20260316184200.840020-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316184200.840020-1-morbo@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
