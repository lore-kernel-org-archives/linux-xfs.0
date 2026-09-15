Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76953C109E
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 12:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475083; cv=none; b=EwdyFWd0+7VD6N4F1KoOsNtDIC8S5zQ+z17w6lSEKbTbTlzLZz6CUjzx8vLKEy9qDuzyEliQewas2hvGq2Q3Zafn0HvfhhlM6+qVHj0V2+vDNeLQ7UlvxIxQi4MwRcFrLK6+1baFB5phaS5suTwosg4HgzIa1zlapU0ygI6jFV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475083; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6y8LSrO9IT1Q+6s0jUtS32SrNmDJ3arS5JOYpb/yU5izCdb9aTCLRddukabvFEnYM1mxbxSjqlzp7sFMyTDVi70SQLJkYIySxJavQMq2tXc8OS/kU3A3UQEXFpU+XrptySiUkz99+Mvwm5Qd8b7YNqQND4Q5/NgatB6idnWgZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qmn4QT8N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qmn4QT8N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Qmn4QT8N56v8JnhzwYYIw7v+tO
	fRu444eaA3yFg0ak2aQ2yKdYgNYMjMMrXELxAl9MsZdKkcj+U9hfeOUA9nVXkeugj5Cw/FqoMu7L/
	wkuAU5UfN+bwmKdhzjwKjZmSCETvothQ87if8mAXlX5fKJWJBxm0gr1aKWO/yDUJIWBNyQaIpTD1Q
	y8zw7jTqUpAYBpTffi3q6x/VDHdftzEt+mETt6ivDDURAPcWsVe5FatDd2mljzn/1mUaYWGZtSUfa
	pJkjH52PrXmrG6aeD/2vyAwwudxCyXuyIk/h5lBnSsKncGHMaCQ+y7Wq5I1XQS5NXFtB3ByW+pUdo
	VVA/XgPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6SDF-00000006TyN-2tCe;
	Tue, 15 Sep 2026 12:24:38 +0000
Date: Tue, 15 Sep 2026 05:24:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: hoist xfsquotactl out of xfs_quota
Message-ID: <aqk5BVhbKtfXXnCK@infradead.org>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
 <178936484825.2108717.5578837464044937948.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178936484825.2108717.5578837464044937948.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

