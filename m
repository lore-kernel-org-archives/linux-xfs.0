Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241593C7E1D;
	Thu,  8 Oct 2026 12:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460841; cv=none; b=IBSkySW/XWYWxMT7UNuZNG6+DgyGgWcFjQILqrh2Yfn2TNf38z/jaADA8QsCDlVqKafs//V+OCOZBMiICac0zUz6EP3PDKfNwZhG8KIDFJRQstFevfeci97hSochbrTAeN5BQq8CtabLHjwJuHDGWhApMRYseG/1/QyuQuw7RJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460841; c=relaxed/simple;
	bh=oDNRp/AYqPOxk8N9hvRE2OyjkW6FP2+OZ4yuTqJei1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXLxfEFnbgdBfTv+GvXroRGmfMEilcNWQQs6UD0VV8WDCsn2jc6E/z3eDZE0HX+DoTbMpmIJsvIlaKRqzT91gaKOuEG4lOsmSEhlWZeSKKVDsC401J7oA7Nb0va0/TGvomI5AC4XllbhRnyH87tgGM3Pw7a2q5ySKwyPkpKIb50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xb/uRoY9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xb/uRoY9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=//BDZgIG40SyB1hNwIl5D0BUi6Nw9ufFHUhNz5FPWGg=; b=Xb/uRoY90qX/n2plbwmIdjeixc
	3WUKnWTb6+EK0ZIayijRN3VtLbWdJQGfHI2HrGwswPcaNx+AqzRKT45Gj+HnkKkQE5BEtCjJIh6v2
	vEeWFhrhiIcNv7WR88Zc/r7vYmHijIJ2nWnAOssPyldGpuqdZLFr+gtgh7kOfRPdWPtAG4YvS0AR9
	YfTeWceRZPIm1tlifWlt7OiBgMuulj0e8dRexOfrBh70rTcQNQ+QSDVMCmINGARra4d6efolt/KAq
	HIQTO3kdUlp8d8E3AF5mwlWvih5kampcvSOgPFIfeZMRWvn3qd5xOmtfovn2g+FHa5EDg8hSDDOOS
	224qejgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmnf-00000004JPN-3bAU;
	Thu, 08 Oct 2026 12:00:39 +0000
Date: Thu, 8 Oct 2026 05:00:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: always report inode repair setup failures
Message-ID: <aseF58tVM-qTnuo6@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521407.2728617.12125568467564794998.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521407.2728617.12125568467564794998.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:56:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xchk_setup_inode silently discards errors being
> returned by xrep_setup_inode.  Fix that, and fix the stub macro so that
> it actually "returns" a value.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

