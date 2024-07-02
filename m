Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C1BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902883; cv=none; b=iqF4lWTUNQdCG3VLvcxioke6b6UV35dXu8Q/SDiJ/b2vqZpy6D+5nZvrznoXdoum4bzyK5R9aSdVbHvKxp5lKdjGCWjjFbl+7T637l/wUdY+d0kW2wyGA90hBnzIyLOs4Dun3BS3OTCU4z5rcxjOCEpdBtMMcZpT4o2dGw4uhU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902883; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUL2JdTLQloErzCAgcpKKEGXDn8/ECosPCuMjBzY7V4PFb2kKln14ucqI0lSNUPTCYFEOLPJ8+835y3tEf1swuQ0MJD40lfTkdEcd22rSOwv3M6sGizjptw73qdgu1ApuUGR+zQPDgt2aQg98lOQkWYc0Uz4aHBIA07QQ5DcZAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1451368B05; Tue,  2 Jul 2024 08:47:59 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:47:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 12/12] xfs_repair: wipe ondisk parent pointers when
 there are none
Message-ID: <20240702064758.GG25370@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122352.2010218.17899349898608092894.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122352.2010218.17899349898608092894.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
