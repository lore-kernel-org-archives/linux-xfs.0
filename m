Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE464EB5F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713330138; cv=none; b=j2hWhNvdP062sYmep+t8RpcGJhncMVeq0k6frcLSBEV8HzxoLnlUWMI98E62ZTSTtAvf88gOHPd82POSto0pJEdVMDhPGBu1EraDQDNC4zLtYqFCexYhKNSJkHQjI/4+rsiILiX02QHeEZZR79oi6B2elmJh5oMTrsBFZ0z0hFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713330138; c=relaxed/simple;
	bh=khUGtNugWVmAh2CSz11OCUDbIefESgmYWkLZowPumd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mL9OliMiujN9ek1LpaHuHD94/lIpWRAMEo4nW11zRyoNA4vf8AMZo2/atsKA43+vmgNlUBcGN2xgr4rw0bqgjWRYkb6EcRjDVYxqINjVx37NetT9Pl5eiGVTy3k4cisElZjcjrw6pDeTMd47CBqTT4cVRijVi6dtYM2C89halM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GXG6aXfq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GXG6aXfq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=khUGtNugWVmAh2CSz11OCUDbIefESgmYWkLZowPumd0=; b=GXG6aXfq7xisJMgqPRFpDOxWjo
	qNSzLrG1y8puToMPdyhQj1aG7kvaEZLKtDANPp5337iOpB7+SZzXvfxT/GroL7Rf0OsxWEGXVvvWo
	ld4atl/bcX87N7a6s4cxxy1w8gDxFnVQbQneEL+wTBb6Iy93fAeinkDdYIXBwli5NFJ6h3wOKWvou
	AD/a3LhWh38+Bvv/Z/jx4QE3k6XWPt1f9Jg+tR4231qyrivhjPWoAUUSq1fVZVb62Obl13G/BDBPR
	hc2b6J1EAT1BTdBlnZip5jbyO0OYSVqOHWR6V6mHChr9+6ShczFFbUcjPf8PYPJIMz5iKPpPVS414
	9yjgl21w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwxR2-0000000EjBQ-2pEH;
	Wed, 17 Apr 2024 05:02:16 +0000
Date: Tue, 16 Apr 2024 22:02:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/4] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <Zh9X2OBEMhBUMGIS@infradead.org>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
 <Zh4OHi8GI-0v60qB@infradead.org>
 <20240416223148.GH11948@frogsfrogsfrogs>
 <20240416225118.GI11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416225118.GI11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 03:51:19PM -0700, Darrick J. Wong wrote:
> Actually we don't even need to clear DONTCACHE on sick inodes; commit
> 7975e465af6b4 ("xfs: drop IDONTCACHE on inodes when we mark them sick")
> already took care of that.

Even better.

