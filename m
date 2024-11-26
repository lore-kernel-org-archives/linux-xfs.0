Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B4022EE5;
	Tue, 26 Nov 2024 04:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597014; cv=none; b=PGbjIV6ECJestqn3sovv1h2/2BTFEhGibPZIWnxBAsSmcg0JoBGrGGcD4kZqMy5VKSH4APE2rpcSLSG+7QtEWsjLcm07GItO31DbdtGA6eZFwyfSiwPOWRQAyMjLbjsLN+lGviHqVfY0nKra7DwAwWeL3pGJGaIBmr+ovFPZ8S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UP4n/XQYCwJmcKjAO1UJcfo51Cb054OxYms0cIg6voG95UkTZgza3ZYAIPb4y2DOd50mkjdaC7aYpLFXxMvQVf4cNZ4VYWgHuTR1IV506wejx5XVtr++Mtbh8Ntje8yErrD/mVmCPx8Rw4R6H1+B9QKA0NnX4oolS3VF2H140XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XkymvB4P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XkymvB4P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XkymvB4PJLDJCf6vb2UOKn9JV8
	AKezqC+pWNMz+M87mblBuPcFSmWBctO5W7yuEhudAccyXCMRdPfWmdplyERSoFJfDhS2j0fIC70VB
	IEMY9a7qpOVTsyITvTlqxuegJhLtWFuVG6OkybFzpUW0H7DuC95EldBgpzb5JnASUlEsU/gwyKdmT
	v94MW7Cv4x8nmveiVZ5UtJYV0bSgEQNp44QgGBOE5X3itZZ9jz43CUX+BxE1aCa/lS4U/oFWG4dqe
	PO89BOPSRoGqH2zYU2MtZ0qdXA2GP97O82PAZRYXGRZyaBt3fs8umWMMKA4HQ7Vn1YJcoglugSbnz
	eJ8vxKNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnd5-00000009dZ3-3vW4;
	Tue, 26 Nov 2024 04:56:51 +0000
Date: Mon, 25 Nov 2024 20:56:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, tytso@mit.edu,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/16] generic/454: actually set attr value for
 llamapirate subtest
Message-ID: <Z0VVE6EoGeoNNo_1@infradead.org>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <173258395299.4031902.7236733593217096781.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258395299.4031902.7236733593217096781.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

