Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26861259C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387733; cv=none; b=XiJeRnEgcDg0/7UsxaO1BOXTmSxUiLrGC0jBCsiFbD6ikvYAtkfi5URd6RfC8y6yBT99LNniXPqWmzzWtTCKI5BEouCXUgrIShscPqaM/OruyC4EM2ebMSrPk0J6IETNDdR/dlFr0dM2N+xnf7YLp4dGv6llkF1Sbcb77XPUx7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387733; c=relaxed/simple;
	bh=t7WxAgWm23NphT05tOxm2DfRGeXmEwPOBgGDTVkRhR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJiuKO64G5YeWdgSgcMH47SL4NTCWZVWlrsM9hXtFWOGaD8s8sTulWwrOp+r4z0R9ynnag8/rXt3efiY7Ooo1I56Cz/s9vz1v6fd+LsiRc7dT7K33bkX3SOZi5/maqy50fLhm+OoeNNF6lp24+nFSl+mxgqe2dWPwwVtZDKPVTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I3eI9TRY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I3eI9TRY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t7WxAgWm23NphT05tOxm2DfRGeXmEwPOBgGDTVkRhR0=; b=I3eI9TRY92Y2Lcq1JpfuxsiMQ1
	UBN7xk4YThQkOR+yO71E9BNjQgb4dd14RssHScY2RhJsVeUqdPxzQ35i765nK948v/BeUgIOzshi5
	+3eFdVEj3WcT/m6mhS31dxBPpTo7TG7whAbMLTLlRAn6hEqRRNkoDYbcqeflGS/Tg70vgnz5ioaCS
	pLwHU789YV6SOqoImD/ZQ0PHfHY4B4EwDQcAagkgz0HF8iacPxdSsvcZk4uGMN7axYBaOnSZWahkJ
	ikQRKtjpkPHUfXQFPKA8HJRglLteqFYaRS7lHVEfX8ADoPQeJmRG7FyhPYpJTofKg6akkq/ZnI5za
	XZ3FpVgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM1L-0000000FCwB-3KZB;
	Fri, 23 Aug 2024 04:35:31 +0000
Date: Thu, 22 Aug 2024 21:35:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] xfs: iget for metadata inodes
Message-ID: <ZsgRk77J03JO18ry@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085223.57482.4228252253880312328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085223.57482.4228252253880312328.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:02:56PM -0700, Darrick J. Wong wrote:
> +#include "xfs_da_format.h"
> +#include "xfs_dir2.h"
> +#include "xfs_metafile.h"

Hmm, there really should be no need to include xfs_da_format.h before
metafile.h - enum xfs_metafile_type is in format.h and I can't see what
else would need it.

I don't think dir2.h is needed here either.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
