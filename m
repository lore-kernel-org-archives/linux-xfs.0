Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B251BEF71;
	Wed, 19 Feb 2025 07:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739951009; cv=none; b=N7iic8z2m8nz/+Ba7T3c47XLarujakVVVTUMmuW8+tgLpYVItnDgeeuSYhn/silu/O7rek5TJU5TvJuQPPgdbzWJUWswJG7gg4FW8I73RkGY3Bu/hcmFa9/kxx7JNcoslgzMHzthxOfAnxQkXR/l68mPCSpsAoEujhv1uQc6Huk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739951009; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqVfYv4yqaevDw2Ad542jUyYaq3XJZ7FhrbxijP0hL4xOBdN6AztXu4LngZU1SmBgTTWhfb+NhgCsjrOHWXQEl+JgR7wO2Q5QXBr3Q2s0XGZ8Gl5vuWZunt/BqWcCuRBbpCEcqPk2CH8OMDw4Kw+ZuM2erP1YCE5UYHWeUuu6ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i4N7JRxg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i4N7JRxg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i4N7JRxgF3Yu7DeEF+YqohUOeQ
	fRcmrhoUcQamPdLssIV1U/w5yCIS+Uz/Q3M8rw13XeEX36k5tcNcKFLhw6xCNxyA/TwG1nQwfEce1
	6U1J3KW86l6mQGv5XbdQROL+iINddjlidxEp18MaODqkZvCpIgKvWHX0nDLhoByjq3LTeu4X6QkMP
	2WdNwAgjqYM55rJUkzyE1nUcSc11ZVdcLWc9nxFmhf34H1RHjNLD1wgsMyOcwANWTKMNQKAqVu/52
	YeIZXD7dFczETdYQudkGs+pYGorKgxJp5EB2UeKdqGn8zFgyGuHwSRz3lbbZoaCRvTXXXNy7DFco6
	Wg/mXHjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkejv-0000000BJjc-23h1;
	Wed, 19 Feb 2025 07:43:27 +0000
Date: Tue, 18 Feb 2025 23:43:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: race fsstress with realtime refcount btree
 scrub and repair
Message-ID: <Z7WLn1IXX5sgDpLc@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591827.4081089.9026111603191501024.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591827.4081089.9026111603191501024.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

