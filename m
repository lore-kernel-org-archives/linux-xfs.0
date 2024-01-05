Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFF7566E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VmgPMKvo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VmgPMKvoP984DNBjMUmEeVZCA8
	CYfKdvmT+wSUbcaxy8RQnhTBi+/t3KiwTyOOo4E1drFV5Ce2w/WSIKlTQFJNQyDH0M2qN4Cmv4kLl
	xbOpK7aMdDUj///yhJDrOPjp+X/af1AF+oPqaDYZVzfUk2HjpUb//MtV8vvZ5eWna8rbVIgKwXAA4
	0sc/pDzMY4uo8dm0TmXls+fRylmQpOYz21bpygGdOkHu8SQT/141qH3HpdSVsDFZJyx4dDL6VqvRP
	+anXApG3EkFML/YET8NkYF6i+GgOYrh3zGO095zlNG40FfP493sNtl59voFIj1KgwOAL4qXZMldzg
	TaJPwt6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd2j-00G0Sp-1Z;
	Fri, 05 Jan 2024 05:46:53 +0000
Date: Thu, 4 Jan 2024 21:46:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remember sick inodes that get inactivated
Message-ID: <ZZeXzZqx/umyYncW@infradead.org>
References: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
 <170404828845.1748648.14811776992278882263.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404828845.1748648.14811776992278882263.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
