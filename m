Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F21949D5B1;
	Wed,  7 Oct 2026 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378402; cv=none; b=GlWFDXIBsSW5SeOl/ElNDT96X8sQqrAjevXQKCmF5c+Hp6goReO1BcpOhC5IEY/YFbUFCZuzZ1mHzRHaGWWosFC488of47O24gwsG6pePRbLVN84lKvfGnv/GCuQXK1wfGzXmnlSmYroUovIkgy31tYrh/3DnkMIkhs4BeCcycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378402; c=relaxed/simple;
	bh=WbaqwF7DKbKIcGBIUIfZKf8iJW0Q6hHtOOm4+2w2zL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MY2CU+JGRV5qcmmXEwD09PbDZIs/1MHcqMiZwmAd6TU6DdYyM0TXWzgbBYXji6WQ36jGP8IH/vR1ZB3s/HLeAMFqP7qRuxZRX7mN+CK5Tg4QPo8rGz6Cen3nyxo94+0XcG3hQVs4KBBrKW1u8tsLX1Y/bEtUIHAPn9UyS1gOe3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aQt+Onbm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aQt+Onbm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TVVuVnmSAwbw4PwwX/GadZlHLDpKqnOH6RwopXGw4eY=; b=aQt+OnbmOZ8SZvfAEALA21LNCo
	i4QWJOSJwO2TUSgHsULhM1Orijho+d7XLGFUkcjQEI9Hsdp6haLIcR4rldSWxI0TQ9MWCCsx+RPV5
	eTYRwBrQkJjxmVVj/4WRb4G4B+OiPZ0vcty7HtJi6QebggMPPXVFuSgoXxhWaApClib4dkPOw/7gK
	Ubp7sDNoAmZMBBdlW9TqK3bvC6J2jMPYk3r7RBHc3ONMpJsQBx1xWfDWKEmndGfoJNdszbdrp4/XN
	gMb/qJl5YK6DCb3+Spk+IBMZpV3rJwIm113uLRkQrXp9mCCbU6GDyiovYYCVEh+/2L6dnHefqfiWB
	cs2csANQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERLp-00000002VN2-1y2H;
	Wed, 07 Oct 2026 13:06:29 +0000
Date: Wed, 7 Oct 2026 06:06:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: release ip after unlinked list store failure
Message-ID: <asZD1eiFdTdca5-N@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965223.614350.12123807601095557612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965223.614350.12123807601095557612.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:57:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If, while processing an unlinked list we see an inode that has nonzero
> link count, we fail to store the incore prev/next pointers, we should
> release the incore inode instead of leaking it.  This was in the llm
> fixes branch but fell out for -rc7.  Weird.

Still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

