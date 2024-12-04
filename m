Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE0194A59;
	Wed,  4 Dec 2024 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300904; cv=none; b=XJgpSYvlE9HnCTCq/5Kas60otefSH2PMUlJqc4GGbZD1+By8SSftZebX27A7bwX+xFtnJwqSdmJXn1Jn+YzlNs2OS0FnHeMTpPgr2imTBSmcT/OYyj3UX9Z8dzX30B78M2gGXKbEoUapTQe2J6fasxEg12CHLLIAALEtIXGx3A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300904; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuiBddglyiqtGfhl6L0QWmZerLoXfGsxyfTPNHPML5UQgcTIaCxzxVAwJkxU3O+DFFT2lCLowXNvbzr7epBiJL+TBw31LWAVvw1Emfrd/zCFKqGShOBIs+4OfRWROuqNfBD5BplBw+85Slz1pvixPktTSvGppXmO7ecfCHqIPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OEqZweKE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OEqZweKE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OEqZweKEtCQlkHtk4HD+1yZRu1
	iTaA25CjDeBG+vJfMAEnGUkrO8O16sB13CzMsr75zvM/f9YF6rZacU8ktvcIY44KFg6V7wYB1XZy8
	SeJXgxiRF7kK/Q+F3KntqqcNDkYS4jH2LcgcekE4WpjyCeJ+2bp1fD6iytiSH0++zBVTP2RWmaIW8
	j6SPYLpfYROeu5/3BekAnwZtNe5YyKEb5osQTS7DXg8oZUbhC99fXzT7BWfqomzuhwO880Bc8S/4B
	LuP33swXkd2gu4OWTvnHBq+czfOSyMHlqSEAcD8thK3NcmV+klFykpZt52Bbg5zpNCnm1VB4TBsXV
	xTCebf1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIkkA-0000000Bss0-30Ws;
	Wed, 04 Dec 2024 08:28:22 +0000
Date: Wed, 4 Dec 2024 00:28:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, jlayton@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs: port xfs_ioc_start_commit to multigrain
 timestamps
Message-ID: <Z1ASpk6uIgoLLh0N@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106685.1145623.13634222093317841310.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106685.1145623.13634222093317841310.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

