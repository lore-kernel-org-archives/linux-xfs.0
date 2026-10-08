Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F79B4848AA;
	Thu,  8 Oct 2026 11:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460456; cv=none; b=mmF+sluMhz8918v2fHveSSL1Bxa6jzTChJj8ieOl13u+fOurGFd3dwgZ1SCp5TJn9Prrjsf5W0c0oLGufh28ASi1g4Ezxe4vd5Z1o7O+000w8U57ppnOj0/7GA/tm55/vfVk2Tm6W1kxItHVjB0YZlMnRSf8K4vc45/R3YGA2wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460456; c=relaxed/simple;
	bh=KRzIZH0ZRBGXiASrPg831BJq6YninCr4ou92vcJLpDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+wiyOc1wyP9WGgA4ntFJpVk/xMZ4aUoGVCGpfzLdZyOTAn4PuFUFio3eWnfXBt5qa5TQ+8EtnrYpU2Ab3d/AT42LlexZk/5WZyceWIUz423wYW6QQwrsp+QJm7U2aLc7HWn2ZWhaip183HWx016xsUqyGNYVl00H9iNVDht7wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GX1fEck8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GX1fEck8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Ft2AMKHse8SqOFPM7UQs0Ost+gFShtkPcccN0cjvis=; b=GX1fEck8RETJMqiJQbWmmubkix
	cW0+PVQOtdmL+9bbIrq1CrA5OIYQMcuLe6C6lodYsmcNg2Wn2HpOTUPq+HpDSp567EInltmJH0EKc
	SpOZ8gFczEpAUhTXjeE1KaIJewD2hlfuVeA+6a7xw7Gs8Rhawl8GGeRQ+q7W/EnSALei93iAU6Mju
	f8sfFfCfgStrW/m9+CBdy5k+AScecD6+8DSkNwMPSQ946YpW3YfV5LcQE1IX/aPeVrO3Q5aI0MxWo
	bzaTLdtazRESoAmvexBz3WVGJbYKUbwj0CBeFmnTZcKhg9ohCiXgpfUAj84+uTe+QY+5tGv0zzeRd
	+kdSF9pQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmhQ-00000004IGx-3LXa;
	Thu, 08 Oct 2026 11:54:12 +0000
Date: Thu, 8 Oct 2026 04:54:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: don't subtract excess usage twice when
 computing agf_btreeblks
Message-ID: <aseEZKG8wACedf9W@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521299.2728617.2877901149807191718.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521299.2728617.2877901149807191718.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:55:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the free space btree repair code calculates
> agf_btreeblks from the number of blocks we wrote to rebuild the free
> space btrees (minus the roots).  That's correct.  However, it observes
> that we subtract the "excess" reservation, which is not correct.  Fix
> this accounting problem.

xrep_newbt_unused_blocks is unused now.

