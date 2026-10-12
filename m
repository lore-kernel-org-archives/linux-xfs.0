Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378D249B5A3
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819408; cv=none; b=kPT0WCp8nyt+zZd/oZHUjnM4eUWh+iVbhvY/Zs6befHCG4IfxTWGOFiAvOas9LqN1JxVLeld0Dxc0GQgRM9akkkcbxrxxO12lKbPC5W2CCz/eYIO7tCmAgTssZOFVz+aQZStmGSskFar5pnso3xUJOYHEY+InAEg9cLbFs6+RWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819408; c=relaxed/simple;
	bh=tIwL/1R8t4b344iZEgmSPxKKXxQDpl84hKM94UMn4sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROHAKpqN1Plz+ArPRJTrBgly7nepDcb1Gow7gfUTADjhKKWZ6KzhC0C5Qb8H1RmhalF7KAxFNVCnm6B9/LphkazMyrjb7BeOFGKdnr76VmWqGreqbwR4naEJMZR/osvBIG7vtbZxwa0uwab7C0HjstKWu+jPi3xA0wSdxezclYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4MuILWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4MuILWD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 958B61F0089B;
	Mon, 12 Oct 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791819406;
	bh=VwF5EkO7tZTQoHmXaWsKzIrHQdqzIb0Gp4EJ7mUnxcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z4MuILWDWLd3thGBBVWvRXSwuPMc36fu9IDCJw4uiwknuWDIIiFsDdpc570numoIu
	 nY9zLg6HgxlakLFg96xNdvsXV+oQ/JBQRe9sW7aR4JOrsV+qdmAfTfaJtqL3WzSd6y
	 pjltn1ospqYTEG1kW5tCCBX2icaDcofLOJ2ru+ALqHc3ijdnA79e7R2PpBGwPr9K8b
	 O6z799bJyU1fMpK8TdRDxKRZNvGX/CaldeVUhzdVKxdhAdTMxAOlAaQsx8qxC1YSMP
	 PTMLHNqHedvOOT9l9C3/eqwlc/fKAgVIQLAhE161IwZkLQq5yZEXSjrHzKFTnzu3z9
	 CpSZjnb5FHshg==
Date: Mon, 12 Oct 2026 08:36:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yun.zhou@windriver.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/26] xfs: don't hold buffer locks across sync
 transaction commit in xfs_sync_sb_buf
Message-ID: <20261012153646.GZ2705364@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
 <179158947530.3719791.2785151427381835148.stgit@frogsfrogsfrogs>
 <aszfHy7rfOSYN6Q-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszfHy7rfOSYN6Q-@infradead.org>

On Mon, Oct 12, 2026 at 06:22:39AM -0700, Christoph Hellwig wrote:
> > +	/* Always NULL, do not call xfs_sync_sb_buf! */
> 
> ... in userspace!
> 
> ?

Yes.  I'll fix that.

> > +	struct xfs_buf		*m_sb_bp, *m_rtsb_bp;
> 
> Please use separate lines for struct members, just as in the kernel
> version.

Done.

--D
