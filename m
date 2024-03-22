Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333DB8BE0
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 03:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711077866; cv=none; b=ZZjmeG19LecJpq5ykGK2uwJBUDq2U6D48N9VaTSNqh5DXjeVxgjr43NNHaM//uccsYHKgmjAhTcgAIMLYT+yz0Dp5dfz3V8bRWhpZ1NM4UXnEenKBgRedM7wkj9vslB5r7HATQnZkh/IzXsd1okuezUhJ1BDzBGI940iEVbPlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711077866; c=relaxed/simple;
	bh=+OwL4xo4tFGG+mrFtZpV6PUcTVl8mOMaXvTQ4wOp2Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDe9NY5m2N5OTulbSvI3EyOQqi55i70c565nIxlUaazK28BYbYr/y4UUhArl6RCYnkI6cDczc4y1Y9n0TCjUuRLHqBX217XAoXuIyxjMjAdWXItUnwopVlrWW8lJTeSnOldtFPqT8h6U59jDTatPI4MzX7bSr6bYFi79oEGqQo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x2sK2Xyw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x2sK2Xyw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7Dz2tbaYqhNAm394tQNSIqn52b1cTikD4I2XBNVEGGQ=; b=x2sK2XywM/Ly9m0bd7yOzcE/bF
	VPwPM7ybRCn2MPxBuzeULyqCGrawk34+oON2oR6mt+Tla2zfOFODIfy/sKbD4qcIgmsEXBC6O3HLh
	cmIrhKV8od/j4z5c/HN3lZMUQ8sqaAE1kuNnk7S5Yaw0YqZ2sYaqY3ROdCQZ6Vjg+Nt17954C/2FJ
	TTD2nnbJYOYelS5an2EeYpZU9EMdj0n+Z3pSBOoYlhCER0pAJ0Ff2WrZ8bmXtvuzabeRasjMmurcL
	u+htH1+nGRB/4bhJTUn3PAOAFgtfA8zesxOsmDi6uNBe5IRUdoSJFQGXL04ewwUn92Tshb6+0EKiJ
	ZlJ9evLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rnVW2-00000005dRS-37zP;
	Fri, 22 Mar 2024 03:24:22 +0000
Date: Thu, 21 Mar 2024 20:24:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: compile out v4 support if disabled
Message-ID: <Zfz55rFk-WmJhuhb@infradead.org>
References: <20240319071952.682266-1-hch@lst.de>
 <20240319175909.GY1927156@frogsfrogsfrogs>
 <Zfn/8e7MhbFcvHL0@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfn/8e7MhbFcvHL0@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 20, 2024 at 08:13:21AM +1100, Dave Chinner wrote:
> That sounds like a new __XFS_HAS_V4_FEAT() that has a thrid
> parameter to define the value when V4 support is not compiled in.

That's exactly what I did yesterday.  I'll post the updated version
when I find time.

