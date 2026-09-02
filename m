Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C23DD520;
	Wed,  2 Sep 2026 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333700; cv=none; b=uHwXc1L85UY/2+uvjptme+d1++GS0KKxzd9g13o/GV6Fu+EPiC7s0rdjRtzci9NntrGQn3MsK3/4ae0AL0wUMDbxllijwR3uHIkNW4gd8wV896gVRoU4yqdr7KUpaYaEF9mCOoxZ7BytjYPltUBnVvZ5DjBItMl21jNCwbxTneU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333700; c=relaxed/simple;
	bh=JKPJclYeUdOGMoEVRPmsucPRK8/jzKNl1bgJmXj8qJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnsxLSAgzf6F9aHmMpi8qgprCT0XZZyiNDDzZE853dRtWf6+cXYSn7NAjLMznv9Zw7Pyjrq9vTVc5OB+Tyc9Qfz5HDJ2DuPt/GpRZy3ZZeSmNAKEL7dKOjGkpHUC+F+IT8roILPSiP+FGDK9n3exawqXKiQ+lcpe/3ZKB1Qs52U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C02F68B05; Wed,  2 Sep 2026 09:21:26 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:21:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: signal inode btree xref error if get_rec
 returns an error
Message-ID: <20260902072125.GA26173@lst.de>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs> <178832750731.3508131.3210719479030610829.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750731.3508131.3210719479030610829.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:48:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that xchk_finobt_xref_inobt and xchk_inobt_xref_finobt
> both ignore errors being returned from the xfs_btree_get_rec function
> and proceed with a (possibly stale) "true" value for has_record.  If the
> *simple* btree record checks fail during cross-referencing, we can
> immediately conclude that there's a cross-referncing error in the other
> btree.  On those grounds, we can bubble up the returned error instead of
> wasting time cross-referencing with garbage.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

