Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905BC4A21
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070147; cv=none; b=n0MtlGOESFFchpveSVJCui7NkbDuQeTQUK81YAIYWzAwwDdjJQUBgPVnxiTOTF1ZmFAJNfRAG0bUaFAJzdMQxq+QTYO/DRDQvbkDYBivJaOAzuUUQHsSwMdnuHnNE2KIZEF4I0UPAu5J8OEezHEt8JIEdSQdYu8dS4bm/8wPvwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070147; c=relaxed/simple;
	bh=SRXTAZDdyhZFTov377PcbiGSvUhqb2a/BIhFPXYSGsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3rOlrKIJg1DJlF0i0Azd8w3QGIHZYEQZRUk46Lg+n8Gtqi0c4n6I1L2HS635HBr+rX2ZSN0rfCmTBK/asPWizy/sB3u0Ki+89jXDi3jxc+HIOSBB1hahBNltFyIUYwfCWmZXcPmqQZh5Ukr/YggWoArrHK/XDnGdwhCC+Op4mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O7c1bzs0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O7c1bzs0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wVYpcl4+L+9QzSDMY/1DpNTn2A/Gl3++jCEnkXXWNa4=; b=O7c1bzs0GOH7Hrv2dnh5xDV1hp
	GPZ9By31eBrAVZ/QHKrh9ddWlHspEtQUPb3hsdZAXoCR2qbR97CAvMon65f7DK6aT/OC+TB78Era4
	tHsGjy8o+9XXssS9FJPm74pRRBdUKaCuJ1KwAIkfSF/gofc7RNKCT8MHX/gHtK0VuzYN/0co0M+5y
	c+o4FpeDez4D7rDbNRnGweXFRHC3NOh4NIzyJ9KB7CndIAX6+h0O02PMUvRfCeiH6OyrThVUQi1eF
	mzUn2GKEROoixACMHJrB2ZjmFLENKR1uTMA8jOOBZ8dtjynEXfcKEGcncAUHqWl3Y1AomBYM79MP1
	GpncerYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyrK-00000002q5P-0W04;
	Fri, 13 Dec 2024 06:09:06 +0000
Date: Thu, 12 Dec 2024 22:09:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: hoist the node iroot update code out of
 xfs_btree_new_iroot
Message-ID: <Z1vPgrxDi1x8NkAp@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122263.1180922.7163747639662994394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122263.1180922.7163747639662994394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 04:59:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In preparation for allowing records in an inode btree root, hoist the
> code that copies keyptrs from an existing node root into a child block
> to a separate function.  Note that the new function explicitly computes
> the keys of the new child block and stores that in the root block; while
> the bmap btree could rely on leaving the key alone, realtime rmap needs
> to set the new high key.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

