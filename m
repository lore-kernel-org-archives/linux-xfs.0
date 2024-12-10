Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B8E433CA
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807769; cv=none; b=Z2UCGljziYY2ry5xvOYn1tGjlt58gXebVqbs41kjETFxDRz3C0MGNLOYF6BzMhed3Xdlw0G/3rgNbb+x3LC1Svz0IefyeUp8mNPfCucQgwewrFEvjoa+tZQrmB4p46xd7uoWCkM3cc+NV9zksna/cuCR4PB7Q61cUteIUPPHNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807769; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qao+MQV36ZzVyARCAWy2VAEIKtLgs+UuhD+zovgbX88ZS239XPp8n2A2Lxl6kK76faavJhxhdE+mOBricMeTW4KdoIHDbWHaXdeFGE0PsDMAwR931LG2eW/NtbkG/+R7JgrEH3yiy/4dV6YA4jnGwF4xaLigdfU/KEMKspInB20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bpCmtxBQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bpCmtxBQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bpCmtxBQg7Go1a4bmdIYwDU5Sm
	BHfedZbHNeLfuqjrPoxXV4fE/dzic0dsHPZKob1Z/Ds8I+d35oW+yQPDev5oTsqmG2DRkAn/+pnM5
	IYTh7KAl9QUFxkqO743awq+OSBOP4C7pwCfHMIrwgHEn5ZJ0Eof1Abk1xhb68lkALvoAxnTTWVze8
	HKrEQs6whLQGuTFcBUaGtHS1N6wq/MnXgNGuE1NOE5AaNBeNkiIMCd0Y9ZflBbt0p6ncR5i6sB5aP
	oBIfBwJcwfGb46F5L4zJKM8CdTAsovOfQResCuGc+Ba23LilROuSV0/gb5TPCSRYARTIP4KhQtuXC
	UkRhm6rw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsbP-0000000AG9E-46su;
	Tue, 10 Dec 2024 05:16:07 +0000
Date: Mon, 9 Dec 2024 21:16:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/41] xfs_repair: use libxfs_metafile_iget for quota/rt
 inodes
Message-ID: <Z1fOlzoTn3HMT-pO@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748664.122992.1499549460905283888.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748664.122992.1499549460905283888.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

