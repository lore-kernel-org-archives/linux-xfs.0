Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F079DC7;
	Wed,  7 Aug 2024 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047237; cv=none; b=NLfs8oaZh5HV6yL4/JuCC4e50c2I+LeQCkZXb6zrK+Thru7hVceooYy++BTeZ8OLRsUvELqftAZLkM0s7qNnm+qTu5AXdZuHcIYSRxZpEM76OMNKgYuD3+AIYGmQA9yeVS5tDPwTsqeJT/QxxuPmcaYEEH6vySdYmRYH6jfVZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047237; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6sM9MkcWi7TWkRxldjwceg/bl63rBZTBd/JW6o6vVBt+EACocuoodduwqULUELD1Gqp4RMPkKwxxqYoLLE9o3CB1YvwYw1LMghPqdmCee66mBjG1gCtNarGArGuQm3lloLpIL+M3KtZgxjpnN3GL036sYElO7r8JAmEpGga1F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B261868BFE; Wed,  7 Aug 2024 18:13:53 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:13:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, hch@lst.de,
	dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: functional testing for filesystem properties
Message-ID: <20240807161353.GI9745@lst.de>
References: <172296826757.3196011.5410659263017548917.stgit@frogsfrogsfrogs> <172296826772.3196011.9671904374599949040.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296826772.3196011.9671904374599949040.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

