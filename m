Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544BD228397
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811513; cv=none; b=YMXvB49AZLKLn87Fv4kyO9fZ95IV85KMIyQAcBuZ7yWQWSoKnOCv8Gr/CKmMibLy5oNhL3SLaE5FxDOMI3DcpI2heeIy+yfQ9cHUIdLJNfwgzct5iMLbZCjoDr5686aYizE49rlDNgT4CJEdQUaR1mMof9EtIwB6iNrwK1+lAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811513; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmHNg3HyO4Tk0+j4o/2hTkSqw5sXc1LBuV9bkn9O8pqWnqxMadqDRXOO4TzAMwCp3JJ5eOzxJFdxrnkjhfEza6ejVB2i+9lBBQEAbS3MEXEz6MPZ5inDvLb58Rk56I34hF/55F0BkyH+Vi1I8DjFInyaSp2gVF5e4lhWwW088vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cSdStK3N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cSdStK3N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cSdStK3NcqJ39WvwvaHvItlp32
	ShjfnMiT9HroZZFzrVagKJ1zXvV+KhK/KyGCxAiLTWeLcuwtFR7mAF5q86ednAA1W+WVKVcpuwyCV
	ipeeKJCCPtaqkUvGqo9UrY9LphCKp3DqA5+RbG4n6AH1Ht9C8lGF0t2jTA1bt6VS5pkB4rrLAXUXJ
	4AT0MfBWE6GnUCSZvTamz6jGRYBGSzjqDuVnK8btUDJ5d7OA6sVYHN710eRcLg/3LQTNIJuyrN5RG
	ghaZWO5H57lPsUgNNd/R5CqM50KhxBG5LPWoCifhWQKWlxDyh/5074aVQLZ1vD5DBQVERJ2JFG2/c
	r/hIr9lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtZn-0000000AOWy-3pV5;
	Tue, 10 Dec 2024 06:18:32 +0000
Date: Mon, 9 Dec 2024 22:18:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_quota: report warning limits for realtime space
 quotas
Message-ID: <Z1fdN0JXisq0_0hU@infradead.org>
References: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
 <173352753972.129972.7804228230884394394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753972.129972.7804228230884394394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

