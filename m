Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0727DA9C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848716; cv=none; b=fDgtpflnt+pCYqP66iQB9rs+tI6h9O48W1zKhxJH/FsGjO2B3QljH8r4dYsdhATDgEIleh65AsdhJfAkX0QEaeK0A5ku/GPr6mUdnIynPZgwwl58emS8LYZ5FoRg+pTmWgygixYo05lOFJFcX3IdpyiKpYheJv+o5Rs8a/pBp/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848716; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5UG/BQcudS9bburC7X+Hdb/sHaQ8HQYm1ZExm9yj04IM5JhyQ1K0vEWT74ZvzAaBLcechao8ePpFXQUlrViT/wI01k/0geVSncJZjFTSonlEhlTDMCYKqGeq3orRMfEoARFi8eBnviICrQ0U02vQYLVA/X4DC+9XwJiwpToIe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XJRRmlrd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XJRRmlrd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XJRRmlrdHtzan9YvV4inJb3Pal
	BXtIHmdHHHVv3flZuL05U15fvO5XnL12bB6YIHgaptiqQObLsHNN4c/SmDcOSjNZRKJRpG+1qAUW3
	EHElSFK9vL1n2L0yO2c0On9WPUwYwfIoJxvwYo/+SWpdNWHKuNjY6gGcfkFGVrZcdhkd5zPEhV3fx
	jRQCsh5tyQdYcSU1yqCTVx4Qfx4SHdERFTE6T6GKcmKXTo4cbBhBmMNug9Nnus5yAI4zLtT98EBfU
	MMDXv6WtQddyqJyJ6IihmAXm/VBH2NWxz6GLEtxXEyInp52xlzBFt71Jl3w8DFFnQf0TKlaHH9fXj
	qp6oD5RA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsNf-00000004t2S-1TV3;
	Wed, 02 Oct 2024 05:58:35 +0000
Date: Tue, 1 Oct 2024 22:58:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: use library functions to reset
 root/rbm/rsum inodes
Message-ID: <ZvzhC_EGHpTXsW4e@infradead.org>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
 <172783103423.4038674.11965044394724233118.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103423.4038674.11965044394724233118.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

