Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142A820299E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614906; cv=none; b=Bor7kUNcRE9fn7IqvLjX7NwgDd7NKPh1Wf4hfcjDupqBlzgflCOLdbz2tdCkX+a1nhqj56tHy7Eb3pmNW8DxwfZw5myl1CflU8dwlRxUOiRGBSOfZdLavZMbw2P9w4XTrsWkumPWHZFGsGxiOQV06usnsXKXrxy3JQ2onl05jgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614906; c=relaxed/simple;
	bh=zkb73oZOFv1I/VqfD5pfJpUn5M+CAZCSZMU83L6q0k8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gK77Kf/E6hJqTWTm/lqcZcTXPqo30V8YHhnSq8uqpUN4izR23cHQcC9jE1r+qavFGHHziUpOG2E5WqWNPbaPsHXVhla4FLMekhv92B55Bd8O5U5D4ZQ1zrNeRlqOWT7op52PPYxHsFMfCip77eyiBU4XTi3p8mk69CNd/pBwl30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AhYGnL6d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AhYGnL6d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hilPh/vAAAPTE3gLz6Ujb16/eiXeExP3jzNjzBWF2Co=; b=AhYGnL6d+Cnoqkj+/DzT4rSRif
	LvNlqK5I7r2Fi9RDUSYNoM3vCwdZLUFiO6dli50LvWTbEAfC4eUWdpIJQAgGm83fvMqWp8rsMrVbz
	Qvwohs5jS/baYfLfkvP3wVhpOVmRBJQmLZOiTH5oXBpY+tO7l5ACsJySUr7sINGYgZbubqAeSZJNq
	VcTvEVkdhOkOaV7C1fhnaRj2TXz045ULbL/bXcUnVL0fA1xe3BEy6hFYe57RZ7btYj8pGuj53niNs
	CMYZXOk77+kiLMVpTYB0Fz5FAMHEt+Q4z3rHirYKPNAsflBjzRqqFz7zMIGUalSp8G1xgLbxyflb1
	u6A6o5hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoNdQ-0000000AnZa-3Erv;
	Tue, 19 Aug 2025 14:48:24 +0000
Date: Tue, 19 Aug 2025 07:48:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <aKSOuIZ7sp0KMI51@infradead.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <20250819143443.GA7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819143443.GA7965@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 19, 2025 at 07:34:43AM -0700, Darrick J. Wong wrote:
> Maybe xfs should translate bi_status into whatever error codes it wants
> directly instead of relying on blk_status_to_errno, which can change in
> subtle ways?

We could do that.  In fact that's what I'm effectively suggesting.
Pick the ones we care about (and document why while we're at it) and
map everything else to -EIO.

