Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4550284037;
	Wed,  7 Aug 2024 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047216; cv=none; b=k30R30KUK2ZIc6p8ZYZpEpPMa0AW2YO/HfmRxrsc4OB5UqGpJA7P7t4RGbtb2v06yoanj9b992ASaxyar39egVJwX7gOAZ3l5hQSdxWcqlfZ/Sz8xlX+C5mRr/pMF/madQW5+2LkYDUh+vSh47oge7jwZgq9+nUEN3ekc2YFrK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047216; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRE+sbsjZJzfXdGO/nsKeOMlMWYDKw9EbbnqDRVUk16nKKCEKdnNrvSbuRdiz2XNbix2UhTnoFc9o4N0jxJ/ZC4fcn//JRhlfFGSw3SMSLoPlcoAis4I+3NaWT1sLrhhk2DsbRDBARdjzQN4quIoQbCATxHK3h27PXYQ5irxsng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AFB468BFE; Wed,  7 Aug 2024 18:13:32 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:13:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240807161332.GH9745@lst.de>
References: <172296825957.3193535.4840133667179783866.stgit@frogsfrogsfrogs> <172296825972.3193535.18204339258677970549.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825972.3193535.18204339258677970549.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
