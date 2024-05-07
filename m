Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4A82EB08
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 06:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715063792; cv=none; b=TOPJzdUq5CigNTdp075GHct5QogcDURdJk9ldFQuB1JeyKFnik1VvaLtRfHNoGEqqfT2gIV3UVsvS92t54CF26Km9dcwbnxnv/swZARlTdBEzPVALUbpk/Yf/ySoLjGJMdZ7HTDj4t3ReMXrOPyTeq/R5rCAWr9VeR9DUImbEeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715063792; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XW2qUk9lMKsqDbziqErAiLl8qI8rWrBr5WxbeoM3pVVzbq3ihsDDezyAiKcMjTUsUPXCFxHAVMRhI1fxu7OdtkuiKIt7iPtud0FnAVa146GODT8kG2TsWGN8cPl01SBdobKm0cG3gNX929Ss4H1JySz4ZGkHDT62sQ0UmklBOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5A7EC227A87; Tue,  7 May 2024 08:36:27 +0200 (CEST)
Date: Tue, 7 May 2024 08:36:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Message-ID: <20240507063627.GA2669@lst.de>
References: <20240503140337.3426159-1-john.g.garry@oracle.com> <20240503140337.3426159-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503140337.3426159-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

