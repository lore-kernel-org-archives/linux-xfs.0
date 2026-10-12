Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F348E0EA;
	Mon, 12 Oct 2026 13:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810363; cv=none; b=dJVgWKtVk1dzcmnkbhi8boNX5JmLEpj5BxlyzodGyW2Ds8sfMEey4jgloP+Et1ntt/zxINNFs7NMwCUCqYDbfWJgjjnVWxg4O3ZpmOMsRqn5CT3WlfXICYpief2q1qS9HM0C6cmKPyfdnQAIBoMfDwWWNftnf+vuvK42wJuIQi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810363; c=relaxed/simple;
	bh=/9te7BWhmckR8mRu9aw8HpppNhz6cGUhdWaMmlAEvmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSgtRB9JYLtZKFnJ/xQlRnUbVem3Ju1XzBZ7Nag77l/ZAD/FIcThvoiY3Q9dEL6ErMj4LF8MpZnl7ssamM1y1z6GiN3HSBV1xNysf2GRatNRvaHMUgV9pvS9yRXJi9oMJnPDP++XgxUgVLdBUZK1kZgnRRGEF+Vr9wwTN0pazCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Em1IeWO1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Em1IeWO1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D5Aoem4IqybIFoFQUTmUfe5KzYTVg+UOY9RIiKi/Y8k=; b=Em1IeWO1rKDCI3iWs6j50UtRPd
	Z2WaUQvPgwRvbWnTFYvzv7KSExV5zZ7v8jjtQhrYTx07Zlra8nFVoJgaWxIsQH9wTldpk8erYeFtH
	ZYOWHvHb8fDQb4ZfkKcVie8cuy30FtDtjPsAdahlOzC6lSOjtavhWyylounX/KJSVDmde5+omcwHS
	2bJMJuP0X/Vi/BPsXxjB9JrCpxfQz0/IbzOioi4E2q170iE2BsOSSzgrgqicKC7G3NtcTZzFRZCBE
	hYvvlTrT5ZD2cg5TfxsaABo3MtDlHLMqXpADkxUtR6+rqC4HCALUBR0hLzUDDbnZldCcFfG/AAhyM
	CQgkQRyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFj6-0000000AWsM-3fnQ;
	Mon, 12 Oct 2026 13:06:00 +0000
Date: Mon, 12 Oct 2026 06:06:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: don't overrun incore inode when cleaning attr
 forks
Message-ID: <aszbOACB5lRrBENa@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065216.1058326.11136246616445475827.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065216.1058326.11136246616445475827.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:55:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_dinode_check_afork doesn't check for a
> di_forkoff value that is so large that the attr fork would begin after
> the end of the inode space.  This causes afork_{ptr,size} to be
> nonsense.  What we really ought to do here is zap the attr fork.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
