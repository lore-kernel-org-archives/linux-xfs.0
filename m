Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BCC1514F6
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 06:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504921; cv=none; b=PTbTz4YvFJVNzCzHMb+Z/JN1OcwTr2JXq3cTNoprH0hIvA+f0xfOsH16pXFFNnU7Vkohgeo9u1dcATnMhu06WE2p3bNoGswno0pa9VjnfZWu94ykFAMCEJFGELr2mGwY3GJ5EpePbGMZSgcBXr+R6tth8VQenktjw8wC0qILqEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504921; c=relaxed/simple;
	bh=vkdk4mEosVSOEaw4sD8PJU+F3UkXPcboPn2ytx5msGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtG2nyu0LTcDHnsMdA2UlP7nq4QPKlhV1SkskumThwwpJLxb8RyCWqj2NLbzRODsmDp+/PUWbpU6E874i/ok2g3q0NRfn0mGfyg7RL2PzzeRfFqJmlPm2Ap/6Daql3B+uBF7NvwYTx9RJG6gSeT4fih4rOhCTgNzf6y7AA6ByTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=czavUWkz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="czavUWkz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XS7y+YYuSIVgog1wMBPaCLzZFfma90DZLOreku6ZMsE=; b=czavUWkzHCgYT5XioMgL9RBjHZ
	cRATgEtD0sixVYMOoGjvzm7nxWSfnQrQPTjEkjWrBCn2QRIK2J86si5gQZpaE4x1fmiDIvrZd/4Qm
	f/MUQS2llmS8vehGAPDuW3ZdnlbxaLFNHCI5joxmkgyWL4kFBw5CT9+YIlizPVdGANLlETtcRTreH
	Y5ZgpoWBCnIt7iPDrb2hZClsQaC6U040ry1Nq54+4aOgCMiFbB/7gdBCydfC/usiwcyElyhfCp6Fi
	DY0V7gjO1UFjHs8ir9jX8S+yCBUBEHzL4Ziue2w1vYtPRBDmXiban7+aGJAGKBd0Fm32KJIcQy87k
	iEl6t3UA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNnxo-0000000Flek-03ka;
	Wed, 18 Dec 2024 06:55:20 +0000
Date: Tue, 17 Dec 2024 22:55:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/43] xfs: scrub the realtime refcount btree
Message-ID: <Z2Jx140RMiOHBLjx@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125046.1182620.123195236500556349.stgit@frogsfrogsfrogs>
 <Z1v7zpBiiZ-G_sB0@infradead.org>
 <20241217205510.GV6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217205510.GV6174@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 17, 2024 at 12:55:10PM -0800, Darrick J. Wong wrote:
> "Add code to scrub realtime refcount btrees.  Similar to the refcount
> btree checking code for the data device, we walk the rmap btree for
> each refcount record to confirm that the reference counts are correct."

Sounds good.

