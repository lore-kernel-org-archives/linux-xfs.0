Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EFE150981;
	Tue, 19 Nov 2024 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996672; cv=none; b=daKUKSe2mPYD2v8/kFELsSGlm6rN2VWO/V2SW0CVcOBVBnPVJitvTcV4kXRd98Mr7lRMtygU+IChOynfbGzYGho+s3yKxGrdDQw5HCY8K5ZPhd7O/oU3XrNbkdh7/qxgI3MRH45Yl3RCb6DVih+rcWtYDTCze+RbPc5uSpy7Tk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996672; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMqmGAZsNOCn9w6bw4Wa74/5A+4+jwmNptNLxAp18BUWmXl2LYFc7siNxKiOC1gF7zGZYAorDxRg0n/OEhmwH/OhlWJmbp2iIBkxZKyc9XhUmtFQkb3pEVmx0wIC90V/7THnXro8a+iqkTmWkn+gG8rmhySPOJ0nvIs/LeQt8s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3ir9ScQB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3ir9ScQB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3ir9ScQB/buOWovnCK4B2RBjyM
	E7+9snkEWfsfmYmYMd4Rpcab8M0qUSaWWSq96miY3NE/zDZPFK+T4TXOajU7oZizL0zSFesdptdxD
	/PK/GdNm0pywJaXVmTj6mRow0yZTrjNLCYJDk4QCnnRZD8t1nDCl87rPD7KB07e8We2Xxl7KVQtXl
	HddrwqVe4331enLxTMVSdB9PWjJvssJlBJwqi6e3YAtiq1ZCDwH+jVTbtbbTa6zwdXsAvyjXb/iPV
	x/zZ/44nurkO5qE5GGIhRGlCM3CbOQUwadZlnUMq+MnunC7Nltnff6A3Wm2H1fgIMFy+bYWbITkfR
	Cs6oWuKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDHSA-0000000BV7j-3khZ;
	Tue, 19 Nov 2024 06:11:10 +0000
Date: Mon, 18 Nov 2024 22:11:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs/163: skip test if we can't shrink due to
 enospc issues
Message-ID: <Zzwr_iwDDuzg2KzK@infradead.org>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064517.904310.3981739368234759783.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064517.904310.3981739368234759783.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

