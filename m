Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C0610B
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381794; cv=none; b=tZpD301BPHmohtJUSNjD3DqYkWEYfsCeglf/4b5cJJXGGKB8UFjW7+m+qu3+gAK5co37w5Ezbo6s4SZ/qLkNZauJWg5JyfYwoLUmPARCq/+29bfR1N1xI4Payupn1WPKBT2tboxN6OP1hgNDklu9fcZqN7Y6Hl7vSHWt3M6AdIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381794; c=relaxed/simple;
	bh=WZmgtEqWv8CYocGDu90WmGhO5Izywy5wjCVthcyp9Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRRPn3jwKDyWL6zZj66oxm9A0xUl0DogvNEonZAIGEXUcknIQ/31Jkzn1bUYC9O9+W/o6suG0HsTXBXQ4DlzYhXZ+KdMjvQiGXgGXBjd9QgJ5kblXl7pyDodym2OmJDruXbvwskiX1x14IvPQVzlQyFoZnnQ2eupvp3mqOfOLo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EK49EVtN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EK49EVtN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uesKtqpVaS9fGNcDen5cPi9FS9E2xK04JvqpE+MdCJY=; b=EK49EVtNuuzy6sgAGk5kN3vlOS
	bFGBqZuG42nn15IeXB3bGwrJ2911WI0ZXSoaxGub1vXqT4TAP3FX4ZXZofeEi+ibdI380JgfStYZk
	z7igPbZsEclhithi01PYuLsmCgNedzep/ReWrguPSDiIrpb/I0BwO7izfmh8l3jUgRsDJRyKh17vr
	Sa47kXxhARWn0rm15wKJi9nCVaJWgrwVURXLvrqLxMRNDqmAE98U8U9gqvBFYR69Vo6SIzygA6BUz
	p3Xi6BSmk6RM2/tbchSpdBzMrcETVmJ8izCqK408Tx2go1mtPN9HDdaDAq/dW/H4d1hevwc6jwoNX
	2Lt2GYsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaR6-0000000Cd25-3x2L;
	Thu, 14 Mar 2024 02:03:12 +0000
Date: Wed, 13 Mar 2024 19:03:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, "Darrick J. Wong" <djwong@djwong.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_repair: support more than 2^32 owners per
 physical block
Message-ID: <ZfJa4PjWo5l5SwWA@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434786.2065824.14230923406122272720.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434786.2065824.14230923406122272720.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 12, 2024 at 07:15:42PM -0700, Darrick J. Wong wrote:
> +	if (nr_rmaps > MAXREFCOUNT)
> +		nr_rmaps = MAXREFCOUNT;
> +	rlrec.rc_refcount = nr_rmaps;

use min() here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
