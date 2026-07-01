Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B2416D16
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 11:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904490; cv=none; b=tjLGTehzv0PYaJaniMOtBzuV35z7ngyk9a8b7oBkrzQCGHrOWTiLYBgA6yEGrd8KhfFLXuZAfIjdWyIBSpZFukQFffKzxgAgzeQzOR3YC5N+9rgP0WRd5dtFmMCKL9fMmUecyA1h88/cGUTgX8VuGIYVuuf2uYw5kGncXDHzCQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904490; c=relaxed/simple;
	bh=shChX+ZVy0tncYea+DhkcHerLgPsvvx4i+7n1Fxl8io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NN0VyVvsPAhKohx8geYMoZ9ZoXV8qmrPkh5zPITcmxuLZzgpfrIWsj9pWUDihOCmHz32Y0j8/+gFLu/pU0Ry4pdYaygdOovnBjYM5HsbfakXHOKGaZJfKDyCVDa1NfIPArZgnb3Yf8u+vlf5UYSyZ6W8KOfKDFYeCCaVzWkKj30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jSbg5Hfg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jSbg5Hfg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cDvSwXMYs7I2a5Fgf55VHpSifZtlhOSVeAViN1dWRvU=; b=jSbg5HfgQ0rMcKDuZw5EZ9/2E7
	f3SknekV2wmFDiPD2HlJBILh/oAKJSnFqmuOspHUJDOkeZQnjxbdaIxic8G3azRT+UZC3is+QGy+A
	fEh/D4s82dELG98pPbxUqdan5SjNmz+6HQmWEcsYsmUXLBxiD6zLAseASbTnYuvSBQ+v5DLdDhQ0p
	BCxCJN+/fTPULCvCgnbXZIbO46p8eNR7hIQM73VbPSwLRtaRWkulEnIPpA67fLYkhMHTFFamMEC7V
	4fTmCT4YoHQ93Nbx2iXbgkZuwQGD77fSrQxBfxpU35EFcOjIj5Aer2SDa0xYooN9fcUPTyabob1eI
	/W1w+gKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wesu0-00000001RJb-30gl;
	Wed, 01 Jul 2026 11:14:48 +0000
Date: Wed, 1 Jul 2026 04:14:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH] xfs: fail recovery on a committed log item with no
 regions
Message-ID: <akT2qDLIwGHHkWIB@infradead.org>
References: <20260629162452.2566242-2-bestswngs@gmail.com>
 <akTzkmAwaDkAK_mM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akTzkmAwaDkAK_mM@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 01, 2026 at 04:01:38AM -0700, Christoph Hellwig wrote:
> So maybe as a prep-patch remove the existing ASSERT(0), then as
> a second prep patch move the list splicing after the loop:
> 
> 	if (error) {
> 		/*
> 		 * Return the remaining items back to the transaction item list
> 		 * so they can be freed in caller.
>                  */
> 		if (!list_empty(&sort_list))
> 			list_splice_init(&sort_list, &trans->r_itemq);
> 	} else {
> 		ASSERT(list_empty(&sort_list));
> 	}

Actually just always doing the split back might be even better:

	/*
	 * Return the remaining items back to the transaction item list so they
	 * can be freed in caller.  This should only happen when we encountered
	 * an error.
	 */
	if (!list_empty(&sort_list)) {
		ASSERT(error);
		list_splice_init(&sort_list, &trans->r_itemq);
	}
