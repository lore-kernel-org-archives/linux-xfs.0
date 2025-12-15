Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A3F345CBF
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808993; cv=none; b=t++xODVjEiUd4lUGBGltUtQnrDsu+tYvsJvfnkADcOInocTtoT5tcys+C0SVSY1oTZNp9S5FlNEOThj85VsiahlE5dHdi0ko7m1niSuB2byxCujmi8D7yy6ggCSA3M7wfEJRyT5u5eWMQlMF7t4HCwmU4co/3p4aEJHW18Sg8jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808993; c=relaxed/simple;
	bh=b7G/vWA3uaZblMeS6TDUkIwjMDCYyFObWisEy3vjINA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULFf+ywmG+DgoqO1aAT4IzIzikdVOLROovCGfz5EltftrSrgS7504EWTNZQkIpK/NmhRJle4SPt/nTiCEoX9MLyFOCwpYN0m9/eP2hszPRlmiyeYN39RQUYMLQptJwQzhyYJxoQL4/bgWpnoqnj/gCv2aVjq6dshu1crrFrOKUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GaiIf6pY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GaiIf6pY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cCz879FCRdsNCiGbs8i4htwfMnPPM45h1G0s5DmTdNc=; b=GaiIf6pYxvKvHGqWPvcOjOmW9F
	GRHBvW182IcuocXEn3YZEe4Sev8JYQqSWU4i0f3mETdmKpquLE5SJZbaDRM0aC/hPj7YxFG32zFuP
	KS32e1p8vs812HCHkS17IT6T2eOdtQO4IXSOputXSz+vAqlmuXqqiYUTwmcjhnkQhKjEd8/7F6Pic
	Bjlu5/ROSSlRfvT0zdFPmHvouHilw3QajU3YMjw5pA5fGxAV4kVvySmYHWYSGpK4RDwl3EdO9JBLI
	825SYvc8qabeCrD4j9k3xdrjBzfxTD1AXNamsVk6BsINzts+i+gcjH0imRvmg6ktnCl13kTAUEX3h
	2s+IcPGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV9a8-00000003naO-3Q9x;
	Mon, 15 Dec 2025 14:29:48 +0000
Date: Mon, 15 Dec 2025 06:29:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: yebin <yebin@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org,
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
	dchinner@redhat.com, yebin10@huawei.com
Subject: Re: [PATCH 0/2] Fix two issues about swapext
Message-ID: <aUAbXIkQ_LfYuPJc@infradead.org>
References: <20251213035951.2237214-1-yebin@huaweicloud.com>
 <aT-eo76enT15FKkr@infradead.org>
 <693FB68F.50400@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693FB68F.50400@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 15, 2025 at 03:19:43PM +0800, yebin wrote:
> First, we encountered the issue described in
> https://access.redhat.com/solutions/6095011 in our production

That's behind a paywall unfortunately.

> > Any chance you could add a reproducer to xfstests?
> > 
> Yes, this issue is quite reproducible. It occurs inevitably when following
> certain steps. This problem has existed for a long time. I think the reason
> it's not easily detected is that the XFS_IOC_SWAPEXT IOCTL command is
> generally used during defragmentation. Therefore, it is almost never
> included in typical log replay scenarios.

Can you send out an xfstests for this?  Or at least a shell script
fragment?

