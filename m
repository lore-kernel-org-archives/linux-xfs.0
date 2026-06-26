Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D735F5F8
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 04:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449986; cv=none; b=RAm5iF+eeGKOmGEQjAgVzv6JV9FjcCZchB3y2c24//mA2njVzPsbJo94sfTnepnsE1KdUhjKK7DfbcwZj84CyL+NNnvexBtk6YI44AA+7y3g0fHGFsQIQU/+ZLt+z2i59VxOI8YQOzSO6wuZA360j+MC2pL8D0K4MqP4ADJfrdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449986; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEb2Eky1+/ALe9WI/e1vWhoPM0dSis2RYbwJxb5trxgzWfQ2+3mX0pw9fNQQFt0QddxE5bRbuC9PICVUikpzmlq6w3Ch/qRAmI7y7w37yeoa10Z7LraK4dzy8YDLQ5ZZH9uGqonzx4tchdNKl+M6Z3StVe5bsUNQJYhyvMTf0oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B97EB68B05; Fri, 26 Jun 2026 06:59:42 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:59:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/8] xfs_scrub: actually handle NEEDSCHECK scrub items
 in phase 4
Message-ID: <20260626045942.GC8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801359.1981574.13932376274441544851.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801359.1981574.13932376274441544851.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

