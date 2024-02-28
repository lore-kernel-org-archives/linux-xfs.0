Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015603FBB6
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140859; cv=none; b=HE+rvrbwvZjEWrkbYnxzX59j3Gb+6cXjanEgKM/hxmSZ/TNQYS5t1H7qqDvVDrVs5jIbl9A7n1dHBctX1xkAoY5Xh89me8NlxcVUZl1Nbh/FukGyz/GKZJtUcaNOgjH41M2ZdZLKtxUhoMuiI+3DWvbc9AU4+gfcLaMvpYJoWA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140859; c=relaxed/simple;
	bh=hXPV71CBMOUvaQuj4gQ2oabEd/3Kbp6FuG/rc53yumQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTJaE0wszUendkyWXKlpfXLgvx7a/EMtgOb20KlxW5Rk296YSvOCxZ1ImkgfKuGoIkmw8qr80z7C9+kb8y103zAlNVDeKciADEXY26LgQ6gYixXjgPlPi8Wp7VoVCUml6PcMPMAqDKTqLiLRJsv5CuIoyrNXD0mTJe+PIboBUBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jh83xu6q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jh83xu6q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VBnlf7hQQbVCAr5fyzpx83DMn7W16fVTef5DscpcEJU=; b=Jh83xu6qgpionMPCKiuZ/ojTSS
	PUzXOwKTXYZnbIsePCKbtFZ0M/2kKWCFRpX2Mx14849Y1gvX0v1U6Tcdy35YVam9whXKKntNsk5lG
	RKFtoOFZC9xHY/RdbkIQSl3RdsHY5ANNeUouESk0707iW2b4zzod18xxoHBhMet7mwR7jnuYd7j+w
	hKfdmq6AZxbDCLbBlqyAdL4aHJ2bN+yLIY5VLAMFPlMZOFNjOT2JB+tmGgKlH5QYTnDjDNOmA6nQF
	gGCj7Gd1sEqpFgseaxH6A7gH1FAX9mObKfAOnLbpJ6mzaaaP4nHAd+6NmQetrPM8C68idHm1voOlG
	oL5Qz1yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNc1-0000000AGpu-0gtx;
	Wed, 28 Feb 2024 17:20:57 +0000
Date: Wed, 28 Feb 2024 09:20:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] xfs: ask the dentry cache if it knows the parent of
 a directory
Message-ID: <Zd9reRana7Fue2pN@infradead.org>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
 <170900014522.939516.4778985900477583664.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014522.939516.4778985900477583664.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	parent = dget_parent(dentry);
> +	if (!parent)
> +		goto out_dput;
> +
> +	if (parent->d_sb != sc->ip->i_mount->m_super) {
> +		dput(parent);
> +		goto out_dput;
> +	}

->d_parent can't point to outside the current sb.

