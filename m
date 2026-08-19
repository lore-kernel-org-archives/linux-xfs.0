Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2222E888A;
	Wed, 19 Aug 2026 06:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120201; cv=none; b=FqQQ3uG7oJoT6n+2e9JOA157eToaJAQiIy9x2bNj0jYlLWdfu7M4sPzhHcTsTp2yj0RpEUu1DJEA9HSmAJsUhU0egDJa+SLOAtSEz5pQFf7Cppbjh/ARloz04M04o7VBdwoasSHOhrEmyGLppcSZSykZOQ48lTxLSSrmCSqw7wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120201; c=relaxed/simple;
	bh=4mX1CsZTeDyqc1pQ7UuQ/x5k1gjGtLK1cT+y4ys/xz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l11+X/BZjPcxRKX7u2pVM5N4HAHuK9tUA2wn+eLbCjkl5wDRYK2Dn/jaZogGbZTV0btKUt63e8qwb8eTN0DtzbFj72cXgXMLs2EHh+USxjDcWlwe/PI5aldKSdOeYc22PFtE3NV40AJje1nvzRofuo5ZUl2xggCJ5oxbZFRRmr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PYBiwXe9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PYBiwXe9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AZPSH8ST2mpVDlvcF+aMFMeMhjJyYZskq3RoFJjh1Ho=; b=PYBiwXe9ClB+S9hKZha7ejYvIO
	xn4K5aMnoW4UEfnnY6SjgiDhZPzakLLiUgTEoPPIvEcbCbb8mmeafRYnEaQ26goisCJNUqLpXk3xb
	xxupdIFiJd41vXiIRIp3wF32eP7Stxj7IjJvW2FB/a/s+28Y3FNdbXh8+pPAMkqrhCL5mCKdOnFJL
	mycIKx2SzMIAsnkBZCqUYqal7hfH/cPNrRrRFDgWcLtZzGMWDCN/fy9GYiroLGLhJMmOROzkzCzVJ
	ut4pw51pQpVtPzhumdh8HkNC4sToUDdwMWbmnr3y3JMIT74JGprS/ahtn0unUib1f9hRf4wVUicXV
	FB6ZITKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZbL-000000095C3-2LQl;
	Wed, 19 Aug 2026 06:16:39 +0000
Date: Tue, 18 Aug 2026 23:16:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap
 filesystems
Message-ID: <aoVKR4HmS3Hi7WBg@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:25:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's possible to construct an in-memory rtrmap btree for filesystems
> that don't have the rmap feature enabled.  The kernel doesn't do this,
> but xfs_repair will, if asked to reindex a filesystem that has rtreflink
> enabled but not rtrmap.  Therefore, we must create the cursor with
> enough levels to handle a maximally sized btree possible.

Should repair initialize m_rtrmap_maxlevels instead of overallocating
in the kernel?

