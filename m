Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EA45464D
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 05:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778132090; cv=none; b=N4m8PKSrBtz8Kb6q0VKRhheHF/QHu3VjYPfJl7z6mptHJQHR0d240O6MuuEgAQOj8to7b2jcQh6lTY+4A6uVbjMlbNtGz6L6C3Vue3bi8j5Ne9unPza4GvbIbdNvkdeCJlTTEos/Ss4mZmcZUx2GGurtRhuCPRBc6ol51UEZzD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778132090; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fynOVvVSJAw73YhCLWZlO41pE9UjjX0/nscxWvYIR1RZSsdJXj4r0ycaDxD+IC/pYy/nwae8PXMVZ/289oBNxY13HermS0pqd6G3Wol0ceqpgz9qASgwq6BWS1LFfzELlpLIm1lIROP5GlXJIhOtn8fPHHAnWm0Pfek/fZ3tJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IR0eaqV7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IR0eaqV7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IR0eaqV7wL3EWfmA8+keZyxvmW
	TDfrA1Y12zR0YWzSHQEmhUSHhqXSRa1nZFPykkiZ7gizMYS1++G2iODLTEjv44iLJ08HopdCJjpS4
	ux6YGu8W9cdQwgdKJeR3R7Iz5nF+6Zm6uFtqmAYA17S6N/Ye0A726ORCQ6F1qF/aF3YM4+XxfnqnT
	qxPNEfg7L/mXcAZZpWhZkVVLbZpmDlSY3cFkyD5DJOg6QfivJg3bkQCqf8I5ADuNoWn8VurOHHjWP
	pYj4YNjVF+WAHWzPmPDA82Cw4XkHPW1NRGeAZs41j6JCQ3YcP21urg3ps/wEqakbbsYSLuxysQgue
	jAVBt+kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKrNo-00000002otJ-2gnC;
	Thu, 07 May 2026 05:34:48 +0000
Date: Wed, 6 May 2026 22:34:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfsdump: update release.sh
Message-ID: <afwkeGZBsfn9SFF5@infradead.org>
References: <20260506163746.1083845-1-aalbersh@kernel.org>
 <20260506163746.1083845-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506163746.1083845-3-aalbersh@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

