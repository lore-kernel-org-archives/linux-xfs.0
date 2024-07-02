Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3D62A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897897; cv=none; b=rsrRDzYX/s/urfmYwXoP+kFs5P1UHetoiTqCaWgXfX8+OnqNP2JY40px6zdy1J8fBLcf//ZE+4+zKqDvI1uVqbTejdak01A3rZKr0B28MrUGtv11p5dUvWnVNqfIOUukNxdLlQrVTF9YWDeLIrbNY5p31c3lTmUkCZSaXHSf34g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897897; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ul9r6ipbQf4Aj9b0G0Jfyudb9+sTQ8QwQq8GLZSjLLypQ2P+oR5qs5R2iEgopRMED9uxzM1/rmjxgWyHoIURJ+6mR7kb6CXsY8qDCTkF2SsfFa3S1zOX8eUI2ALw88XckQnEGhG6ysmYfaidfkPBjiHwwUlXM3R5PX/+NwqdWzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 22F2968B05; Tue,  2 Jul 2024 07:24:53 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:24:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/13] xfs_scrub: rename struct unicrash.normalizer
Message-ID: <20240702052452.GN22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117778.2007123.8328418916342708343.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117778.2007123.8328418916342708343.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

