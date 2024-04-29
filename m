Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5D82AE93
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411022; cv=none; b=ua4lt58eeWz12XQYHaCr3Jxj0L5IR5PHSvC0NA4JuOM+dcD0xNWurX2CN4D4Ab8aSswyrRXW1S5spTu/KzMt9ihunpzm5ND3nRF8LO/0qJd/919GHTD1ilXeViiFZ1Oq2SlVkXAnV2iN2wpU/N3HbPHPKS2JF/RmMB/eynGWTZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411022; c=relaxed/simple;
	bh=lyySsFnAJ5cexMKAXHIY9yT/XG3G6BNfmGvprQfQ+EA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYQ4nds48xwZLcf59yA6nmSioU7Z2Hj84f1VgqZJqPIYDFQ4cqjIdljrGho5qp3ClhJ08qMAZUbj7JMo+haZNI6o5edjkdh0jOHxRjk8B1HSwzUYOD8l91//7/0q/BhQo0eFbO65EwZSAB7o13A5bTYsUT8HYrqiW45YFX8CWAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD660227A87; Mon, 29 Apr 2024 19:16:57 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:16:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: upgrade the extent counters in
 xfs_reflink_end_cow_extent later
Message-ID: <20240429171656.GF31337@lst.de>
References: <20240429044917.1504566-1-hch@lst.de> <20240429044917.1504566-2-hch@lst.de> <20240429152652.GV360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429152652.GV360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:26:52AM -0700, Darrick J. Wong wrote:
> I think this is actually a bug fix.  If an xfs_iext_count_upgrade
> dirties the transaction and then xfs_iext_lookup_extent cancels the
> transaction due to the overlapping AIO race, the _trans_cancel shuts
> down the fs, right?

True.  Pretty unlikely to hit, but still a bug.

