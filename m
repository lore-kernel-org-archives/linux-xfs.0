Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30CE10E3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724157; cv=none; b=i6rFSobAs4N3slTOXVYwHEGsuv90jzIjrjdU6a3k2JUa/lJTJ3EN8UWg6nQ7LQQftmNmLge5vbTI9qH2Gx6RcqyD61jKDa9RfzbRyUwItLNLvz5FQkEMnzDD2P6AfEiv9Cf0ElkGZHm7+U7TfkGUx60k8NezAPvh5SW165ylcbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724157; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvpuSkrnXl1ZQoys/NRMZxTdbXONrWF+LGwwfqdUy+4tqmJeGugmRKJRAo8r/zmbDqX0ggETRaFSi7KEP8LXBIe9x5y5ryLQZ221nj7lnVEWzO0C2KlEMgCpr74hAJBU/0sXJ6GNY1hKQAglQS6zT+Vu9mnFHDF11/+tTF3Gm+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YixAqyMF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YixAqyMF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YixAqyMF9tLroJWNut/rVAK3QC
	iQ2/vUQlQ4t4Xf13GHRrDZOT+Zd1ZU01+ztB/jc0jG4TToloK+bZQk8196oD8IzbRfE54IuK1nbGU
	52+PYm5mgvzt5BsVViEP4qZmAzZwa5yAvQ/K2AKxi/QFAUSffFTc7KHE0QV0OKZeo4hqP9n2JAzR2
	y8Wwdi0tryjWA5eph2J5KhLytbTx74m1TJhznInZKOwlyoiC7g6HmwPLXaJO04ykLdwszoruwJdtM
	CCEfGNGMX9mydu2TARw7VYY2cENUUxez5t529WtAI94sXnmWbunvEwf4U2PNqORw3cpQd6xLSvERw
	ZhSzl+Ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPn8-000000053sJ-3Wyc;
	Wed, 10 Apr 2024 04:42:34 +0000
Date: Tue, 9 Apr 2024 21:42:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't pick up IOLOCK during rmapbt repair scan
Message-ID: <ZhYYutfY5aCvH99i@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270968005.3631167.11200418428870190784.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968005.3631167.11200418428870190784.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
