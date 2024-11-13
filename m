Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED3817CA1F;
	Wed, 13 Nov 2024 08:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731487609; cv=none; b=NSnEaYhkPXCNyq58BZVNgiEsOKwCGCXvbCL497z7OTtB2KYXcxR4QCRiYQeyvn5Z5DMZxyEgksvaPSdl8x82u/j5NpcCnfzogXSZsc26pk9x7U/wHFlazAi7KZ9AtI3LEGYuFCfPkQ4o0RLO4F/dbox5wCmoCuw+NSQ/ofWXSPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731487609; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAtq80/4L7rl26YYhWR2po9NtBzZf7iEky+gdJBOn+tch/4aJB76QNh6NXAk72fLfWyOnZ05roi8fr/63Ze2FSRfRy2vegcnZI800qLw5PH/0JjV4L/zwm5TFQHWj8tbLFuXFRN9365BzDlS2xl9OomDznt/5lG66fKcdq4hKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M+T3XJGW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M+T3XJGW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=M+T3XJGWC5K6PQ/zImb+NoTrNO
	efz/pqyNYTvdPRvufEt3xmQ2rQoGv5HlvKfzn+NZQev1/gR1DP5N/bvZQj+CHXEQ2uZiCUWJpa2qN
	4bk/l8YNwsdKX3MhEga7GCJAsRstBVjgnRSf0/Z8ez5+ouCIO7Cxvnxjy9NTXFlbv7N8k1MnQpok9
	BJ9MvdvFyGTyGDXokIaIhlfGRR+oCKpGr1aDLOsMTf0qEK/nG4/DTx1osj8pPk2G32B7o0PENK5o+
	4miOqqQpTgVL2KxtO8lg4Ep+F5ZA2KOXIjrloqR3HZYbF3d4g13QwucVIs953zojU6VOuwXnecomv
	HGDrXBEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tB91U-000000068oz-0Y1Q;
	Wed, 13 Nov 2024 08:46:48 +0000
Date: Wed, 13 Nov 2024 00:46:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/273: check thoroughness of the mappings
Message-ID: <ZzRneBDB2V6SFfy9@infradead.org>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178829.156441.9898313568693484387.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173146178829.156441.9898313568693484387.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

