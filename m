Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0125270818
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676303; cv=none; b=N8a9ETeybw64ac6+KeUX68LHcHGY6kpignt4IzA2vqcK1DgPVSMGIGU790wbqtOaYPi2B2NA1RfedOIbgg0cwtKa4DNXjvuWQhYlf13+OoMd3BQaV2KBvjrf0X78aiK8twhTW1kuYcbt7/7tKVoZP8PWudXDx8B+3UI1nRatVME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676303; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSLWbukULMIT+BvbvZQo4eGB2oMVxYOMBYaZM4uG2ZEejhKuEwfELwBb3E0LyCYILmEuJFpBCtSz9O5rUvUqpQE392waielENptLHIe2SiIwLtEKhVj/DW+EMRoHZWkCa/7Xenm6oSOgyvk/ugQRy4SJ2CuTPkG8uCKqU5KAENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JifDpJI1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JifDpJI1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JifDpJI1hdWRM3Jrw8wQBa3b44
	lC5nwM2ktLB5ck0afBTIb555YYwyJbbCqHrlb6VvdLs+j8fH+sLVhJJJfWnW+dS/8mFuuIB64F7fv
	+XA6tA1jQQcDBiq/zeAX58lx9pyC1etuVpzG9sdvhywOoPdW1eC+92hQVipNoaGsK8bmr1KisXjdU
	TfruTyFiwrF852PyxUiYjgEb9GmdqeFFZpzi9H/b31vP9yjxAr/90m2yKcNnIq1XTUjnl6++ayqlL
	TmMKx006Kr/ZwP3glwlGrfA/Z5ROTCpNNwJwZ+arouttCtfrngdoo7rWlM0SP6JNxevRVeI+xLr7e
	ZhmeDLjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWY1-000000045zO-2WGQ;
	Fri, 20 Dec 2024 06:31:41 +0000
Date: Thu, 19 Dec 2024 22:31:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: prepare to reuse the dquot pointer space in
 struct xfs_inode
Message-ID: <Z2UPTYvUc0ns9wcX@infradead.org>
References: <173463579158.1571383.10600787559817251215.stgit@frogsfrogsfrogs>
 <173463579182.1571383.15818445474562864524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463579182.1571383.15818445474562864524.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

