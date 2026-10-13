Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DB73AA1BC;
	Tue, 13 Oct 2026 11:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892045; cv=none; b=dtJ/gGTkqEyVYrgFLGNeInP9V0sdb9hlhS52h2S6huG552nvQxh6AHpXh7v01SCnCW55aVcZDt/i84DaaSq9ZveKmWjkKaD9AJ6/trAzAYN46iycaPYDTZRLaS0KKj8hc0L1tkWXnQxTcMDrXCzQ6esk7dDRKgf973vjIjO1jKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892045; c=relaxed/simple;
	bh=jBvqA4O4jklsj/aghiJlj9CDD9/vMZUkycL7dgqzyC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hW+NClV2DEfn3iZipQGDjm8YYOm/YnCLxbkCqOTqBFl16O47/FCGo3iB+7a9Pj/FI7+9JyAoOrsyybMrjnWiE9WzlhfZKnzUlPwX3ym7aEsJB5LMEiobme8iOyNNqWUW6J8zscPVYWINuY+KoL993BvBaUIyhEvhQKwPgC2DQGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=swipXv9i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="swipXv9i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GxlX+ShtNz1TQ/5m5AmkITi1xky44QKYlGpTPsQ2g/g=; b=swipXv9ipTOgfkPRxrOYETZpzk
	7rz/MH/fEPWK4jqK2QYIESvWUn2nQsWom8bh48sgvclBP/nuwA5okc+4djCJoGl5lVFsjjFTKL3qF
	pdlhWgbdfh810VY0148vBMN+VSu2YD+MCZHdPw/zDZthz2ZhTK/Od/C/9tuGHtIow7gaZvqP1Z90a
	v3v5vSQytsSyeOUiB+W9dFfFB/pfj81IEFOI8EgSPposrepmsMQoGUCOTm13m/BaJafxm67AE/G1o
	qRfrBOeLVu6RBFw9wKnEwd7J2MxjpijStynIKcWX0QeuO8C3jcFb5+QlPl17K1xMBxgLrltExXrxB
	SSKvQGOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGayX-0000000Ck7J-0Lbe;
	Tue, 13 Oct 2026 11:47:21 +0000
Date: Tue, 13 Oct 2026 04:47:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: only written file data blocks can be shared
Message-ID: <as4aSXKdzAksvwey@infradead.org>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
 <179186107268.1898400.2017479521256451856.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107268.1898400.2017479521256451856.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 12, 2026 at 11:06:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
> will count any rmap owner towards the shared count.  However, the only
> blocks that can be shared between xfs files are written file data
> blocks; and the only blocks that can have single-refcount entries are
> COW staging extents.  Fix the checking code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

