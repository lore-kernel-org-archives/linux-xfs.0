Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AFD17CA1B
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104634; cv=none; b=Q6J3C1GSTkYtgrNnCP9cIfw0zQoP4vjT6TkJ8tlffOo0Mdfi8xfx7gbLPmzmFyO50/Qb9Zr+6o+P3NMXX/M0V+EdiE3dvs30eLL+2ntoXLJ0VISaI4UEV3fWWfzP7AfWNVIzU+c7p1J2+CAUDSD1p2+SM+82dxQQ3oAsMgPhucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104634; c=relaxed/simple;
	bh=y02II7vZMuuF2P3T8dVaHDvQc75PnIKCI/hDomalXWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQwsbp/Q3unNGqytjy1UFA7TvTW+vmAGgHiGhZ9xuO0eridjCs8Qrv6vMSqlts+3OeT6vp7BIX2YQdtrwZYUb/+/cyZOMWeWaPF7rWDo04h6scml4tX3p3/KOK8OwXlJSinQa2AsAusb7r4VX6p0EtVMUVjvse/y0TGRMRqyNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0xgfWMU0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0xgfWMU0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SiW6dUVK8+1ilC0pWJx2AOgXnkSv2uRiP6fAL+jxvvM=; b=0xgfWMU0H1HyqAo8R4i9iZfRWG
	UgV2Luft5WRSkdLFY+U5oOzY48Xcib+p0l4fVlwdpW4PWtA2W1kQgkdEtPoX54O6/M0atKtc6ZAhb
	55qcRb5cN8CAyllqQTYFThZd1wwgiciuedXnwWHnoxZZcvymoHE6rh5iDOAQJ32x1sOtkx9ViY/wv
	FY/p5mErXtRWSIb3psB0juhPzGPrzsICjnlNCQv2zzwN1Tr+gevulUtf7prMEQImUXMZCD/2AABEU
	ClifJ1TOodB3FY+ABe1MTzsLlRJAT3du8Gv7p0FwycLnmxdaLl8YT44n+KqAYS79QHlNixY5OxVFI
	AfmbQcOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LFQ-0000000A7HW-3fV6;
	Mon, 28 Oct 2024 08:37:12 +0000
Date: Mon, 28 Oct 2024 01:37:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_db: access realtime file blocks
Message-ID: <Zx9NOOgASfMFkqzP@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773789.3041229.10050634092165024838.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773789.3041229.10050634092165024838.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (is_rtfile(iocur_top->data))
> +		set_rt_cur(&typtab[type], (int64_t)dfsbno << mp->m_blkbb_log,

Shouldn't this be xfs_rtb_to_daddr?

> diff --git a/db/faddr.c b/db/faddr.c
> index ec4aae68bb5a81..fd65b86b5e915d 100644
> --- a/db/faddr.c
> +++ b/db/faddr.c
> @@ -323,7 +323,9 @@ fa_drtbno(
>  		dbprintf(_("null block number, cannot set new addr\n"));
>  		return;
>  	}
> -	/* need set_cur to understand rt subvolume */
> +
> +	set_rt_cur(&typtab[next], (int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
> +			DB_RING_ADD, NULL);

Same here?

