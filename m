Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC07305E28
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 05:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781157160; cv=none; b=l2/J1eNbzDCGrzZHbQVCBh1KciIop5qHeQZMtqaYXalt6/Ad2swsHvdIHnPRqLUqF81cZ3xTf7Ul0A0jGJv9MS0sF66Pq63B70c7S4gnkxfOO3QdQkJ7VWCCHjM3EVi+BVNWvfxz1Zt+rGlAdh/gvsUDyfDoRPLecbnb0xQBLYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781157160; c=relaxed/simple;
	bh=q5sUughJxVhgqOqc8HdD1x/l70nzRaOXBRcF9GgHrUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihhwp/erpm5gghQ84OGEbFJ71gKulhdRZdpXvzObPWSAnewNeEijVUzshRacyWxKqtFJqIU4LfjZkCESAOv0LrF9gPPXw6jGCcBX+ubBR9kNZGSw/VyFhBSVjIrwMCgxvvpbjmg070ceJuIvOv2zLIL4pdu/UXaVdz1gMdc60Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rqAgU3f7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rqAgU3f7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jC3AI9BcjfHlMQz0CJmpoHS5/XY+GL7b+KrNX7g/LfE=; b=rqAgU3f7m1du2ifQ5X6oXA6l9A
	LZHzigHqcHH+SR38Rmj70x6Y/9R/pt5aYz0pJgz9O0CC4rEWIVd2LWl3G9QDu++x2T60LelFVbAEZ
	HtGu2QDwQiQUZEVqpjbrGefz5+5NeRMHHupSv9Ds5iIRS9DjhnwdJms6fTOpULK83Gxr+C0FuidFL
	AbaVOH8hxmYLJZ8eIkyi8tdZ/IGWBW4JHlExjN0bou/6kFgqHuLb+S3CeIU72esP462OPKhSrtRXN
	PoENAx84IaVXWP4Yk3hqqkH/JWt3QGCMKkSjGHcyyUz00LLWLPBHzGiceECV5ACqynG17xq2c0XFz
	6YZl6T/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXYLC-00000008lcp-3FhW;
	Thu, 11 Jun 2026 05:52:34 +0000
Date: Wed, 10 Jun 2026 22:52:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Yao Sang <sangyao@kylinos.cn>, linux-xfs@vger.kernel.org,
	cem@kernel.org, Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] xfs: shut down zoned file systems on writeback errors
Message-ID: <aipNIhAyRkSWIlDF@infradead.org>
References: <20260611015305.1583003-1-sangyao@kylinos.cn>
 <20260611021303.GH6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611021303.GH6078@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 10, 2026 at 07:13:03PM -0700, Darrick J. Wong wrote:
> > file system shutdown from the ioend completion path. The existing
> > shutdown path wakes zoned allocation waiters and makes future space
> > waits return -EIO instead of leaving tasks stuck waiting for progress.
> 
> File writeback errors taking down the entire filesystem?  That's pretty
> drastic. :(

Right now that is the only sane thing we can do, because..
(we should probably have a different shutdown code for it, including
similar checks in the GC code).

> If writes to a zone fail, do subsequent writes to that zone also fail?

Unless it is a transient retryable error which should not bubble up
to the file system: yes;

> 
> Is it possible either to requeue the failed writes to another zone?  Or
> at least offline the zone and wake up the writers to convey the EIO?

... what would be your model for errors be?  Right now the existing
devices we've deal with will not return errors until they are really
dead, which has been normal for devices for a while.  There can be
transient errors from the device or transport, but the drivers / block
layers are supposed to deal with this.

Yao: can you explain what errors your are seeing?  I.e. full nvme
dmesg output that tells us the status code?  Or are you just doing
error injection for testing.
Either way we should probably document our error handling model and
back it up with tests injecting errors and verifying we conform to
this model.

