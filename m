Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75234501A
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711718; cv=none; b=V35SAaVSI2g4psW2ZiCn5mQxHDkF59N38CmHAAIk0XdxiFfSY5Z6gXPCEXzfCHmaozlBBX7OB344zUrp7GsHfhEb49zF56aIRafKjfsE7Jl7p+KQX59UYZAIxnVWXjZWeCs60uxNmmvR6PoQashahS1TuOdqbEDRZUFwrJdzWUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711718; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNrh2Ns/OKT/wQVFLr9rwFY5j0eYnfmh5p5Tk4w9A7Eykzlx7+bkBNue/ObGE2whstYHpkVOiOJzKWhVsU2tD76vkXcyCe5X6FIoO9IxB3za2KuBXAr7gq0u3hTfYZg4AhT/Z+VX/lnBHBUULKhRjhU+XUhmhpsCzFswiLwHCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=imEwKr30; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="imEwKr30"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=imEwKr305jpzsOj7PJ5aH2wNX/
	G46NKDAzVaNKHBR4aFhWEPy+a7kppkV4cabMQnjwZpOF9SEnGjchIKGj/5PpCCMak4UJWMPOjyPXK
	BNuAZ5EyefnGeh7SCo41YwrfMBAVB3BCo674AZzt6TkgRT5lQicxzDcx963ZVn8nFEyo5sVhHTkx5
	OeYBKdpmHnYtA/AGrrNs38D6FQNfvhbqehpOog5V5ak+oICdZiHTDS/IIJMoxh4S7mO/bmxtcbitt
	pBK5zQ/+GGgQIOiymRaTplvuFbhIGSIKJCGFWidMpQt67TP6L7x9EVgNP25XCThat0jVo3TEfy93i
	myNNWGcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1twEvU-00000000lmt-172f;
	Sun, 23 Mar 2025 06:35:16 +0000
Date: Sat, 22 Mar 2025 23:35:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: fix stupid argument error in
 verify_inode_chunk
Message-ID: <Z9-rpL3BKSuWp_aQ@infradead.org>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
 <174257453669.474645.15431452443530778898.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174257453669.474645.15431452443530778898.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
