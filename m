Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844DA4611C2;
	Mon, 28 Sep 2026 08:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582990; cv=none; b=cu2J0bFrYpir6hnvtp7LrgzZpmQzZ0JoNBYU9c9GKgQbaeoe2s7WqC9o6fJsd+vwIrfkx7powASYfk22j4lM3cG75gnvP+//WRY8qeylx7EAtwIFX2D2/GqO6PhKTVT36fwa14kW0qI0r5K8+yQ2STGf98fzgS8cYv6qRa/OW2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582990; c=relaxed/simple;
	bh=SXBUEOS9y02WQrMO+wcKiBfAgnHPtlqK6i0j8o7i3M0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSC93ynjhnoFlQP66VQo9wihAbCVc1hjzGdnNdKC5wu4hUtd98RMLruazN06I5KkKnU8Sg5PnsKcT5fizNdzcQm4XOoqdbqNBMUZf9mSM7GYeF3M882/hB88Pp5ASEYmWe8EsZTGg/QimrMX3PVc1qVAKdpzrwCrXrYWl7HXP9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2fazgZ7M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2fazgZ7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SNZLG2V1urFByq4/pqhn2mcAe9OCRe0Ox5wr/FCAAVM=; b=2fazgZ7MxAPiyU0FGX818nfjns
	FexW6paXSEbTx/I4vGpLXN+/00TJLw7F5845OWXHBczKHNQvob0vPhVSSwluLQ5DIoxxwTLfNgBZj
	VnzE/mirmehLfYyjjShpviOBXlVs/PB994E57zHpHnssjtjrdj5VnFdapXKNVoMjv2PZHdDW0emgT
	m132Nt60chVfBtd0XigNn1K8tmOU4r4jo8iPWkyA+No/Pf4eGv0fIefZ2Ye6POZP++ROrmhF5lPRi
	fs8vCvrt+6K6vYHdjNHvcvbfhYKDSjOd6g9eMpSXrQFnqTiT0MlFtCGsUiyCd3RQP835F3MfOEarQ
	YYMxIQwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6Qm-000000001we-0Ijk;
	Mon, 28 Sep 2026 08:09:48 +0000
Date: Mon, 28 Sep 2026 01:09:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: fix lost errno returned from xfarray_foliosort
Message-ID: <arogzLRFrsRpXlBC@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612788.479634.1850482672854043572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612788.479634.1850482672854043572.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:18:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we stop the sort early but don't actually pass along
> the error code, which could enable repair code to continue running with
> an unsorted array.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
