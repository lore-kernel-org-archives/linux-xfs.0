Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D87B22EEF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389317; cv=none; b=Nn/1uNNc5VMc+J9CukA844JV2mXTMUuO4LoUSLO01x1O2GfQ4IrnoHXBy7VmXULsZinL4GYOX1VQh01CWEtwNqcw0vN9C58aq3V7YVgK9hoG6LSdC25NxhOqq8NUVi1zkoCvxl8AEesnm/U1KIVwLRNsNqmVPy+0ZLvPCcP+Y0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389317; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQWLuNwal/eITn1nJe/cj8UxNhCu3WNUh6tfa9gtMKhRjEv6IQDRTTHMtUUot0kfRKmuD7ppHi5zpeiNNJTy7tbnwb8Jz0yeu8fMrWRsR4i9dZWaAg+ZyIQQ1aDlFmEJI83kkzjl3h+V3qNDqPf3ByHAhHRIUJMqb1PaSDBnGEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DthCawps; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DthCawps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DthCawpsXEh3ri/V/EFFs7b2nr
	RSrCqhhMWZan2t0m7B3rQxXAVtlT7NOsrpM46ddZBgaRUZWes6fwjW0SEqGeIrhVHYf0BWl2lsHhM
	ipZ25aGkfZrhRZGY3R6p2Faw4/S4mjXQdmGoj4SeDYoVMGfstc/gkKv2IWQjP1QxTUYw7iymQvaB3
	SaXOGbK3eTwm9kGeXGVOnUk2xyaYcWkeXZA7LzNVpSZamy3BUXpMJojQOkWPMvFWXyMTwpZDlm81A
	iPIY/zkAQYZbdszlxs1gK6u0k4U+8wcK8ZgLG+jtu4Enk71czBGq2IZaO6na4/mUUnhLSXClosstc
	8r/jW3bQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMQt-0000000FFQJ-2gpQ;
	Fri, 23 Aug 2024 05:01:55 +0000
Date: Thu, 22 Aug 2024 22:01:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <ZsgXw8gIHxD-_MFf@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

