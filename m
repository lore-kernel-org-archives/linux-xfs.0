Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB4026AC8;
	Wed, 19 Jun 2024 06:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777905; cv=none; b=etXU/cz7MjXx9/zM8ztKmFJx3O+Z5ElZJbeLUajwEfFF8oy1jU1F9NqOjQCLWiIAB1UmQleqT/7Rg080l40rTSMSHdh8mn9g1MRFrvysWlfkq2knWV0HkeLxMZyTkCrYgVK9DHWSSeLIi9LOTPnW4+fLcc+LR108paopwt8khkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777905; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjbl51smSwkB/OuPEeBUeDuMt46qhE0lBiZD5ckzRpaSGLvOTkiXwhwK39dxOyJh7m3J5JAxcWqquhLxRR8JPVCQ9jewTJRf46MtE9KArSEol4jLvXABf1CLWpsO1SPxuz0AUCtdER1IK/2O6bi2pToMHdI+Y15191u8f8138EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cix4UNHy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cix4UNHy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cix4UNHyblF3GItQctLHRxiQX1
	WrU7XWa/CqNzBK0wkH8711tHgl8NUAGn7q7LDLbqaXCBlX4PG1JYsKWDi0YtM+4gknZ/V0iP+c2ig
	EKg1voeXcm0bytXmE1j+xn5O1IKn4ZDAk75R7Vy0O1dwycEAO63u3zq7EF4snXSb02/KLHxDHnVVw
	fV93Qr26unIjuqagDtFDM3bKKM+DJoyhXsXGC9x4WFkkoAIz2n5THJlpg679fuSnfSXdtPGGgQQg2
	AK8W8CpoToyHy7rZft2BqyPb239Reb/kD9P5NK//djohS+bSUZMGRCxkJdHzU66mnYljcqgKcxDll
	SzySZgZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoeE-000000002K6-00tx;
	Wed, 19 Jun 2024 06:18:22 +0000
Date: Tue, 18 Jun 2024 23:18:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: add parent pointer inject test
Message-ID: <ZnJ4LfMSxCOAmLYR@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145976.793846.16087103036647390348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145976.793846.16087103036647390348.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
