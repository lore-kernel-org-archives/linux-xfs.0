Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A1D18CC05
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723126152; cv=none; b=vBY04GkgOKVfNNJscvN5Kynemd1SDjDIUFGaHUVYXiavYAHJ+xLirruxhybNMhRjCsZGbI8QMXiXgfYKMFoHusJLwXHB/FApWtAHcmvVZ0UkhzrCMLxzGrvJZcvVMGyimjJxB2K9gP7S+li40hR5UB9U3BTmVCp79m/s7xRiMhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723126152; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4Zz5AfEn+VjF+QetzRHBqf8If1FM+nPC7R0Dgjw0+D+p6wdj+LzrWLyVF8lsT5r7H3HR+E2GgEjrQm220vUNFPazJjbJlIEnXr2eNbJGy8vJaC/Sxadd110RP90GKkSjE7qPGtMxntk4jy7sq2G3Fd0//ftbtbvMFQLWzhxuNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EB4768B05; Thu,  8 Aug 2024 16:09:07 +0200 (CEST)
Date: Thu, 8 Aug 2024 16:09:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] design: document the parent pointer ondisk format
Message-ID: <20240808140907.GC22326@lst.de>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs> <172305794133.969463.2869086475470560475.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172305794133.969463.2869086475470560475.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

