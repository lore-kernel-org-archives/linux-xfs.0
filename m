Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C3D32F747
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794541; cv=none; b=gE0h4slJs4bFuAuwjVaUu43sA5j4LsCqqiOA0fM5a4F8LZwhzFqf9Kwqwnyzxj412qZiMt7hhDEOb8SNHSv0YX8+yXJJ5kKLjYTAmmAFqxixvaozvehqdlJXYOxYadLgOXSFeXKCMwKqNLULq383ztydEbihjxBLbGDbGMu+pAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794541; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvfmPa7UQUtODfss9wB79ujAExHpOE2XbKciPqwa8kS7gAm9DDs5KIJ+FFHn2IlkYdlvp0gVGMp7w9MWOvfSL5dkLXMoM5stG+uSrk4ZXRUTDxUz6cn8aMnmpjJy+drdhzQJe56cgIOJes9MKsbluPTJNjFM6Pjl2Hb6kXDJSWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE1AD68AA6; Tue,  2 Sep 2025 08:28:56 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:28:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: use deferred reaping for data device cow
 extents
Message-ID: <20250902062856.GH12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126626.761138.4174062470780044970.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126626.761138.4174062470780044970.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
