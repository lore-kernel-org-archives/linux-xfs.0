Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC611391;
	Mon,  2 Mar 2026 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772459664; cv=none; b=EsWmTc8M7/Pxs8oXbU+KJFWhmLEvovAQcrElQPH17RvblYLpfe9N6SrGR1ifMGuDhrLpOttXdTpJ8Ai5tMqxDzjG6e7yL6FviXNgY/fQFAetIDXpvi2OLWzUQQ+1Ir4JyUJ6dbDYvt4Y2bybdLO51CsmsSKnqH46+0BC5cjKYas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772459664; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FxAFdAfyah4euOJ0+5gTi/BRpyO/xxfbxmnrkE9IKgfeWprOYchE/VuwBmKUC0OGAx9tNKXqyuwrvIXCevw6lgCECM2I2CkagnGpmfjgqOnUa+xI9St7INtIZlrels/ujeZL+GCP/6uTtVIS68D+AAM5X7CyHCUW8fTa3G+BQ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E874068BEB; Mon,  2 Mar 2026 14:54:20 +0100 (CET)
Date: Mon, 2 Mar 2026 14:54:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH v2] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <20260302135420.GC22403@lst.de>
References: <20260301003432.605428-4-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260301003432.605428-4-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

