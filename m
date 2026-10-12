Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77E32AADB
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811174; cv=none; b=cEP740/tmZdFx49dpWxvt5vzg26qYZVeH1fqB83gSvEGjEiF5k8SXJAjDzYsyUQSQSGJt/DnVsGKKTT3/XkOD/00j6NT94nJHxQKN8q+ICib9/hD/M71fjoalFSOjrjov90XSW8nIRYqwtESLRK9rTY1//+xP+Ws3QZuwFONbLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811174; c=relaxed/simple;
	bh=DPV1u24eoO+3BbzMtCXm8s0U992HCgb0FTRcg/4djro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZK0SJIE1OXg+zcFcPmJZr9+d2kydKM6IPYWVVwgifeANG6TS4KCoKelH+4U4oaFtOCaY3ALXPSv6QCVxmabb+ByLTU0Hitdk0fpTj0cZKpa6FC1uPDVaBJ/V288kxDItP1ipHCwLLh9evNUXTL4Ji6IO/nEN31bcoc4no67GZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z/vm9Kv3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z/vm9Kv3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sb6suow2Fn2mUrcSS5mMv8vyt7VF8c9N9mDmggHe5m4=; b=Z/vm9Kv3x9CXEZxdFaeiGaG+eC
	umk1hYKXSUD2epqGn6LJuIWPL8VImGUF8LdQy7ZEnd6v77BPQZFe18yEh0/dBfOwCAoos1ThJULlB
	Yngvt6W5Io90OjNEnsQfR6ZCgWXo9lt9a7DnXhsrnypiylb64ElKEoS6KkaudRd5f9JoKI9wehnkk
	YsigH88jI6/mYM93t5sPnzwWzzfvcLRNg1XP31KdyDFgafs617fWePAPQrDrFogu6JpXGQnCW6ogs
	ozRMQvJAhfA8M17r6wpihuZKLEQ0AOZ99h5id1AS/82N5Pjk2rz8yh7rqZ0aecTiNBvw/YHWE272E
	tRJNG6Bw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFwC-0000000AY5D-31HU;
	Mon, 12 Oct 2026 13:19:32 +0000
Date: Mon, 12 Oct 2026 06:19:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: drop unnecessary sr parameter from
 xchk_rtgroup init functions
Message-ID: <aszeZHSY2vCTHTkD@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178066038.1058822.6794706800607037709.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178066038.1058822.6794706800607037709.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 11:01:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Drop the sr parameter from the scrub rtgroup functions because the value
> is always the same.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
