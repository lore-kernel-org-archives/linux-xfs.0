Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563CF3D6D;
	Tue, 26 Nov 2024 04:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597078; cv=none; b=NQYqSZRVUgeDD4sHfiOQagfILfVGQl2gbvtonbR/UJ0B62tlukp3ducZtUmb4rGLpa3WM02eVnAo/1eL0kCN/8ML6cXkfkd0x/9O4DN/II6rmume7nexNzRrSub285C+zMZ6CezVmGgg7KVxFi50tr+t27jvYTgWnYCo5+xrc2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597078; c=relaxed/simple;
	bh=wd27anNa4CXa4hRS4wey4clBJtGT1Jjq90IWpUcWWvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ko/hxpAUw0LNEqEqL4KOS4xspt0/jfZpPQQLjReoAVb4ve491Q5JOHFrWiMBy5nljulkxWqijLbJom2CDjMfSFqnFL555loBwdJ24pjGeA1SWbnYMLxauscRIwWMZv0Fw1qeqHFV6rLNurj07fy+FOJatHJpTgOCZfhBOi7EE/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jxgkzlqO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxgkzlqO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GAGGA0lja0XWeHD0VA/V4pDHvWQgheHj41RYcSIQ4O4=; b=jxgkzlqOCtZUpOmDTLSuPc8IZS
	0236cfj3svrXxS0TzWROeiWj1Rsx9/cgwa9OiJkj748UWVWwY3ynsCHdzWzzLFQVIF58EsG2Yn6Lw
	bQX7dbDF1rwdWoiKuJ0Jzrg3eHfh8PGX3uG49tCdFh6ZHeltJ8Wr+OjWg6eVjfyzchtW2x83xcS9p
	qV8iky+PpExFj5Bgw84ouDWkefGLJUG6ayH3eSzu8k8xW5d4oYWqe9Vo8LQWlMq4mFjBcl5R6Uovj
	DLsODEHAQ0EncqXA4gFXT7OWrXYZhXC8isKU1icSJjVGP2fxE8GteYrkMIUagEwJLkAhShjWvPT4A
	UKIqmlFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFne8-00000009dg3-3xUI;
	Tue, 26 Nov 2024 04:57:56 +0000
Date: Mon, 25 Nov 2024 20:57:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] xfs/122: add tests for commitrange structures
Message-ID: <Z0VVVKx9kBrEML30@infradead.org>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <173258395315.4031902.9082361530245352300.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258395315.4031902.9082361530245352300.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:24:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE,
> which was added in 6.12.  This will be the last ever addition to
> xfs/122, because in 6.13 we moved the ondisk structure checks to libxfs
> after which we'll be able to _notrun this test on newer codebases.

As we'd say in german: Dein Wort in Gottes Ohr!

Reviewed-by: Christoph Hellwig <hch@lst.de>

