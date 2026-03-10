Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C393A5454
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147281; cv=none; b=FUknunpOjc0E9My8K6vk8zDnokXIIcq0hCXtZIuLrCh3vCHGbpDA7yukE02VZI9Me14OSs8MgzePlA1SuHBHTJVTu370qcqvalEjGHa+cJE6SvuTZoIcCo9pr16M8HwGafVirqVWepgliEUz2npGB91qSrtAwkReWuF5o+XCnzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147281; c=relaxed/simple;
	bh=6l0LTpbJ3rj/hh22RU2/mu27dfdVmQu7T7unWYggf+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YN5yxw5UsdWyWUlAIbgt8mMHj4o9LCrU4DqKRJOmVvxJEBRfajybYjr2vMqqio44pJY3sqh3HV1Kig+pB10JJfkHwsx/flPWCTKyy4VlTUB266rQrOBZnWvUxMP/8H7bZbQURNTHhzJJ4woQP6zg6EnK7zSQkMl8B7zFBKi60hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3819D68D05; Tue, 10 Mar 2026 13:54:38 +0100 (CET)
Date: Tue, 10 Mar 2026 13:54:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dlemoal@kernel.org
Subject: Re: [PATCH 4/4] xfs: opencode xfs_zone_record_blocks
Message-ID: <20260310125437.GD3323@lst.de>
References: <20260310115555.114197-1-cem@kernel.org> <20260310115555.114197-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310115555.114197-5-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 12:55:07PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> We only have a single caller, no need to keep it in its own function.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

