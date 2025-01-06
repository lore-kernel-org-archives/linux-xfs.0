Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FE82CA8
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736162016; cv=none; b=jQwRehPfBuHP7vJLvNR08qrr0LE9aWQEA4WuHpZMhsuhujsp9EYr2lVpdvQGzBurZoqrB6PVdCANfLG1KDCPe5mmDt8NsgFTV5rlKT8BXg+Fn5w+3+K6xQ+e/tRRML+kNkXtiGGrC0/j3SV2SVmLWJhiP+HXukaq7Z1OujfPyNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736162016; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jV/vz7fLD12ZsfFEC4VBODtcaxgtEYqvbYLvocCJISEqiAggI8jr8r3FWLGP8vrk2Jb5YoaL8WPpXQQgipEcnxS2z9wcL5waJpHIsX7T4F1Zy1iL17rhtWPIvX7tBdrGn8BLHD69pRVLsk3d0T/eq9d+t9WeJCvsHtgi5i1jjuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qZr0DUUP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qZr0DUUP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qZr0DUUP8QAjkSTcbv0nVVZytN
	O4CklPdRGuK8XCZCFqb0obCDax78Ti5Fvdb7ndg71z/JeOSP0zzSIuJ90M/pmYGlFuLvlUMpi+Xgn
	oQ/hfPoQ+GAWpzrpx/nxVvS+URWKOLmJNKIFpRxf2Td/hghSmoUI6iQnOcRoI5QFpRHM0JEbrEgmo
	cmjIF8xKCFAo5vsWzQ/yzu0WjuBFCRzzSuuU/1BVYJqrdLZyrs9CNmJdZY/S9UREcGbiG7BWv2z7P
	DDsYFERZJBtLSa8x+CTKlQzBEVeuLpk1LyP3x9iGOJj6iclrEOcz3uubfmsVxRV1L3AiU4iZr3yPo
	0PHrOxEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUl39-000000010ED-0guc;
	Mon, 06 Jan 2025 11:13:35 +0000
Date: Mon, 6 Jan 2025 03:13:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH v2 2/2] xfs: remove bp->b_error check in
 xfs_attr3_root_inactive
Message-ID: <Z3u636ODjvGJe9xU@infradead.org>
References: <20241223114511.3484406-1-leo.lilong@huawei.com>
 <20241223114511.3484406-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223114511.3484406-3-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

