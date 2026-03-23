Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBDF2D5432
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 06:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246068; cv=none; b=twO14YmbWHwvDHdwf5tFHMBOGdvZdxCrEo4oc86DjqHfm1w2ggnvI37FOU1wHSBIetTHCitIzHptLAtE+Xzz5YGiM4yvN/be8zZny5Nl/9tS09ldnjMGQ9FWyNe1vRONNCx5VY8V08TRgx5+Rn+cXfrphvcqtCs8EVSuSosJVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246068; c=relaxed/simple;
	bh=kOoV10iIQqHYlomN2aZKaDrGhVj5Hc8oL1JODtSptww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l5PoUeXJkSj9kFcFySiI7C90fq2kZQSX24j422oGSsBquBsIxRgFDk9srJ+AIPPPfgXqFHANaIH798A9ZPzIOLFALWaaEuDf/+/LPneo/5cXXVV2iA8BSRC8N/M/kYh3QCT7MoFKVp3T2c/b0mRtHCQU2ih4IxzCsD4oPRKEZVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t631LFiy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t631LFiy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RJohu2YXlYma7icg3QQ9YYcAhKO2Ed6//hiHRCSXCiE=; b=t631LFiyHJupmIwpWt0z78feF/
	tUScs+/9HiOZPe4PhAmbHQaHuMXYm0tBg/rgDEUFGtcrfn5/MMF5uH82Dvl4NUNUHwsP9xEI/DW3d
	ESprADrUmQ6sZy2FDchdb/lUGbMqacqWELBz1Vc6hLBysJ93fq7KJn4w1n8KwI+u9kCt5/EIqPmOw
	HlAOAI8K1A8DJ6spyPOKMGsql7WDRmamnALp5HDIC8zwUEeeZnDcjy8xzsyfJVo9v4Goa7w4mxhkS
	cy+1/nredsNrA4MqAA9BANL8n44wDDKy+VoAEHRS5ZWVkAhkocjixW1lXtZW+YTHfIAP3yY2Bo8/j
	1JreVVjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4YS2-0000000G5ws-1Hke;
	Mon, 23 Mar 2026 06:07:46 +0000
Date: Sun, 22 Mar 2026 23:07:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Long Li <leo.lilong@huawei.com>,
	cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: don't allow UAF in xlog_recover_iget
Message-ID: <acDYsmwb5x66qcCB@infradead.org>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
 <abz098auEFKW0D-m@infradead.org>
 <20260320143719.GA6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320143719.GA6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 07:37:19AM -0700, Darrick J. Wong wrote:
> > Why does this matter?  The caller need to check the return value.
> 
> I think the fundamental problem here is that Long Li ran a static
> checker, and the static checker suggested that the callsite in
> xfs_attri_recover_work should be fixed by guarding the xfs_irele call in
> the error handler with a null pointer check.  That's completely wrong,
> the xfs_irele should never have been put in the error path at all.

Yes.

> So the proper fix is the one in the next patch that removes the
> xfs_irele.  At the same time, xlog_recover_iget should get fixed so that
> it never exposes stale pointers in the first place.

Agreed.

> "Fix this function to avoid exposing a stale pointer to the caller when
> returning an error code after dqattach fails." ?

I'd just drop this patch.

