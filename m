Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198E6480DC1
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552989; cv=none; b=L2PTZrCcjfuN4XDRA4B6G9z+lBvMckZ1daxTgDqgo3vQkeR3u1SiWA54RSnL1TxrTpA6TY/LiwGxcHLTjidHSj7eohxqaU0cdTbFtW/RIcEElisCkPgX6NAMnC8bW+waBW6xXTPnsIzUYjas2wZr0zZn7bTGQdY3BgQDjxUo/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552989; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hy+tMR2uzJJVL7sWUdOD7QmnAaSisu1UKQoMVHh783U1v76a2rZrnG3luDrwxloznNvLPZNAUFhDE2QlmhnVcbmG5KuO2/3/HgOlI/VdfT4fLnt/YOOmgitPBl2yz+MoYOD4YjaEQFXiMzzOfBMfQzkrYUDX4SQgE6QQs8aAIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0AhK/4eS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0AhK/4eS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0AhK/4eSJR9Do8FK5OLt4dbc/g
	Ae47vDba2DOzQpc5oFGJGMxCuuVrSCRt3QVQAY3ioWDRZoSHTNY+hclNRzrbVKXRkRwO56xckW37T
	178vAlOxT993UqaIoeoN1XeR1MnwoA4buZj1FzbW0sYpx3dZ72pkfMuHTygGhao9f68iSRtmNBpqh
	FTfKsTf5TPmByC5oNNIbsHSW5aNX+vbjzZbYvO3OvGiMkdNhf8fBxuOOLj3kgTx+rTaI4DT8yFhKp
	DuhleCbIi6wAP2NEfoGJOpqPRlIVz/XoqwtJIFT2FBdoHFxqevkFF5uXhPpm2l/hr5/ap3Uutet0I
	Gm/NbA/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS0I-0000000FT4O-1sOQ;
	Tue, 03 Mar 2026 15:49:46 +0000
Date: Tue, 3 Mar 2026 07:49:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/26] xfs_healer: don't start service if kernel support
 unavailable
Message-ID: <aacDGmHChySuAvZ2@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783546.482027.2803579025725758958.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783546.482027.2803579025725758958.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

