Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597D03C488
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884511; cv=none; b=hma+Fqnl10+3PGunqVwHIOShwuDGfi2Hf5WFLyU8tx85jF+mm0ovHq6oS4dno258VMQ3eK4+cdqQc73BkHe2kkk6eTkaMktUIdxf5Syo5cjk6wJq9sjo9JY2sVIsHMUUntTn9oJrGHF1CVsL1k/80DB2qvAKyc8ZaxYm00M/E7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884511; c=relaxed/simple;
	bh=1drbyQ/xt+SGe1B0ggjL6DTqTxFTWXfui5b7FaZKqTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjocK7noBPDrJuUketnOmRUDWURa6twJop25k8aJgvi2ACHnpjb6Ac+UAll+qOJp8bmW2HdZnpDxdTTSFPucftUACNTjW+3kFgE50B7RE/WU/cE/nkIRLNyrUOmAD/RRtZdC9xiSPHLceiGRHmTCgzhm69PhD1/g8KE8/BOBmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fwj7muBp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fwj7muBp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z09T5nhTC1gKuE4wmJfEpAcuXAKqLdgSWGXEO6doNWI=; b=Fwj7muBpesALEuhoNJdXnZdL8N
	3T+GdPg1elNGp5p1TCWVAZxdK6yAJtYuxiQOFrsSNXsh+tuIyZGyuQak+VBhb3hA5FcLrg6yFcXyx
	xy4eRlEpBNHbUXnrWYjOE0KT/6JIzG5KMSbLStBvKE1KV5y8tbgUx4TTjL5Glxf1lG6ZO3BpoFOxx
	pGCtYmxuVxa0vZxD4YV7ke/6B8Cn2O5i2D7ZtUMNPFx4ZvADSCfeG9rl1oUEx/zbiqyONfx+wFRwN
	ZyM2blgBSMGXn0onNT6E7EFuGIw3lakmAP24IXSdtPQnM/LcachTkiV3ZMDcZRexcZ7329PWmhoCX
	M1Augfiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmhDR-0000000EKTh-3vNb;
	Tue, 19 Mar 2024 21:41:49 +0000
Date: Tue, 19 Mar 2024 14:41:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: map buffers in xfs_buf_alloc_folios
Message-ID: <ZfoGnUXD5BtD04jH@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-7-david@fromorbit.com>
 <20240319173413.GS1927156@frogsfrogsfrogs>
 <ZfoEgJ7U7A6BxwIl@infradead.org>
 <20240319213919.GR1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319213919.GR1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 02:39:19PM -0700, Darrick J. Wong wrote:
> We might as well fix the split infinitive as well:
> 
> "...no good reason not to map the buffer pages..."

fine.
