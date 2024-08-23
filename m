Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3664D8D0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390427; cv=none; b=GMkwaPw4VttexJE3UKZKcgMo3q8P2aWCmdBPyQFI3fU746I6JS+Vo+qImwKMjuzWWqEo3dqxg1k9vNxcAAKmVKColxenAp6weF2pQH0hlq6RG4IbkhhWLcIYqLKNmw5vjYM9rCkV6NdVxy6+55JsiXlJJ8ML+9Gvut32jbnOnEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390427; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxzKVJkc5gdiWyOoWgLz/kyVAIl5gAyA3rlnIycbajHJqIADXrPbWNav4jHHsGXF2HmQJA7ZNyWEDUnaQyMIC05Ae+MBR7YK/yRy5pcqDsH5pNCI+8onXdwq4aLt5880lTCMHD6dzRoIGUg/ql0tGj/ZhFaa0nynT4DF+A4OQwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PZ4QTTnw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PZ4QTTnw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PZ4QTTnwuOz4FxikPvzg/+OtIs
	E2min+0PytLZHb7cqClbzL3qkILMEE8l/Eig1v0NA1BGGoV5eGCzYrlvuXQaiYPRBtrHcvObcTXRg
	YqRLnInlXh/B75a1zX+9Ub3pLt/MXHkx2jGubs5arCmq5qoujcSOv2vx2IMNf7M5YJw0VFGsvdiG+
	WP/iuksYhoSBLo0rFxyuHbycb6Zaqw/htBPrxTZaM/P2RhcM9oex3BbwPWq9tEsdJ1tfY+yjlMRyC
	GHR3goDjxJiu4iPZkAsSoD8ogC8TIgBOSQ6irf72sOiXAnyIhTHjCkqb4bv2Gc4AuvuZ7ouWxI8qK
	FKGuUX1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMio-0000000FHwL-0fFQ;
	Fri, 23 Aug 2024 05:20:26 +0000
Date: Thu, 22 Aug 2024 22:20:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/26] xfs: mask off the rtbitmap and summary inodes when
 metadir in use
Message-ID: <ZsgcGkWRAZRZdqmW@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088974.60592.14197020803560709058.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088974.60592.14197020803560709058.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
