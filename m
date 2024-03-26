Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB9E13CA97
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711481259; cv=none; b=mElFi3GIPLr9c1w+/7c/0J6RPd3A0NZG6Raf6QG2BCeA9rHL3WfP65u5zb+qSe2+/3JceKtdP/VWnmYRRfTyGN9bVTEcnihYl8gtEvnvhU+I2klJ2yCW9RCDQ636O+UUa6214Ss78zlOP4qWhUTIOxxIgKsJ4dh47spJLj5wdm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711481259; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tX5ZiQILCkuF9xKWc7hYLYPQTioIs99SPJFZBtB4aZ5QYlChUusQojd1R0OSx9hT5jgS1DwLRuP1iIHal7D94UrTwlvEpQxOMdCBfe0PbU+FMPWY/HOm+m8+TTctdjUh3YWlTL6nFtrj8rvxkCiBl5fxmx53wEPJjjLIYGfSdJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WZQWQf6f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WZQWQf6f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WZQWQf6fQ71Q2AEztHjvoYvQXy
	3xLSAM6+FyxM/4Taer6xnU0yTLoSS6LI9civxyWcwAYI5AMpJ4x0LQC/vY3GQWKbNqNL2cUck9URj
	FBPQmGB20mIHbpWUVFW4K6mwYCw5A8BmjY0HcaV/RDRhp1okT0cUJEhoNgix9rWelWVNnb27Utpre
	JB248z49CfC+D73IaLmDOX2741iOnbjFTqQzCj3uC0Z8Hu7rvy9+Y9lZ9755BPSPwmVv69Qm6bHRN
	Wqt8pK40/O9EOqLXlOoyNUR5u78qZmK5Gp5t33xu1oPk93dKN/KGe6RnQO6iJsVzjjkkCUlK/gz/K
	kCHEH7kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpCSO-000000069Tu-3wQj;
	Tue, 26 Mar 2024 19:27:36 +0000
Date: Tue, 26 Mar 2024 12:27:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] debian: fix package configuration after removing
 platform_defs.h.in
Message-ID: <ZgMhqLqESM5wpZ5r@infradead.org>
References: <20240326192448.GI6414@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326192448.GI6414@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

