Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5A83FBB9
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141069; cv=none; b=fzgSPUqxpYDWaxXuz8fhHDi3gAWgMMgReSaH97YrRoDhlBSPAhRqEhdgpNIBnzCA2axSKo62Is00U/Pa3LYhlZLntbD5z5ht1V3VZdCq6zLyF9477YxePoRKgaAExypsQ9XfRu3OYmLdcWx/5vmYikZBZ+5Tvgk3aCCZVLsYDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141069; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMYRJGiksTEKEyLS9Hegitf/qBFeIcHnBqWh/8T9tJMqMFIWVZj2esKxZF/I6acyqgxpNIaalh9meMe/7DbjB6mXNnHWEfCBWL1gfMCSszHGVizisYYt9WoCpKwPMNE3n9T6t15ur1eMv1o5rp+M7CTtEORTQKPZq3qQZxPvlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AdVSniWe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AdVSniWe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AdVSniWe31dYKMVGoTeKJNAcUx
	Mp8FV7Z6mdtiAxsy3kcOJVSg23o3xeEwx4ndYAhshZmJCA6kFORzOj1wJK3SvGVlY5XcSZsM8EpWX
	x3VUiR361nbf8/Ao0N7CkTFekcPT4g8k3RJhvVSDtQkU6Aqc1k6YzAj2Ta6h2YqAeie27Mvf4Lws6
	0yOMjJoCDhPKfk7mkp+ZbrctWqFHRejVibnAq/n+yqDmudVq5Txpc0nh47aKfNGZ2WoZSE7wu1t40
	oB/Yb033d44tVag6PmyTrOXzN2/+Sn3wxdWzpmAiHhJVXhn7CkNt/tZuMRp3J6B3KEoyOvUKqDxbV
	OnjD/GPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNfP-0000000AHbR-2jHm;
	Wed, 28 Feb 2024 17:24:27 +0000
Date: Wed, 28 Feb 2024 09:24:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] xfs: ensure dentry consistency when the orphanage
 adopts a file
Message-ID: <Zd9sS3ZJibICNfMZ@infradead.org>
References: <170900014852.939668.10415471648919853088.stgit@frogsfrogsfrogs>
 <170900014911.939668.2979959228257871407.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014911.939668.2979959228257871407.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
