Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4C24293B
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754908974; cv=none; b=n9ZJML8/GxiZcXaERjaKJkwD/m+z1UTyEXSwe4D44J9RryNCGH/3thxSO+kYPzEWEgVeu5tpe6kT1lpYuYThedk2/X3Pn2tYjEtOmYLCC7EmffzXIU6m4TD/1vGrXyjsudcrAO/mvUL3jZOr6LsztCq9P1k+o7lYrHxlaW4qM70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754908974; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tzoemisgd7pUoOjcX95/nwVqAG7EK0fWBO9xGCPAarTYZF4KeglxnSiSNjgiyRCN8Ucl8Bp7J4qsBtR/DA0ZzpEMe8yA/LQp9oQzsd7sokNZR3bAhyMCBrfAobJ9mE+bg8GyHVFzu1mxVFiEbwZU3ZykdRKSdUUaAu/4sfQ6mUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z+9BTF5Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z+9BTF5Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z+9BTF5Z88VPKLawOFFttzwTjN
	r7TlETu5KGdunPpI+cELkSgz0esMos0dQhSZXNmrqiwmkGGMYgmwz9GPrRcjsn8nADz0ETIGY9l8n
	aIyIcc5l/WHR1tOBM7vVFLmX5OlKuvIL09vPXAL5ytwuPXeXut+9GXWBQwSz7Xag8ld9KELTvMgwc
	bpIy9hfRTqv6yA/qr3ca8uHhHKC7uVjmHqa19542VQZPRyCmpEQpPn2mKV+DELfId33AexBu04YGb
	gXX+c9on3RG9WGR2dTh7iFWfBLXEZg719fOVMagqL6O3M8uDJ+hsK3aVncycCUtKTjqic6FyrLopa
	forSJdRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulPzQ-00000007Mxz-1r2t;
	Mon, 11 Aug 2025 10:42:52 +0000
Date: Mon, 11 Aug 2025 03:42:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Nixdorf <johannes@nixdorf.dev>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] configure: Base NEED_INTERNAL_STATX on libc headers
 first
Message-ID: <aJnJLKz2Km8JWko9@infradead.org>
References: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
 <20250809-musl-fixes-v1-1-d0958fffb1af@nixdorf.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809-musl-fixes-v1-1-d0958fffb1af@nixdorf.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

