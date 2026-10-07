Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3321416873;
	Wed,  7 Oct 2026 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378250; cv=none; b=TFKdZtzpX7lrMWcTvE2BG3CUwHpCtMYjJDQjesGY+Yoy4DKl1BNuvFh0lhoukPehPKuoFsceyQfS0TkeVigla5FgbFoWtltc3bHZJUOeUg/DMfdVUi8FJ2whpoRx5EDn2T2LaqSeS6S5h2Wd/fMK5bXpEafa5zkZ0XLaHhoJpcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378250; c=relaxed/simple;
	bh=0EcqQlK0PwCVoJ8ZIVA/S+8cFjq4nksRozXu1ugCR9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxjJWBUmeiTouWTTS5rlsYCzAiigOuAYCYyLuydSJvz66zl1IAeiel9GU7xa0aoIChDEk3Mnh74fmzLPY+nCfq7p5+RsNx3+zsdQTxBb6l5kofXn6FFNGccggoCNj5s3ChLpj9sLnlQmF1g+LR9LBahwGsOlGOyLMiPi5b6XITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I5yPe515; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I5yPe515"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OgkMB6SjTW9ZCjm9MA4Prwr/Ql1CaMjfMIA6cktpddo=; b=I5yPe515r71/L9pjK9eLozDQ+l
	fDqcWP2XoYj5SWV+yi2G75UCBK26USFF3weoGWVxe1a88K5pCKBzy7qR6kO5TSmZUPHaskpUxwalO
	KGJh92ZJusLiR9N4u3rM0T8q0qq+sHsTJhKqXPqBngOtvjnb0cKBtG2olCSE9Xp4nV98yLKUp1geH
	V9mg7AGvzyei/wR3Z4EPUDXtT/3pPU7rZUCSC+K3Rp8FqW2e2WRhYzB0tG+04gUs8litNWgm5vDRq
	/dhW8TQ3BAEOcuzUEsVlBKBuweFNjPTkvz0WQQlgz4WxbDA5sYdzp1f5b2Z3/Wn/baB/4VxYylpnI
	CH4YK+BA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERJP-00000002V39-2Ytf;
	Wed, 07 Oct 2026 13:03:59 +0000
Date: Wed, 7 Oct 2026 06:03:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: don't pass iget failures up when marking
 ondisk inodes
Message-ID: <asZDP2aQ4QUvxWKW@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965094.614350.8297165772601670682.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965094.614350.8297165772601670682.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:56:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes a couple of problems with this callsite -- an ENOMEM
> return is completely ignored and a subsequent run through the loop body
> obliterates the return value completely.  Also, an error value
> indicating that the list is corrupt can get passed up (thus terminating
> the repair) even though we can handle corrupt lists.  Fix the callsite
> not to have these problems.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

