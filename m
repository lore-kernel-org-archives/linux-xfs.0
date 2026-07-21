Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150D82D0C94;
	Tue, 21 Jul 2026 04:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784609265; cv=none; b=U170ngTtVFWMd9X3FD3xAUgkqjggKOVKvKjsYWHx3gcdoqdMpI+GDeT9yXFt206+hIHZx5A2J6Qnt+54H6a4nT37bR70Zb0JGsjb46KeUWRlQwrbMtWhuVa+ki2tlnGlQPUn/5YG2X8cP49TysmLgFZJ9oAPBXCuAv8oK1jOt2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784609265; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwY3vI1QzZat/wMVklyAfkZVUmvJONGitj4kUEkkpMaocUIGMaVgJinj9XJ1QZhtoxdY/MHEDuyFOtRp6Vpl1EyQyEFohhBMeOzfM4FXA2JM3dD4ZpgRjJrhYdZynmsSTkAvZrc/GsJGWaQMdNfGEPO2P7iYhrkoVqfuGA8DmJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D9F068C4E; Tue, 21 Jul 2026 06:47:41 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:47:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: fix another iunlink infinite loop bug in
 online fsck
Message-ID: <20260721044741.GC6644@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419658.830862.2707474521987278261.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419658.830862.2707474521987278261.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
