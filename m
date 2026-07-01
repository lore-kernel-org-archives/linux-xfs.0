Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8BB410D26
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 10:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902054; cv=none; b=T5rUoukVKCJOkaEbOBRn36Ek3f0sgIJGcf1vcE1URQojRQy6DI3eDDMlTYIfTSH9f4+pzjpVYWknrRNXHiiT6FdhbStOj41oTPSRiuLH1d1KREznhJgbsIji9AJRt1ulQhBfK54x5+4HaF2+dUkUnoAXfmiSb5nj+zfztFqp3h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902054; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngTEqZm9jG4Blpe7H0LLYplXqhZ42eJN2HitMxxixfmMMjT6RtPgQ32JvzkUz8cAVvnChMbcAdldb1z9Lw3wzXzPP9GM8nwiCvAYxCaeAWzVKx3mRHg/IgwRI5QQsAZ4tVKFZPQi0XD5rxwRaa2eWElZPaaHFEnFLGMyQX0cTnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 176F468BFE; Wed,  1 Jul 2026 12:34:09 +0200 (CEST)
Date: Wed, 1 Jul 2026 12:34:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
Message-ID: <20260701103408.GC12719@lst.de>
References: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs> <178288493239.702844.13839738743400440296.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178288493239.702844.13839738743400440296.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
