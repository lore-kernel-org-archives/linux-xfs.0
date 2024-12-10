Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917A6230D2B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810194; cv=none; b=MiLJyldbdBk5mWfDVkX/pbX+FvauHzwAJB7i8xSvyuHaR676bVUhjMNuiJnzfnfLNzz1PTMEw4Tt9o/FDypJ1X8gQJp5z1occOkO5geZOVXhvWNBqBzAKk9W9uuYO4OZhZw8CbbBeLx4fiCwfbnOAAzQ8/bQhetifRoso6MEHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810194; c=relaxed/simple;
	bh=Fddo71IXRq3Fa6TTC1tXg7qTRFRNxYtJOrecpdE+8/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qROOh2c4RpbfFkUbnZogY8mzC2xfVRVKwzU4gSLGXOVr8mnSApt4hgPdOjmesBQvte6qR8k/lBqc1T8teStqid0OATBDOz4d4S1Kt8t6OnnIbOOtLp2iAhVRX+hk3Hh7XoLGrtuJqFzqVZhIBVCWeLylnPqtys+aTyn2fZ5MGUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yVhBhVJ8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yVhBhVJ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j7rDuMg5s1G8kbK4KhjxS+iHp4uJkr861zlSiA9Ujy8=; b=yVhBhVJ8w7ZtyCYazofxt9vg4O
	yoagJE27PN0FBk+KedCqYz+Dzz4nMN+6YYR/f9/bO/s1+aEL5+9nTVR9YqKItX3oc73YSemHVoV7e
	y9IvSGl43Mru3La0AEujzt27z/Xan+TP8Ge0sUB9d+PwX9gdSyY1/nt/crma+6LzqW5UeKpPKS4Sn
	Rxz4DXkkY01Wa26TVEVtpJlWwhkoijyHPKqlRoC1RlztFY2E1ttVrAaYZMLzhingfxvkhU6zJc+7L
	3xErhtwQgWr174cVXrwSHsrjY46yoM5j683jEELlEZg47XG0Ek788JdcaM+l4AWg5aba/pFoUoUYH
	BIrSZLiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtEX-0000000AKYu-0zed;
	Tue, 10 Dec 2024 05:56:33 +0000
Date: Mon, 9 Dec 2024 21:56:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/50] xfs_io: add a command to display realtime group
 information
Message-ID: <Z1fYEVUtdpoxDfA9@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752556.126362.1974525931833042170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752556.126362.1974525931833042170.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  Get and/or set count of reserved filesystem blocks using the
> 
> 
---end quoted text---
