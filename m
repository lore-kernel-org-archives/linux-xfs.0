Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F13F175A75
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 04:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783572479; cv=none; b=UyKiJUKyDUgtkBdr7/l48cJAXwKQ+WJQWE6sozPQ8jdOtL27YWHDMQhEWqtkHuSTt5wS/UCOrZKyU1nHJW2gA+wBEQDkQPFFeFDqSM5VS5G/e2/XHjBOKfeClOfGL+dJyf585iBb+8ZoIDjvIuhJeN/F+A92MTIZdmX68oJrmMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783572479; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDIZZM2swuFbu+EXQORZLQXHqSCMn/dNd7eL1P8+JXJTvQR0o8ziCKcbtrFI5S8hxun0cqDqYCgaKG7KqRwq6NCBdS2IuheQy4EfmOyVyAP9BOEDhzILDTNrSEafQolckdyY4mXOshlPMICXDhAW+l4V1ekvdMh+kHy29m1hHPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A1A968BFE; Thu,  9 Jul 2026 06:47:54 +0200 (CEST)
Date: Thu, 9 Jul 2026 06:47:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 18/18] xfs: move XFS_LSN_CMP to xfs_log_format.h
Message-ID: <20260709044754.GB15144@lst.de>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs> <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs> <20260708174500.GH9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708174500.GH9392@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

