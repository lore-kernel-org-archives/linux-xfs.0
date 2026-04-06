Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12993491C4
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 05:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775454752; cv=none; b=j60YnB1JGotuwUM5aDNbyEhDH0ZGNlJDuBLocQT6Nix6rkqEmvt+ou7vsIBZ0jA7QAS0ZGLBLhgJFhCmsKgvzf4GcL562e1tvHLiFezPa5zhp9z8thnn+1rvYh0nGRTDtOzVGJSpEAPrs2MJXY1rfNj+l6la13pQXbxfM/wzJkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775454752; c=relaxed/simple;
	bh=91IfTTS0ntSSuR3NM+HFeuAd91Bu6WDkqoz+uR4AVAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDjarnlwLKD10c/pEVa/4aDSuq9nCHAxFApk5T65djjPYegISw7o2ptVF1cqzjFAMbAG3lKTj0XbqeTdI73DkW1XOf796RXxR26nK4N0xTuIVk0ngAU7496G2HyVFZx1grsyjlxYOTyWwts5aqu1E4OF8HzZNfDqVafvwK3Wow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B9F2F68BFE; Mon,  6 Apr 2026 07:52:28 +0200 (CEST)
Date: Mon, 6 Apr 2026 07:52:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix number of GC bvecs
Message-ID: <20260406055228.GE16443@lst.de>
References: <20260401135801.124987-1-hch@lst.de> <ac66VqtCGW89S6XN@ryzen>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac66VqtCGW89S6XN@ryzen>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 02, 2026 at 08:49:58PM +0200, Niklas Cassel wrote:
> Hello Christoph,
> 
> On Wed, Apr 01, 2026 at 03:58:01PM +0200, Christoph Hellwig wrote:
> > GC scratch allocations can wrap around and use the same buffer twice, and
> > the current code fails to account for that.  So far this worked due to
> > rounding in the block layer, but changes to the bio allocator drop the
> 
> Which change in the bio allocator?
> 
> If it is a commit that has landed already, I think it would be nice to
> mention the commit in the usual "commit + 12 character SHA1" format.

We can't reference the other trees as we can't guarantee a stable commit
ID before it hits mainline.
