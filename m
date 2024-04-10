Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C96B676
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726771; cv=none; b=S9yDDbdMtwzUpFW39TvgX/dZM5+08RpV8v1xxNHp5fzFVMtLtzY2sOq+KJrvkxr57l5DUcf1Tj4ZJgSOSeOAPfOm1/AUPPc8FJw2RdQQoYhtg2JzSEsWDMo4JpAJEX+flQVCpaXB14a4cAxwIPMooFtK1U3jx+jgJpkn3p72dQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726771; c=relaxed/simple;
	bh=TCDG6x+2/DWOdeHaQS2nGfz21GFY4H9MaJ/1UDAGv0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNB0N9/nkZlA5w1yOuB5Zck06dp63CEmRIzJFmFVpaEphcB5UA8d6XkfMNYs40b49VfH3ewiRLT5fyyp+7XVGCEca4gHU+txQA9XHXtnZouQraNWbCdYs6G7y2nJ+QA1Ojbw7pIWc92O86xniK3OFQlBmgSS9P5v31y5kX+yQ0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Vl0+5pb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Vl0+5pb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XQWtpRUubKJh74yxfQzP8qjIuGm0SynWSIe2zNilUic=; b=4Vl0+5pb7eBqUtndIhNmIXUsgX
	4be/V3s/pgsWd6JdGXVKo51/9PxbaRGNG8gKEtFay/BF4/R49dZxoH/TQZ5lUIrSHQ3wUXtPOgZ5L
	+j9Uw4X0gAmx2D412gmBActLPr2gPy8cRQ3ECBu2EtjdjKzyg1BrhSQB4WlZULGZAoqu+S7Q1TOrY
	K8xH8P9F4EvB5gkkgozGGtuGOT9dQSpm1GJR1DYML0np7hnQMkKbsNMwP0UMw4KL/SQ/Gm8rkElsG
	pBbZ7/KtVYjgpYLp6REY275pMgwyqJWUyyZbpNt2VN08AlHrGOjRn9kCtTqqaoxa/vPxemSe0qjVc
	YCJ2NLxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQTH-00000005BhG-19Rh;
	Wed, 10 Apr 2024 05:26:07 +0000
Date: Tue, 9 Apr 2024 22:26:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/32] xfs: log parent pointer xattr replace operations
Message-ID: <ZhYi73ThMtCUVrF5@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969740.3631889.12974902040083725812.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969740.3631889.12974902040083725812.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:56:22PM -0700, Darrick J. Wong wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> The parent pointer code needs to do a deferred parent pointer replace
> operation with the xattr log intent code.  Declare a new logged xattr
> opcode and push it through the log.
> 
> (Formerly titled "xfs: Add new name to attri/d" and described as
> follows:

I don't think this history is very important.  The being said,
I suspect this and the previous two patches should be combined into
a single one adding the on-disk formats for parent pointers, and the
commit log could use a complete rewrite saying that it a

> +			return false;
> +		if (attrp->alfi_old_name_len == 0 ||
> +		    attrp->alfi_old_name_len > XATTR_NAME_MAX)
> +			return false;
> +		if (attrp->alfi_new_name_len == 0 ||
> +		    attrp->alfi_new_name_len > XATTR_NAME_MAX)
> +			return false;

Given that we have four copies of this (arguably simple) check,
should we grow a helper for it?

> +		if (attrp->alfi_value_len == 0 ||
> +		    attrp->alfi_value_len > XATTR_SIZE_MAX)
> +			return false;

All parent pointer attrs must be sized for exactly the parent_rec,
so we should probably check for that explicitly?

> +	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {

Please avoid the overly long line here.

>  
> +	/* Validate the new attr name */
> +	if (new_name_len > 0) {
> +		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(new_name_len)) {

.. and here.

And while we're at it, maybe factor the checking for valid xattr
name and value log iovecs into little helper instead of duplicating
them a few times?

