Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A06417997
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712120187; cv=none; b=ib1nQ71+uJwSJS90IMCTf4e5yKlEiFIasMTAMv6AcxySQ4iwM1UE3kCL4lCj3/sLpX1YJC7xjHpBOVRadDwuEqgx2DqC8QsxPMRHoXxRWlVqLK7KOqgaKMV/Zh3euJKhVkF0ljpnj/cQkKV7343y3lUdg+IoBj8CAmrxnd6tRWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712120187; c=relaxed/simple;
	bh=fEXsGNiMiSY+fTwbUKE/TvBY1SwNvSMQGPxmOk6Bqtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfKwrPYeOerpmlWvPDyCPxPTAoXV7/a6kToxllX361mENblEy1tiBBRUrpOmFGncmYSOI0hzWt4jRhKmHLTBSweUdslWMt17P8t5kM1f/YyN0eHl6lq8rchUwDuFDRLtVHr73r6D567jKZeP6iqjLF/2EzXcP5q1MxjcicnR9Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kiko1Nut; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kiko1Nut"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rkNGRRredpzbGfNhwTyABfSXK1Z77HtRIS8jeLXrpRo=; b=kiko1Nut6e+gQ80pkkZIDYF1GG
	+BQF2CIvd5CR7V2oOoC9ukBq4dAtpUY3SQP+p+ITfNm5DjqM3C6FxMtllDB1dDFXJVY8cCp/obptG
	C2jxcLwEl6TvTsSAmNL/e76m3ZBKDRc4MhH8iS8Z2ZjMe/Gc07qUu/xZmyyMi2rb6H1ebpUzklRA3
	adyTNf4WhZ5tScYwPrZ3GGHMRp/IwXCagJWX4u5owlnekkAm1rvmeaEZcCccCi/6HmW5nsIqgvf4g
	olvtGmcrfUEYn9gwuQ9IG9IDwPvHbPp/0QWUW7KwfOjV4eXoBk4UQo02A9Iddap+gK4sB7Vy+x6su
	AZdIJkxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsfg-0000000E0wC-0VJU;
	Wed, 03 Apr 2024 04:56:24 +0000
Date: Tue, 2 Apr 2024 21:56:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <ZgzheEqxrVBg3dbs@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
 <ZgzeFIJhkWp40-t7@infradead.org>
 <20240403045456.GR6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403045456.GR6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 02, 2024 at 09:54:56PM -0700, Darrick J. Wong wrote:
> Usually this will result in the file write erroring out, right?

quota file allocations usually come originally from a file write or
inode creation.  But I'm not entirely sure if that was the question..

