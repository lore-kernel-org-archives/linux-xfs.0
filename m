Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47045C5F3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902942; cv=none; b=IP/gm4U5ND+OCy12QaDPthoJ+pbJ+CMbtS9Cq962NUWGYXznkb1lLfZJpWxqUoiW6OXS62DwGsJvW/lMZveQ+XIxmRFicNQi8wr8J1OYDxhiytiMyWMnzYtpgBGvAip/xsBYtnHttKancC/znXbPYpl0RS1O0WPyiyc7i6vb0Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902942; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moZ3dNy6kIAd0liWwtZjS3rMkkyJSmEUPuZ3YYpSldDXBIbBOnqmTx0WfSRLQNnzJkWcigofEq6LUK6NpiTfHhqau5POV5LffMicivxSzQogwEUXwtbkpbpi3JrqavWCQj2kidHerRDQ9+9VOU3l+m+pDi3YJtajuP0eKCtmbJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 120B168B05; Tue,  2 Jul 2024 08:48:59 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:48:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/5] xfs_scrub: fix erroring out of check_inode_names
Message-ID: <20240702064858.GC25817@lst.de>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs> <171988122742.2012320.2358555456931426968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122742.2012320.2358555456931426968.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
