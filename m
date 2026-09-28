Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8919546D569;
	Mon, 28 Sep 2026 08:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582970; cv=none; b=rhXSgvrghUJH40d/O60biJTCJ1gXXoESC0zwG39cnswRnvCyItmOpgHbr0EQhyk6KdyWDHiOqLkXn4FaCVQlpsSDhFjCrMkYhdtwYi6U2bO0UQX7xJ6oajyzQ0fsE02HU2GtM2359Uig6V4pSRTjqJQgUHvLFJJl3U/ryMzYnSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582970; c=relaxed/simple;
	bh=TMdhrYWZYEdo2maEfTAy/xAWluzY5B2xTx+txA56zAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLawFadCZtGvQ1/C96DqgqCwx3qEjqGCuGHYH16DAvin4alfakbyyNryGiWl9o6bHYZLMad22ykmRMkhBBSn9C4xVYI4o55BiPVORoIHBuRLNLrmlK+QTa47EHxBNapgQ24dycMphk0KMm7kavupMXT/TRJqnDTF/UVemIPaXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zcdUQ4Tu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zcdUQ4Tu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vqvsdRpq/UIDNnFLpPC0FuvdO32wrpNCI6g88TTlkAk=; b=zcdUQ4TurG+B6vNWIH+APtAdhi
	5e2abmbRqpDr1zOAjeNB6iV2/95Dp6SulKmrQk05nV7x7BDhqCgq79PjiOSZLKxNoXf2gKv7vOxGz
	MFgd3sX5kAM8SZY3q0HNxpA23n5V2Fbpc6azqNXqe+i+7tCfbU5h9L9Gk3Nu0nwCVfs7nNt3P7E88
	rQBml1XpRYboc/K/8BoruHtceG7SLco9xKU3hBmjoN5BvmsXKZLp3R6thBMRkjYeTb9Ti/alreRX9
	amXxp8S0bvN6LulysGRvWOd57woP+YARYgCvIQgwuim6js4t7hvZJCCV9/T08VxUmGFV4ufmNoH5Z
	PldjZXAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6QR-000000001t6-2IGr;
	Mon, 28 Sep 2026 08:09:27 +0000
Date: Mon, 28 Sep 2026 01:09:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: assign an owner to scrub_stats_fops
Message-ID: <arogt6R9sPkCaaJx@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612767.479634.10381622374817940867.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612767.479634.10381622374817940867.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:17:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that file_operations structs for debugfs files are
> supposed to have an owner set so that the module can't get unloaded if
> someone's sitting on a debugfs file long after unmount/rmmod.  Fix that.

Ooops.  Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
