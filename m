Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB6723CE
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042874; cv=none; b=gqY91F8g3Hm6ad7MAFh1xx6Z4JXL04ywG09UT7j3w7A2dWE1IN2hlbuq42A+n3oKF9fEhhezpBxN7cLL3eSk13ncAZbxGo4eSCdmNTdQbtIO953VeDwkBxKtIxdMBp3b2hyPcF6MncFhFZYDQW+8RcCR5mtsCLHYvBlZpyjmlNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042874; c=relaxed/simple;
	bh=sSptE6EzbucJV6iebDjkFoetjlhrLGaSevUIAUXxBrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=batrkvEorlVNMRikh45nE91WHCOGA2NtLcJMUDy3aUI63kaROz3FJ/c+FWXpeSOCRtaQ/vxrkOcF4TwVa6i8J2RwtGX7KEKzK+327ohLe/I8pTRQAYdmHv+JoSdptByuRLWHa82jmypu5rtSLbmb0JthnZS7VGk53KpEYsvZLNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bf9JZums; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bf9JZums"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFB8C4AF0B;
	Wed,  7 Aug 2024 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723042874;
	bh=sSptE6EzbucJV6iebDjkFoetjlhrLGaSevUIAUXxBrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bf9JZumsaJTki3ywGKsi08oW4s4dn119WPO/g/bx56RU28iNkzpoGX+RSTCi4+I6u
	 mY+cM5hAdoDo+AtfkXpysr8uojiIg/4xV+WpvhIasZuyt5Ym8gfxc7TakIpuczP0aR
	 jdqkUfgxIsK/o2PAZedXAzBvd8WdNvmFVwVV+QoeY7WzzBMYcUvvRXibrLu9AN1uVn
	 LRs/y0qE9BtloxUvG7ici3OEI/Sw3HregH5S/2JMmBpb+AtnMHTSa1JHnfoQEIg6+m
	 ASa8ownXu08GXPp0tzZ7D0zszmZFjIiZctq0DG8jGiH3vofZoxTBabucmTi7wR3Asw
	 reqFOdVemsiAw==
Date: Wed, 7 Aug 2024 08:01:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: remove the i_mode check in xfs_release
Message-ID: <20240807150113.GE6051@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-3-hch@lst.de>
 <20240624153459.GF3058325@frogsfrogsfrogs>
 <20240624155011.GA14874@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624155011.GA14874@lst.de>

On Mon, Jun 24, 2024 at 05:50:11PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2024 at 08:34:59AM -0700, Darrick J. Wong wrote:
> > > -	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
> > 
> > How would we encounter !i_mode regular files being released?
> 
> We can't.  If that code ever made any sense than in ancient pre-history
> in IRIX.
> 
> > If an open file's link count is incorrectly low, it can't get freed
> > until after all the open file descriptors have been released, right?
> > Or is there some other vector for this?
> 
> No.
> 
> > I'm wondering if this ought to be:
> > 
> > 	if (XFS_IS_CORRUPT(mp, !VFS_I(ip)->i_mode)) {
> > 		xfs_inode_mark_sick(ip);
> > 		return -EFSCORRUPTED;
> > 	}
> 
> I wouldn't even bother with that.

Oh, right, because xfs_iget checks that for us and bails out before the
vfs can even get its hands on the file.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
