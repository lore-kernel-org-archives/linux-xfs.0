Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B402E0938;
	Mon, 24 Nov 2025 07:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763968256; cv=none; b=UKQlVQrZnPbK1wt32xp5JXkmUu4gbHLWiF58MCZDBYOeo7P+IS2uZ6xS6rbNm0eQ7wuTqnEh6glAbWpgeSbXH446qPYuZHRB7JDHliJztp31wZYRh5wzqeCtLTL9ThvKgB1LwSUb5/fpwF/qdAgdG5OvO9HtIiYCYAkHcSnt3ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763968256; c=relaxed/simple;
	bh=wEpGFvd0sgeGeGwJ9hPM0AxC6yDCYtYzb4/AujL+JtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MR4ht2YaCdeayI0JmCokC8LdUl4Hueur1klzvKumHYeFjQtNs//11Bpp3I4nkPGFpNdoaB3pDO84JWUxsQwn0bU6PXp5ENT78DkeGpVQk7TbzuspQFNwnsuCazyWY7YRHzL31MazMw83c/XOOJY7QG34zI8KsiCnwaLoCdGe3Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cePsoaM7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cePsoaM7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wEpGFvd0sgeGeGwJ9hPM0AxC6yDCYtYzb4/AujL+JtY=; b=cePsoaM7IEnMbfcocFXi1i8Zkf
	qZXIgfcFXoWzJnVvz9C7ymU8M0DNAF0FVdkQV8meshkQORTs/b4SV+7OexfPxo30Vi12MggtY1pDN
	zIGNmRl0RmKi1g5taudJbcHv5QBz3KlauIDGXx+JNpsgRSa06ASTDRockcVtzRwPcNBcVjS5anJMF
	5FGnhsjPESiqX+bCqLxUMg03LeVEnLkGh6osTeYdXXWVCUrYACg0XuyFlyuA2CGi1pmmONbOkpgmK
	xXiypXnrzPSx+JCTKaRHEWmYbDqxn2ttbRXzKe3yJKy8tyzAKw8vDYA9hpuL9eJhVW5m8+Cv/ov1Z
	AhUjKkCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNQir-0000000BCiP-48Tu;
	Mon, 24 Nov 2025 07:10:53 +0000
Date: Sun, 23 Nov 2025 23:10:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+3735a85c5c610415e2b6@syzkaller.appspotmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING: kmalloc bug in xfs_buf_alloc
Message-ID: <aSQE_Q6DTMIziqYV@infradead.org>
References: <692296c8.a70a0220.d98e3.0060.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <692296c8.a70a0220.d98e3.0060.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This got fixed in vmalloc by adding GFP_NOLOCKDEP to the allow vmalloc
flags.

Is syzbot now also running on linux-next?

