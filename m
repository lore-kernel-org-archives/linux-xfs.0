Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE1D1A01BE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734080792; cv=none; b=F0xzfxUns/deXZ4wd7N6XYEgtMg+40bfZUPFYYcn2WI5eptlMgDxG4HloTjdo0iD34mTprZWRiyU8fzJza3+BVzFfqO1gRj1ib2J6rSHbR4hGhD/qx2ZkVG1hwtaOQSRLtSgqurfp0EGo6uDnStL90ccASSvt7FESaU4dhn+V2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734080792; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+tl453GxYnPRxSu0aD0L/0dPJEcGZmigx9ruV28GohdLfZnIJK8vOf7Ax25U5i++sD4vOCIpr3eTkyWFwJ8FkKyvCnBxxAH6RP0Uw2/MCPDDcn1mJ8xmJicJgnIbV50a2AstmYSWnOXJF616j5wogEa7jDb9ym6mxFubZ8OWMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UNaSjZZH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UNaSjZZH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UNaSjZZHBCwkbj774mufCwy8xL
	UsF2X5R5IsA5HGEjD6kg4kUXh0nUUJ0ttuSOUlh3Byq1Jf4aJooAjh3Udo42UxVddPIPiSdfnzswq
	YeVJfRMEjcI3tZUJ1hHboBC55/ZoO3YUQWrkVMjEzOo7iZVZx1ilStL6SexjH++xtZrhSswzCCILi
	Rm7Go3VnG5CAzPWhV6+1ClwQkngYdnGdAudnPrMB82oRlMD4auaDjDAE+S9J+00kVx/4SYj8IkhsA
	+NMegnD6TQHvyGbGABMI8TzCdOuLRCOJNLO/wu09TWFY2F9KT6hK6+wu1TNlL6wy6eTEAgnh2klNI
	Cri51QuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1d0-00000003BQK-25tN;
	Fri, 13 Dec 2024 09:06:30 +0000
Date: Fri, 13 Dec 2024 01:06:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/43] xfs: prepare refcount btree cursor tracepoints for
 realtime
Message-ID: <Z1v5FtoAzVM1C1Ds@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124584.1182620.15734929669990793148.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124584.1182620.15734929669990793148.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

