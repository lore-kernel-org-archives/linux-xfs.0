Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E770D1FF1CF;
	Fri, 23 May 2025 05:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977217; cv=none; b=H7Iq1ugMTDxl4CDf+i0UKM5RBjH4R2/smsQMBul9l68faRreE+WmR2e3wGzs0XzggEQVwJRZL55EaGdOUFNJKsLEadA0piexteufHtj4tWJtzS+QgZkONUP6+EkvwaWoFmzb5TNcoAf2HV/8glOkMY49IzPxNhtHXereSHytKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977217; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcmSm4nFM3zX9n5YNp1w7pYNnbL8WpY8hipOrPugL7Fe0DWVc+XV7FLC+YrngPRaBdMXBNNjU2pFDPvTSzgt1Z9AhjRTAfunqtfBMJujCe3oXYM7j9wwaJzC2J9Ap5ukPeTc/1eh5YuImzjynvs9an6feiNlMlC8jcOgr2PLxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rQTPE+g7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rQTPE+g7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rQTPE+g7HKS2o/uy5jWv4+1Y31
	0IIZT6HNr0zVsROO4AZ8q+wb2CgNIgvUPxQIShDJWZHO4+CDii0c5sURenHuBb3WjS0ijedBt5xu6
	eS+60n/v1Pe7Tmq+ZJnvJhcX3QfZsk2prP9SCVUXoQf8KV1YyZGRIuIBQb7wdn/bamPOdJg6tDpm/
	aCciNzGLfRrGg1nEQfuwU8k8gMl3BsFKIfIPV4AezKET7rTK0c8Fpnllpq6Lo6ERk63iVi5eVUGJH
	v1Ha3nF6K22r1fIBlb23zg4oaGl0LjdJV6ALX33dXT6P5QtL9n/mjr/zh7k2O23RaJfNLllrKhvpy
	AgrEAPQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKit-00000002yjp-2rSz;
	Fri, 23 May 2025 05:13:35 +0000
Date: Thu, 22 May 2025 22:13:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] check: unbreak iam
Message-ID: <aDAD_2BQWQJkWN9K@infradead.org>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
 <174786719750.1398933.11433643731439553632.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719750.1398933.11433643731439553632.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

