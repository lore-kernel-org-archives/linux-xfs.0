Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D121332EAD;
	Wed, 27 May 2026 06:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863109; cv=none; b=XtSsKJ0pMFH3w8wagZ3ZK5WVJt4fqAet0xppMFlMVS7QenIovqDCUpv68sacNhqWrp0yMj8t/rGPjLqo5fXev0iqvMacEeKjcrNyiT7dW6Bpe3i9PvTpcZH2Y3TDWYDloPq2GGwi0CA4kDKzmeMuBaN28b1Bi2wIL/6p+EPFpq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863109; c=relaxed/simple;
	bh=ZxeJLlGn5aO/kyfFqEzoZLTI9QlJr1Yhd++wA9Y+RCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UglFuw+1kbSefCfyxp+BeT9WJHu74nhD+liFv2s5v4yKTZf0MAmJGUL75BlCD55gjLIBv+inixH1JV3uBUGCrNMYEKDKQA2sx0mlFwflNy9MdYKOFrEeVgQlhkAKCUUlxV3dkb9qmn+I/yE1lnn5RzDG2IhlFL9keCy5UIHanVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fuzG/lK1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fuzG/lK1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OAAGMpOHkvpR6JqIKq8ItSKMxQrT3swZgbt8CgOONp0=; b=fuzG/lK10HUfZyU6J+M8YmXoSX
	a+2yeQejhqPm6tYGfP4pbUkZmB/FlJ/IuHE8JXQWqCLBkWd7Qyc9FAU/03vzLojax899iDAbT8oYZ
	71krcRgwhSXwQCh20TmcFmdX+w5GtjYOkjfuL1ZWUYM7yl0EJdajOL/ptfjgz4RsSHgjuWzSU9Uzg
	XdrB6V2cBUfRE5E4Pj/GiXXWsoBOdKUCuYONM+SOFWmpSHlmF4v5Co7w0sFgJadO+CRgOIV++s0+T
	U5x4dlTkkyjM63o8N6gPICwNVkJvotDc8X7VVj0qP7nQwjIFyIp/awCrYS/sPim0bMjjBeNaqoqUm
	MgEJO28A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7hM-00000003Oes-3Hw9;
	Wed, 27 May 2026 06:25:00 +0000
Date: Tue, 26 May 2026 23:25:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	amir73il@gmail.com, zlang@redhat.com
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
Message-ID: <ahaOPOQYaE1wrbA6@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
 <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
 <ahU9hpwrXyZChw9X@infradead.org>
 <e8d0caf9-df8b-415e-9f89-bc71e73a0e32@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8d0caf9-df8b-415e-9f89-bc71e73a0e32@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 26, 2026 at 11:19:30PM +0800, Anand Jain wrote:
> > fanotity and inotify use exactly the same backends, so I'm not sure
> > why testing both matters. 
> 
> I noticed that back then I decided to keep both.
> Since fsnotifywait -F is only supported from kernel 5.1x.
> inotifywait serves the legacy LTS kernels where required.

< 5.1x is pretty old these days, I would not add test just for that.

> > Not that I care very strongly, I'm just a
> > bit confused.
> 
> I am happy dropping inotifywait if unnecessary and confusing.

Not a major issue, but it felt weird.

