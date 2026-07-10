Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C338757B
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2026 05:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661881; cv=none; b=krwHrDfPDzAx9Ki8PEI0vgdOWhlKcu5lKO0DxFukrRxwoOLNAhthtp4LvEPBVmMJkV3KNigEEHVoz6ns6F4W6jaSLOffzM2ypSNXt8Lx/2cwc6ELwV1u0HYqJIlx+PyTxj8XEUsSfnlRjWJ5bDQLf+/iML5eYWOaZh1nO1N1+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661881; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0QmKKCQckSxKCIl1+DQRNEaB4jWTD0eTTU62oL0M7XAWVFvceZYdAuNIJ0QeDFm2lm45gL8hGfGpiN8d4YLI9yOlOUNoY7RAQwG9coN2Lx674244hzl5lz/2THZnubHRWdS/4AeIluoC0yDo0N8Dk32ALeV9pmcYpQR+PdPJyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2CD2A68B05; Fri, 10 Jul 2026 07:37:56 +0200 (CEST)
Date: Fri, 10 Jul 2026 07:37:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move cow_replace_mapping to xfs_bmap_util.c
Message-ID: <20260710053755.GC7392@lst.de>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs> <178366081056.1173468.2365303915396495079.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178366081056.1173468.2365303915396495079.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

