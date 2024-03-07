Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAEA63121;
	Thu,  7 Mar 2024 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824618; cv=none; b=Bo46fVXrlLhmomN+Goqd+Cxd1kAWuP/kTXFqacSJz+3YBsGWhqjYvvk2O38rBAbbK0K3Z6BDfgsHSjp7wcNfxw2kfjhCuuO93BuRUoecgTvhbD8Vp4cbvg4Iq93OL1UeaVS8qyotWxgrpgLrW/1s/CoLRTm13jctAXPQlEmFWvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824618; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeLs9YVNlN3SUR5mk3y8qPLXDLZc59nIvSQ481tp+tFYPdbkJ5MC7T2ao6iOZYQdooY5a2N3jfHyV6eMXmMifJVciMUqlvLqvsyUH8Czwi9L3Lx8vebPdEhrBlZ38Vgdjgdc1x27zg/KZ+fUszv6pTuwgDDrTLg06eHbMyVusx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xTFF6QaW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xTFF6QaW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xTFF6QaWHrooDJTcK4B9fa82NB
	BRzuHgPkA6q+3SBzM3uca6gNVuHMaaW70J+yl8uldHKIcfX+10OV/bvENHNObi6q/xgL0lYjDkF05
	0OI94w6RHKHJ8cEJ+8LLIQ9FytoypHLBGYTTI/qMklC6+Wi3QM5SCMgyyHkIDg1DGjsgCoxHFyitD
	PwLhh8kAptls/6Iu10bEDXpXqkCHGoUwdXEy76PxfWzHz46/084f4ZUxBYbEIPzh+eKBy/yS/8cbZ
	kiU3KngAERhkWB5eiLxyAFzDmjb3CvlJnNVuNC6nVCZWNPk4Rxy6k3MhlmsM1XYKTcoqipm7fR/jw
	IIUkdj5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFUO-00000005F7Z-2B5w;
	Thu, 07 Mar 2024 15:16:56 +0000
Date: Thu, 7 Mar 2024 07:16:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: small cleanup in xrep_update_qflags()
Message-ID: <ZenaaIA27MyR4SaQ@infradead.org>
References: <72f966bd-9a5d-4f57-93fe-c62966ae6995@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72f966bd-9a5d-4f57-93fe-c62966ae6995@moroto.mountain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
