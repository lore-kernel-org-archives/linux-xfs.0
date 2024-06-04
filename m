Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6A3ECC;
	Tue,  4 Jun 2024 05:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477578; cv=none; b=A85HZu1weDdwzF7UMItqtaGycHMj0QCMXlyBi85iuETcGDqfEilvT++/v0syzJi3x2ZWsajYl0zGCi29ghjAL5PwLRaEV04TgpoKr/dtLLnv/vyKTAcLkZvC8ecomLaawXgRSdz1c/pGV0SdslQtjkjb1To4WKGslzyyrqRdnmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477578; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdEfezsjlkAvRFOCZ5BJsw40SjfDeWAlgDLCSFt7rYXbv9g1Jle5YzpBNDQyrlrQE2No1edHp5plUfMvoiidJAPPdgjY/WdnQGrhKg/iTal5LRz/Fr2IfQ9NVYXzLpX451mK/ykc+JDJ0AngoqPD10/KnQMoDG0uXXpDO2CUmuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DsrD83T6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DsrD83T6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DsrD83T6w0Gn06o/T3ZFf3Up4w
	7jpQcH6/a9DfhvNZ2+W8F+DPbs+jLzdaUsXl+yUlNgvY6x9Dt7cooO6D8Dld7G/SXaUqmK+9GCl+I
	/+mHXwFfL5AlSFGPylZ7thPPnmX7W+m4KhPznBuNYbvJ77+Gjcz5EeP8ih2L3Wy191s/tqTsBuyXF
	z+lk/HOsWYh4HHiKY6eifd+hJLQY6WxkUI+YILFt/qa/lggH4mDCwsflyFAe7G/TTj0relg5+skZc
	cC8or42zkVeIeKsOFOqn67XhH1T2eh9AQVdFxCm6NlSTmfTquDG44MKcDIb2mG75korE32KdTVCGY
	Vs5UlFAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEMNE-00000001DYU-39T1;
	Tue, 04 Jun 2024 05:06:16 +0000
Date: Mon, 3 Jun 2024 22:06:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 1/3] fuzzy: mask off a few more inode fields from the
 fuzz tests
Message-ID: <Zl6gyGurUCcBsqYQ@infradead.org>
References: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
 <171744525438.1532034.2611558250304665559.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171744525438.1532034.2611558250304665559.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

