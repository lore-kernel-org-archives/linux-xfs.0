Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6D379FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806446; cv=none; b=IlXQnj0zTItO8sC7+N7KAVuE+lOPBMF33RU98SlaGXs1+ZCL/Bx4tgE3grno8jdTWu8xF/3O7maCbQUQ0GSPCBJ/zTdFQtGt8+H1apfeFkcVPjwlhDMDsqq23QmBNT6gsbjqwO7UmvwWKTvHRPIDAwJ7rCH4VdwKDlqJGNaXRKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806446; c=relaxed/simple;
	bh=2vtD6ewgFLQu1Acagg+xMteIQBHiQ0bN/75b7AY3OOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrOgqlv7l1pvCADgcmU30QbqwYyOJreSrR9BTLEef9Oo7OLFxVCbdbeZEgeOgC/Gw4sjXaShML4eXkdWh23kEfMvc8fskvSFunYB5WfxRfLZwOofprtT7LsniIVQVozwuDIYUq1D1ez0sBEFF2A1H4UU5IUnMlzZxL/F2CkMDvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u6iJjDnt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u6iJjDnt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HCQOwWW6Y3sPkBmjDwCvOKb7AwlJtfjzHVLP5IbUXWY=; b=u6iJjDntaRk47VzmcD02iNtg2u
	e7Mh8MiJM0uQ2B+HUW0dzT1Hv6dWanjcBHLe5nNb2N9gSeEge3cvxsQSrG9LPlNVOvZ3Ue4409XyI
	2u56BSoVaV8emmMnvghtgPmQufyxZ38gUokC8ILKA3YHJWWIXG7l3PPoExGmYEEhx91eDlZhxBnF8
	Y3uSqfPPQzKr8BE8Ux+R7s//8vTcDJJ5NKPF85EJcUct6whXopDjKyx6xzI80AcfX8mEPwmAHEjdx
	20Gh6cbkVzX0JidFn3k2NdCZv/+m2h/4mgS9YcAJdwI+wMv/qAme1a376S2F31SHz2WAuuAzBP74s
	LWTScwFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsG4-0000000AEJX-3jUS;
	Tue, 10 Dec 2024 04:54:04 +0000
Date: Mon, 9 Dec 2024 20:54:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/41] libfrog: allow METADIR in xfrog_bulkstat_single5
Message-ID: <Z1fJbH67BF6eax2V@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748346.122992.7654454749259242564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748346.122992.7654454749259242564.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:41:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a valid flag for a single-file bulkstat, so add that to the
> filter.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

