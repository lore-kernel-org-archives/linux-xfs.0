Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97165288D6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552807; cv=none; b=HSxqbOYecJ6nM2StUyF5A7AqNX61AZgwZUVJrLu28kbK9Pv6UINuINZtuPsslr6wTToOcNCCShEbAquP4X7R1lLIdgPDqyNOYLsL6Td1+J4gk/kNPF+p2fDHl37uNAGsnf6SRmP0MJwE4Dhp9xWiRlVSTECIahUhmBZ39w4LJhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552807; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwwtaG9Rk40A30nhh3DyiOqjkAOXEdQHAdrfoUWTvzGgH27dfg8S3X6pltKCF4OnuKQAPVHKt6Gf7L87C59F1Ug0IVSz8nMvTxF8kjycUkRhV4p8ZYuRATOljFUxcmiPa9L8NdO1v0SJXfcCfeYIfxiUGbp0nG1isBWEOqDlTA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IEQiXtEb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IEQiXtEb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IEQiXtEbKb4ATrxL2v2qJlEoVe
	TcQ9g0PMWZtxwmK0SeEFSO3yiuI/YSq1cXC1RtaPXyJZSJzyRGFMP9AVrFz+srRc1FUG5yy8qC8Ep
	QDy69GHVPSn/P0Jlr9eex9hfAkuL4Z3EDV98UWDesPUf9Ww6IxkJCbrDPqMKTmpajzotU5tGc57l4
	GW6P2+2QUIKf0bUxhmypJynYt/itFoUqfhQNh3VK4nH71zy/LoQ4zrSIKhBlOdzTdaijQwPt6yFI0
	AUAQexyAyg8CKHBVIQGsrQMKf9eCx4o9uP19VVpUtAD89wvSvnkvWE8M0pZvKryBvx0gBbpt0SIv/
	3GaAJong==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRxO-0000000FSH8-0kHW;
	Tue, 03 Mar 2026 15:46:46 +0000
Date: Tue, 3 Mar 2026 07:46:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs_io: add a media verify command
Message-ID: <aacCZunz8FbJMelb@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783435.482027.17497369764350488146.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783435.482027.17497369764350488146.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

