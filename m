Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1BB2AD17
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901700; cv=none; b=KcLJ9RpZQuGUrLclf5PFt/QxJI8gvGe/pVmfZ24r76ndHoXR2iKAG012xogNeKR2OF76U3r+C7QBuNkhiLxOySNXmW7TwSiQhZGfofxh7iKEdKWerCqyGYlWz+ZFWoaH1FzHgglyad1aHqFbnnZ+mIVFK6wLddqqkKyXHHw9gjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901700; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDapE/fknvhhMXrlECRlT1Hc82FTISnUJaRIbhd0jwWz4XnOsE+ZfMyWb9xtGq5TqOIYif0ctQMTlq/Qt94UHKWs4ggFj8IxZMpNyQSVdWzCNHdvzgrPDJHNvA50UWnio8adLlRFd7XcKMenArXxtYjZfX7NWY6DZjYsy9W9S+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6850E68B05; Tue,  2 Jul 2024 08:28:16 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:28:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 12/24] xfs_scrub: use parent pointers to report lost
 file data
Message-ID: <20240702062816.GL24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121248.2009260.17262926858268275665.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121248.2009260.17262926858268275665.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
