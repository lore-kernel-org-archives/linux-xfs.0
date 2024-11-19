Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0B527473
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 18:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040824; cv=none; b=RxQUuMq0g7utIlGBYooHkITSaiTgi4PdfjGPlZFQGuvqZmAi2oY9ypdWT8FlxzYxvdKq0EDn7FrxcjMVoRcgcj9ZBiPVU/2MmqLO7kcSvj7ozaD85kvC7Nh2lG9WlZuVOQS5PuiC+vD01b+KXY/25yuFkbItWY2s/Kk2cbEARHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040824; c=relaxed/simple;
	bh=6Bce+LslqGsWJtEjHO0O0zd9jClSW+r3MtwVofX3rHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvOovF1/T8Z7LN2j0xx+mQjEOea5HThNeYeWTDQD+HMiOTijJH8TdGHeDolEW0p5ZQVBR0vOPe9j7d3Nwo3a2awqtOEZ9KD2Z44of11iZujoLJYTePVlhTb5ZkzF1IOMhS3ireXTGUlN82dbKsPFZ81i4lSG0VcoOnpR/Cp50MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UC5WzZ7H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UC5WzZ7H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vJqzb9D4vM4o2lssvD4now+J27TYSwDcypEnpRyFj/I=; b=UC5WzZ7H78hJkfPjNx40DYS6QO
	7Ja1gIsKjo+JH1JcRxL5GnU5nSgAf5vytZI+ek3oElpz2qYA1nnfiBkp/7rnlOTLwYJFVySv5XQSc
	WI5NjX24FlWjqkNEPOb2P1SsEFrOMgVHUkFEQr+UJluOdmt+6Dlk5uC7xyogFseB8/nkaJHDzmyxn
	edsWsW++ykMzPV4Tq8Vah2jjRQ7HwoHthJWAIbRGLnKA+MNmckscwqFKZAGtarI8JpcMDAvOqo+Db
	7VvCdRpC5rrNCgvXw9U5At0IxIXis+Xol3vdttKZhr2f5UzlXtK1ykoSDRFWQprfYELx0mRIMDl1t
	i8ftwTDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDSwH-0000000DNzd-30Pr;
	Tue, 19 Nov 2024 18:27:01 +0000
Date: Tue, 19 Nov 2024 10:27:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: keep quota directory inode loaded
Message-ID: <ZzzYdRva5ZuQvMTu@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084464.911325.18182055244953182778.stgit@frogsfrogsfrogs>
 <ZzwmAevNy-Tcl9R0@infradead.org>
 <20241119181834.GA9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119181834.GA9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 19, 2024 at 10:18:34AM -0800, Darrick J. Wong wrote:
> > The commit log here feels a bit sloppy - it keeps the quotadir inode
> > in memory for the entire life time of the file system, and not just
> > the scrub as the above implicitly would imply to me.  Maybe clarify
> > this a bit?
> 
> Ok, how about:
> 
> "In the same vein as the previous patch, there's no point in the
> metapath scrub setup function doing a lookup on the quota metadir just
> so it can validate that lookups work correctly.  Instead, retain the
> quota directory inode in memory for the lifetime of the mount so that we
> can check this meaningfully."

Sounds fine.

