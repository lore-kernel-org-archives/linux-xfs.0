Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF76344020
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 22:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748651; cv=none; b=HkroDyNCU4nUPQkyMbMubVoCQ8T2G3H9tT7IPFgFSB4Pz12eOmkrqVNQtVUzIbYVwknqGPSl6tvMypQP65VDHn0yTEeuNio4fKNBTbMxGVHrDw3GtNxHuDdx/q9Azo/p8fah+CGrvEfskVe2gVWCfNsBMcP2BNngjjOtE6/L3bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748651; c=relaxed/simple;
	bh=W3KpP9kyMjxdcWPERaiEd5GvxN58bvbByLl5YntbjLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7cX31E+rRjzfn4lS6pDRHGHllIAkGVVfX+hWysHfzKzk98aNaY0KiAWtoqzHZbVxX5M1KCXwPtuSvAAslDam+QGhnF+5IN6kWEWw9q+OMvXmsiCFAc+Qg+8jWh0L0BEeri91RjwyVnuj5JrSS5ymozx704ikfgZOdZnhckEa54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y62L/BHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y62L/BHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53162C116C6;
	Thu,  5 Mar 2026 22:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772748651;
	bh=W3KpP9kyMjxdcWPERaiEd5GvxN58bvbByLl5YntbjLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y62L/BHi6NweNymyEfZxLtOJNOFiioUdAwFJYeerczG6PsgcuIp9Lt8HhyFqWypJV
	 ms0ERZD89TyYTNKmQwQOP/g5iaRndJX1NZD+xBqrxMKvE6O/1QB5xI+IgZ9t5ffBOq
	 DfVc+YK1Ovgs5pRW+y6aAzjMYpF8TG/xc68kRX1eziKOZ3eCW2TLGNfWfLLdj3udeH
	 ScLZgyaDb2gWj5UxkAE9yyhGreRbVX9vjuNrL6l7lJCNmOrRsbUer9FjPW1yHYeJ3W
	 ItTfifBhWnssh40E0WjaqC9yYE+u7bL0Exbm5ET3xnRm12++X+Tm1eT8oFCGySLUqf
	 xfFal1VJf60CA==
Date: Thu, 5 Mar 2026 14:10:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/26] debian: enable xfs_healer on the root filesystem
 by default
Message-ID: <20260305221050.GH57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
 <aacFKgnRvvhSVsH_@infradead.org>
 <20260303171400.GP57948@frogsfrogsfrogs>
 <aagtR_YU0gOwAZCs@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagtR_YU0gOwAZCs@infradead.org>

On Wed, Mar 04, 2026 at 05:01:59AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 09:14:00AM -0800, Darrick J. Wong wrote:
> > A lot depends on the distro -- RHEL and SUSE require the sysadmin to
> > activate services.  Debian turns on any service shipping in a package by
> > default, which is sort of funny since they don't enable online fsck in
> > their kernel at all, so all the healer services fail the --supported
> > checks and deactivate immediately.
> 
> So this patch doesn't make much sense right now?
> 
> Either way it really should have these details in the commit log.

<shrug> I'll amend the commit message:

    Note that this won't do much right now because Debian doesn't enable
    online fsck in their kernels, so the ExecCondition will return false
    and the service won't actually activate.

--D
