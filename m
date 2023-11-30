Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5096167C
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AvVRd8JO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE324C433C7;
	Thu, 30 Nov 2023 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701382215;
	bh=7F3RiXBn4PKVMj7NOS90V7Z/xmUjSIQi8cZ0nmd5Z0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AvVRd8JOV3An+YmfBLddfBKzQ2prLESY59tdMm6wrGTUSz7eUiG/gVATUWr9CIYum
	 NrhGMLXLMkXMbnKSmGGXWulUvi9HY0Yn4v7+S8nvb65v+dz4i0wCxSs7J+1xeg/Rtw
	 oIuuMIqOmg1WosetB+TTYKfRG2bEYKpKl3mZFRbKBYxHO7sG1Z2O5E6wcv5jOmATo9
	 DZNeDkpmPnG+JBfXUnQMsGm4k/kpzTVM/zW22fak6tXY+iMEgEtQIr/o+AjTzwWCGZ
	 ZVDQEqwRqpbRCeSGdYonGOMnREMbJl+Us5IdS8kXDf/gm1/R7gsPyZKUPNPrY7GImg
	 tPmzk4h9TiKlA==
Date: Thu, 30 Nov 2023 14:10:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <20231130221015.GR361584@frogsfrogsfrogs>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
 <ZWgetfZA0JLz94Ld@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWgetfZA0JLz94Ld@infradead.org>

On Wed, Nov 29, 2023 at 09:33:41PM -0800, Christoph Hellwig wrote:
> > @@ -328,7 +328,6 @@ xchk_quota(
> >  		if (error)
> >  			break;
> >  	}
> > -	xchk_ilock(sc, XFS_ILOCK_EXCL);
> >  	if (error == -ECANCELED)
> >  		error = 0;
> >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
> 
> What is the replacement for this lock?  The call in xrep_quota_item?

The replacement is the conditional re-lock at the start of xrep_quota.
I could have left this alone, though for the scrub-only case it reduces
lock cycling by one.

> I'm a little confused on how locking works - about all flags in
> sc->ilock_flags are released, and here we used just lock the
> exclusive ilock directly without tracking it.

Fixing quota files is a bit of a locking mess because dqget needs to
take the ILOCK to read the data fork if the dquot isn't already in
memory.  As a result, the scrub functions have to take the lock to
inspect the data fork for mapping problems only to drop it before
iterating the incore dquots.

For each dquot, we then have to take the ILOCK *again* to check that its
q_fileoffset and q_blkno fields actually match the bmap.

Similarly, repair has to retake the lock to fix any problems that were
found with the mapping before dropping once again to walk the incore
dquots.  Then we cycle ILOCK for every dquot to fix the mapping.

Not sure what you meant about "we used just lock the exclusive lock
directly without tracking it" -- both files call xchk_{ilock,iunlock}.
The telemetry data I've collected shows that quota file checking is
sorta slow, so perhaps it would be justified to create a special
no-alloc dqget function where the caller is allowed to pre-acquire the
ILOCK.

--D
