Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AFF23717F;
	Mon,  2 Feb 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770046544; cv=none; b=o1PpLJCu6J8RJtrxtN8j34fjO8YmnH2q2sclqjrFMvFe11VNBRUG5bg/AfXDbqEM4fx6tIZZamEzSjSWAjXNHGjD2ETtT7a2hY0SKZcVW70aSL4jn+QmvhMZ1MDxMWKzNjM6uV3uGMduOOxtfdIaRWYSyKQzv8QaJCxC7xPFcNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770046544; c=relaxed/simple;
	bh=6VJJ0fxssxPgViW6cphU37tpXHSRi0cucxuOKUP5bWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbXIpSOuHejMd4HU0wMHnn3sTd1B5wsHmcXBxd+RW+1Z56D0/q1FZyyyGkizzz4VZgo7TLFkOiBwcijptlKyZnkcCD7eFzhg5cNDPYWOOblreOY4Xsuc91l5wd6aKMhwNHygAI9qL+yOjhuyy3tmF0rU+zn2O0HNAFZdkmp4fCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jQs0t9/Y; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jQs0t9/Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7WFsbiEQUurYD7EXC/ISqc/9qrsDGzxORricUBfp/VU=; b=jQs0t9/YTs7C4NYcOqlba6fEK+
	rmggJKqZwnjZGLPRswDnWuWLymMelfckxNdFkN+E0YqvLpJ54FM1NWSrDLv+xPDa2C6euMSZKFqRC
	WmWSUYN+pVnI3zzXV3Hq6bXc4NLfzly/zMk0jR1ETjUitCJ5jRvq9BQbGUfrWi6TSY4THTJY7fFFh
	FZ/BQWmsn5yTZEYKrmntX/G9OPy3F2jxRPSKp7XmhjNR0UdCnFVzBiJf/UbsHPQACFaYjHzymsKwf
	F0UTeP0dgNwVGQfbJe4om0C2muMDv32/Hz6sXIedS3ANlIc+l9LJ4d20z0MHiHA6fvHp9dEz8zvrG
	woQJhG2A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmvxj-0000000Ggx5-3U1O;
	Mon, 02 Feb 2026 15:35:40 +0000
Date: Mon, 2 Feb 2026 15:35:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Piyush Patle <piyushpatle228@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: handle iterator position advancing beyond current
 mapping
Message-ID: <aYDES-sGwCEr80Z3@casper.infradead.org>
References: <20260202130044.567989-1-piyushpatle228@gmail.com>
 <aYC5Utav-rTKigTw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYC5Utav-rTKigTw@infradead.org>

On Mon, Feb 02, 2026 at 06:48:50AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 02, 2026 at 06:30:44PM +0530, Piyush Patle wrote:
> > Closes: https://syzkaller.appspot.com/bug?id=bd5ca596a01d01bfa083
> 
> This link doesn't work.  And the commit log has zero details of what's
> happening either.

Looks like this one:

https://syzkaller.appspot.com/bug?extid=bd5ca596a01d01bfa083

but there's no reproducer.  Looks like it's through the blockdev rather
than a filesystem being involved.
