Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB361EA8F
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711741967; cv=none; b=N6JJl6wY+77G2mgBa1JsRANkc+vfLOWqP7yXKzGOA0XwMtF6RZkE8C1yzhUmjLJoMHtu9+hVlcOHwL8aHugzzCf83KfRAQhdIG/n6jVaB6+TSa/9388W0FegzAeK7TYzEemsYp6SsAYRFW7SZtuxuGuscd2G3o3FZh1Un/sgwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711741967; c=relaxed/simple;
	bh=jJIPvwqoDudois/tgRKHPTPQvw6Nol9yOAbYX7DaSFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuE/L3/v7h1/8kf9Zb0GG/s7g5HBzkRF3qK8K3RXN7sgljOO17u54iRIjeBLraJTBeUle66eJa2Cb0I+5mvt9L2tQjG/3zkRIDEXa811L7f28mHBAx9/Q5LCQbSL0/vVddaRU0TsmU3HOYg+1QpEQlq6hKHH2esZ4cRWCittixU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3lndH2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3lndH2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FCBC433F1;
	Fri, 29 Mar 2024 19:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711741966;
	bh=jJIPvwqoDudois/tgRKHPTPQvw6Nol9yOAbYX7DaSFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I3lndH2Hv8n74PMHqd4Dupb79BSkdU5TBywQSJ+6J5IQNM3PXW6EdAI4IdncTUQEs
	 dAsd9yIaGWfWARfHOifVw08VQh86+HLz+6RdNJNBmcWSlDETSdB4bEclsB7ga/o5u9
	 zOrwdMGO3yVTviWd1N0eMhbXKoa/Cwx/bUh0ZU+eHf1vkOIjVm7TZgWcUiaI4yji+q
	 MBYpPzA5jNZL1ktyk3iXAAzYCuApZbefJe7Vx3bXqUnVwZQsIr2hz4kXCBrPh+qMEY
	 qb4bR2FkeXPAn00GJsanCVsJgqUHIlIubpBcmpn9oG2wOmlGZU1Wsby2twNWjsSVmr
	 YGxV5PNLlL0iA==
Date: Fri, 29 Mar 2024 12:52:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: ask the dentry cache if it knows the parent of
 a directory
Message-ID: <20240329195246.GN6390@frogsfrogsfrogs>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
 <171150383612.3217994.12957852450843135792.stgit@frogsfrogsfrogs>
 <ZgQADzOH_0UsGQcB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgQADzOH_0UsGQcB@infradead.org>

On Wed, Mar 27, 2024 at 04:16:31AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 07:04:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It's possible that the dentry cache can tell us the parent of a
> > directory.  Therefore, when repairing directory dot dot entries, query
> > the dcache as a last resort before scanning the entire filesystem.
> 
> The code looks fine, but how high is the chance that we actually have
> a valid dcache entry for a file in a corrupted directory?

Decent.  Say you have a 1000-block directory foo, and block 980 gets
corrupted.  Let's further suppose that block 0 has an entry for ".." and
"bar".  If someone accesses /mnt/foo/bar, won't that cause the dcache
to create a dentry from /mnt to /mnt/foo whose d_parent points back to
/mnt?  If you then want to rebuild the directory, we can obtain the
parent from the dcache without needing to wander into parent pointers or
scan the filesystem to find /mnt's connection to foo.

--D
