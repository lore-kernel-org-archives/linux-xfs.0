Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9FF2D6E61
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768892143; cv=none; b=D3puGbM0C+KppdwCwCVHW6pKaV7AZYtRGxqgPIorSNrx01dGk0d1NcAU9xW2CKnrgf/KEc2t1I/ttSOWUxHuQjGM7hPCiQbWAg2emBTohuIU6Xq6oMQz1bc/UnpUJI61l1rrWvXBGZKwS6/k4F1wow4cbSQXxlNzaT30wlgq+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768892143; c=relaxed/simple;
	bh=I940ifoTDUEAcSgCgK+RBxUitGj6KErolj2afnazaJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grHyRYo4reKu8NLNrjQFvb2QxCcatYAohkAnNNMldXwua4ELtFmcW55gd5O9Gp908duH1lmowyN3Y05UbEssNVvkQ7n1oYlAzPk3rdo48yN4NRTFfKK5kByWAtm/DI9r+zS3Dzj1C/n1ZdA92J0QgAsFzUy/NnyAp0UKAyfzJsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0EE01227AA8; Tue, 20 Jan 2026 07:55:34 +0100 (CET)
Date: Tue, 20 Jan 2026 07:55:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <20260120065533.GA3954@lst.de>
References: <20260119153156.4088290-1-hch@lst.de> <20260119153156.4088290-2-hch@lst.de> <20260120025315.GH15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120025315.GH15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 19, 2026 at 06:53:15PM -0800, Darrick J. Wong wrote:
> So under the current code, a cached buffer gets created with b_hold=1
> and b_lru_ref=1.  Calling xfs_buf_hold can bump up b_hold.  Calling
> xfs_buf_rele immediately will either transfer ownership of the buf to
> the lru (if it wasn't on the lru ref) or decrement b_hold.
> 
> Higher level xfs code might boost b_lru_ref for buffers that it thinks
> we should try to hang on to (e.g. AG headers).

We actually do this b_lru_ref boost for a lot, if not most of the
metadata buffers.  It is used to manage relative eviction priority.

> xfs_buftarg_isolate will decrement b_lru_ref unless it was already zero,
> in which case it'll actually free the buffer.  If xfs_buf_rele finds a
> buffer with b_lru_ref==0 it'll drop b_hold and try to free the buffer if
> b_hold drops to zero.
> 
> Right?

Yes.

> > Switch to not having a reference for buffers in the LRU, and use a
> > separate negative hold value to mark buffers as dead.  This simplifies
> > xfs_buf_rele, which now just deal with the last "real" reference,
> > and prepares for using the lockref primitive.
> 
> And now, b_hold is the number of higher-level owners of the buffer.  If
> that drops to zero the buffer gets put on the lru list if it hasn't
> already run out of lru refs, in which case it's freed directly.  If a
> buffer on the lru list runs out of lru refs then it'll get freed.
> b_hodl < 0 means "headed for destruction".
> 
> Is that also correct?

Yes.

