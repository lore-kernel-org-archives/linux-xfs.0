Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D78C11CB8
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 04:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714538154; cv=none; b=hZTR4BnepWyVMiVAP5tHc4w/N+0sz+ZGNE1aTATH6gSTYzaqaWzBQ4RkNmBsrpqX+l8KLnA3X8p3IqIDmFyB9+ks6/suO8sTXvi2WlGwhvRi8gkRsqfApWJFMQEc9FgfLemt7KdMwUC+U9xzXUz0BsaSE1ltuAud2C09ntOIefQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714538154; c=relaxed/simple;
	bh=VizYdrGqCOh6wUC+/EL+OfJRrI52SYmu+tYZ3v5r5AI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahVQHoj7eIWQePElRFrcScAfz0yLOfIyevVZW9wkUkP3mRIz6Yf5x4QYS5KNDqDUgTyycp5cAYe99zhs1Il90vOfGGMKfrFgecOqv9Pf++9KAzbmFKBbUnZA0qgORV3f6987RzUxZzZKBOgcWAF1Occj1hc8zZTRXObpLV3zIeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4532D67373; Wed,  1 May 2024 06:35:47 +0200 (CEST)
Date: Wed, 1 May 2024 06:35:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: simplify iext overflow checking and upgrade
Message-ID: <20240501043546.GA31252@lst.de>
References: <20240430125602.1776108-1-hch@lst.de> <20240430125602.1776108-4-hch@lst.de> <ZjFl9uwKzRUrigTI@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjFl9uwKzRUrigTI@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 01, 2024 at 07:43:18AM +1000, Dave Chinner wrote:
> xfs_iext_count_extend() seems like a much better name - it tells the
> reader what the code is actually doing (i.e. we may have to extend
> the iext count before performing this operation) and it makes it
> obvious when it is done out of place....

Sure, I can change the name.

Btw, it would be nice to trim your reply a bit more, I had to scroll
down a few pages of quotes text yo get here.

