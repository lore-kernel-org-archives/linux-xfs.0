Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221EF222590
	for <linux-xfs@vger.kernel.org>; Fri, 23 May 2025 05:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747976835; cv=none; b=W+UUTWly8jUGXd9dOUEBgs10TQK1icS2im/IrZKtnDON8VLhQo0ysAkWkOl3Ve69fzqOHdwn5bPgnGCiJWscVg8ivVQUJKuth9cszinapfGEcLOQOgMwUWWL1TyyNaB+w7pp4WfeuDYWtwtgg1Rp9c18hb0L/H9I883Sn7yyveg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747976835; c=relaxed/simple;
	bh=Zaf3mLs+jCTgOG/5mE/ZBVde/dSFTnO/Sk7xD+j3pEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnCEfvOQpghV7yoXXdAJwktU5ydzl1cx+2KjI2UUtv8wQz5+E4POCb4xOExgAf/w/NnTjxkKfOK/POiXl5Ti9o26KoWPRIGFbuyaWJYknwSecbx2PCVYHMUmqmblWJReHYjsnqYgLsR2xVaYAnraAlQpNIkGgKwL26KKW1IjvCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TVuyQPM6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TVuyQPM6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IVQjmRx4aUwpvFpoJZ60oR1bPnU3UHt5HCSFeL7K1kg=; b=TVuyQPM6vjU6v5vnm2tJa9W8r5
	RbE9Hs9mhq12HN1ANo4nEw1OAALWW2X+PVGBAe6oK4MVkpgw9Sk348apwo3e/XvpQYc/FiKxXrW3q
	CwszC97wIXyNPRIgGmTt8T6Q4a6kIpfk7FS3y6PIKvxMd9Q3PWuRPDyJmBjh7jE/5P8C5zOhaQIjj
	xLxJzWHiKj0qMCiXncFiSPUVFQbPJxH4BejBWkuyKop1ua+EHH/kYsL6MVOIAE/WUwbpyTtxN4ouM
	nEgGZ3e8FgE/xLh/KxLrsFp0gwB8MO+sVsT0Gz0d0jY5+X/iNWDLCFYV38uKVYoemykCMCHK4OarH
	5vUfyVBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKcj-00000002yFD-1wdY;
	Fri, 23 May 2025 05:07:13 +0000
Date: Thu, 22 May 2025 22:07:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] xfs: fix unmount hang with unflushable inodes
 stuck in the AIL
Message-ID: <aDACgQ8j42TFeRA-@infradead.org>
References: <20250515025628.3425734-1-david@fromorbit.com>
 <20250515025628.3425734-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515025628.3425734-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

First a note:  I gave up on my previous rushed attempt to review this
because the patch was just too big for my limited mental capacity.

Today I instead split out the relatively trivial prep parts to focus
on the changes.  I've pushed my split to:

    git://git.infradead.org/users/hch/xfsprogs.git shutdown-deadlock-split

it would be great to pick that up or do something similar for the next
round.  After your patch I've also added two cosmetic patches.

With that the change does look good to me, and the bli reference
count scheme looks almost sane to me.  Although it makes me wonder
if we should just keep a BLI reference for any BLI in the AIL to
further simplify it eventually?
