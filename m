Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC771A28B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719899086; cv=none; b=JnK8756vDReMX91Pp5l5F+EW4OK1NnA+L+F2uTyjoM4UfUA8tJI7F/hoQS9g9LMl79FWwixbNdkcuHoUDaPkuGHBPi/fte0c8kVGX6sgiljcnSjWCdZtMbX3Cd0PqaCdFqo5EUzFPqlEarHqILupXoXoa+6x5WMTol4LAYdUkqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719899086; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjSkWLBu0DZJ/Po0t82O8HJYc8LC+kiKC2Cwho6sWI6HJ5L7CmeUAeP0dk2peT9REPQR4ZTCx27K5Gk3WQQurxgv+dfi1EIDI2XvkoXxK1axLvByF5P8hkdrbLDkBrod9w2OZt0bGFszY4WSKLNs9mAcSp0Mafa9HumDPXdDXko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B131F68B05; Tue,  2 Jul 2024 07:44:41 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:44:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/3] xfs_repair: check free space requirements before
 allowing upgrades
Message-ID: <20240702054441.GA23465@lst.de>
References: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs> <171988120616.2009101.967817870917595096.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988120616.2009101.967817870917595096.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
