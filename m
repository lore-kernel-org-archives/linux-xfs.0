Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5340331F98E;
	Fri, 24 Jul 2026 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912725; cv=none; b=OQIvlLxiMnSD8UEDjafebKA64PVIhMqosmn7Y3BjIxJr9lhTuaBvY0/dJl0FSBBQ2ccHUXVAcxAwPdtWoNYrF3O1ugaaVdzoejuuyknQUhylnbNC8RAyvFq1QVb8DwR9k454kBYBBKCU0nmiZLfalAqYEAO5xa4Q6OdF7C7T6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912725; c=relaxed/simple;
	bh=4t2BNpUTtP0gwF497QhNVeHsIQrl1HstcRobT/HYFu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYxalrraGZJZ9mUNcln9YUlJcYUJT2rd6g167FtWenGHmCprJ/8VpsusOwen69Qc27v5uJh9GeqGluqucp/n2hQfvvH/kezCNrtrp/QhZ4V7nVgMqRFXLYopK+bI8iDdKahfHUw2iVbzSLGH/yP6ND5da4+SLDO+2EVAm8TAlm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8p+7gTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8p+7gTh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A65461F000E9;
	Fri, 24 Jul 2026 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912723;
	bh=Bk5PLbfiyZlsgricbiXgD0+tiZadLpYKstch4InsleM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O8p+7gThZMv5Hj5AjiLhmtH7KxwmbJ1F7yqFqKj0PMcjs3i6H3ShQ4Gr+SJWcOjMT
	 jB+b6a1fSmuUrVgCJ8r1Y91Z7m0S7HayCn5gEaC5tYdyD0h/vtygspUEaIMMY+P+Z2
	 sN+D+tvocimZkkBa2hBspNP7eu16D7nRu6InUIjo61CiXhlwK+3uCeWuybBHZRN8i8
	 z5uLO5ArX5RcZVPIhNR8jpFF9yefjiWijyh5U8F9dQ4rqyKbnf5OZuqx5DoV3n8mDs
	 naMUjBhGsxikafayfRD5if8imPIB+A9AoVfJPEprpVkxyPaSpu1LBOrGRlnuwrGftk
	 HVbOzBUUVLYmw==
Date: Fri, 24 Jul 2026 10:05:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: don't zap the attr fork on repair when there
 are queued pptr updates
Message-ID: <20260724170523.GA2901224@frogsfrogsfrogs>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs>
 <178487405462.3442778.17642300701831053718.stgit@frogsfrogsfrogs>
 <20260724132526.GD28170@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724132526.GD28170@lst.de>

On Fri, Jul 24, 2026 at 03:25:26PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 23, 2026 at 11:22:03PM -0700, Darrick J. Wong wrote:
> > -	if (rx->attrs_found == 0) {
> > +	if (rx->attrs_found == 0 && (!xfs_has_parent(sc->mp) ||
> > +				     xfarray_length(rx->pptr_recs) == 0)) {
> 
> Hmm, this formatting looks at least a bit confusing.  Why not:
> 
> 	if (rx->attrs_found == 0 &&
> 	    (!xfs_has_parent(sc->mp) || xfarray_length(rx->pptr_recs) == 0)) {
> 
> ?

Yeah, I will fix this.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for reviewing this series!

--D
