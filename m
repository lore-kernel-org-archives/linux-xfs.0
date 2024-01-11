Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCEA17C1
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6QB0OGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78541C433F1;
	Thu, 11 Jan 2024 01:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704937325;
	bh=hS6kws158fUDrvPNkxqv4s+Lw2w2/Wxw6YCrLLqxL4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6QB0OGwqO6rp/m67gH+5lugnfQ6unFBwwy84ZiD8RGE/ImhNW1hEwrb6pDTRZGbR
	 PupKoxTz1EKxWg5RZRiokR6wqEx0sA7VaJYxMZ2cNJKR527ffr3sl6SYXutH/5tg9m
	 sWdD/VsgEIhVlIJ2XHMCaCr2uHjGhrzoO32nkvj6pXD2IGTgMJhLHnVVRFeaHd0xs2
	 xPYn+ojABRwTMzTIW9yZ8AFSboR7vfDxgL3r5IsmQN7j7b7b99nCGMJkMS1RhPBYAn
	 xDs/SoAY7VBX6x6oWKBPfQL4aIqNAkT2fcEAFjRRQI2yFCsLS6N5j6rExgmpcjbV2o
	 zJK41S3zfv25A==
Date: Wed, 10 Jan 2024 17:42:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jian Wen <wenjianhn@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v4] xfs: improve handling of prjquot ENOSPC
Message-ID: <20240111014204.GM722975@frogsfrogsfrogs>
References: <20231216153522.52767-1-wenjianhn@gmail.com>
 <20240104062248.3245102-1-wenjian1@xiaomi.com>
 <ZZtDRe+jzM72Y8mY@dread.disaster.area>
 <20240109061442.GD722975@frogsfrogsfrogs>
 <ZZzp2ARmwf3FrkUV@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZzp2ARmwf3FrkUV@dread.disaster.area>

On Tue, Jan 09, 2024 at 05:38:16PM +1100, Dave Chinner wrote:
> On Mon, Jan 08, 2024 at 10:14:42PM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 08, 2024 at 11:35:17AM +1100, Dave Chinner wrote:
> > > On Thu, Jan 04, 2024 at 02:22:48PM +0800, Jian Wen wrote:
> > > > From: Jian Wen <wenjianhn@gmail.com>
> > > > 
> > > > Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
> > > > limit is reached. As a result, xfs_file_buffered_write() will flush
> > > > the whole filesystem instead of the project quota.
> > > > 
> > > > Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
> > > > -ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
> > > > for both EDQUOT and ENOSPC consistent.
> > > > 
> > > > Changes since v3:
> > > >   - rename xfs_dquot_is_enospc to xfs_dquot_hardlimit_exceeded
> > > >   - acquire the dquot lock before checking the free space
> > > > 
> > > > Changes since v2:
> > > >   - completely rewrote based on the suggestions from Dave
> > > > 
> > > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> > > 
> > > Please send new patch versions as a new thread, not as a reply to
> > > a random email in the middle of the review thread for a previous
> > > version.
> > > 
> > > > ---
> > > >  fs/xfs/xfs_dquot.h       | 22 +++++++++++++++---
> > > >  fs/xfs/xfs_file.c        | 41 ++++++++++++--------------------
> > > >  fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
> > > >  fs/xfs/xfs_icache.h      |  7 +++---
> > > >  fs/xfs/xfs_inode.c       | 19 ++++++++-------
> > > >  fs/xfs/xfs_reflink.c     |  5 ++++
> > > >  fs/xfs/xfs_trans.c       | 41 ++++++++++++++++++++++++--------
> > > >  fs/xfs/xfs_trans_dquot.c |  3 ---
> > > >  8 files changed, 121 insertions(+), 67 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > > > index 80c8f851a2f3..d28dce0ed61a 100644
> > > > --- a/fs/xfs/xfs_dquot.h
> > > > +++ b/fs/xfs/xfs_dquot.h
> > > > @@ -183,6 +183,22 @@ xfs_dquot_is_enforced(
> > > >  	return false;
> > > >  }
> > > >  
> > > > +static inline bool
> > > > +xfs_dquot_hardlimit_exceeded(
> > > > +	struct xfs_dquot	*dqp)
> > > > +{
> > > > +	int64_t freesp;
> > > > +
> > > > +	if (!dqp)
> > > > +		return false;
> > > > +	if (!xfs_dquot_is_enforced(dqp))
> > > > +		return false;
> > > > +	xfs_dqlock(dqp);
> > > > +	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
> > > > +	xfs_dqunlock(dqp);
> > > > +	return freesp < 0;
> > > > +}
> > > 
> > > Ok, what about if the project quota EDQUOT has come about because we
> > > are over the inode count limit or the realtime block limit? Both of
> > > those need to be converted to ENOSPC, too.
> > > 
> > > i.e. all the inode creation operation need to be checked against
> > > both the data device block space and the inode count space, whilst
> > > data writes need to be checked against data space for normal IO
> > > and both data space and real time space for inodes that are writing
> > > to real time devices.
> > 
> > (Yeah.)
> > 
> > > Also, why do we care about locking here? If something is modifying
> > > dqp->q_blk.reserved concurrently, holding the lock here does nothing
> > > to protect this code from races. All it means is that we we'll block
> > > waiting for the transaction that holds the dquot locked to complete
> > > and we'll either get the same random failure or success as if we
> > > didn't hold the lock during this calculation...
> > 
> > I thought we had to hold the dquot lock before accessing its fields.
> 
> Only if we care about avoiding races with ongoing modifications or
> we want to serialise against new references (e.g. because we are
> about to reclaim the dquot).
> 
> The inode holds a reference to the dquot at this point (because of
> xfs_qm_dqattach()), so we really don't need to hold a lock just
> to sample the contents of the attached dquot.
> 
> > Or are you really saying that it's silly to take the dquot lock *again*
> > having already decided (under dqlock elsewhere) that we were over a
> > quota?
> 
> No, I'm saying that we really don't have to hold the dqlock to
> determine if the dquot is over quota limits. It's either going to
> over or under, and holding the dqlock while sampling it really
> doesn't change the fact that it the dquot accounting can change
> between the initial check under the dqlock and a subsequent check
> on the second failure under a different hold of the dqlock.
> 
> It's an inherently racy check, and holding the dqlock does nothing
> to make it less racy or more accurate.
> 
> > In that case, perhaps it makes more sense to have
> > xfs_trans_dqresv return an unusual errno for "project quota over limits"
> > so that callers can trap that magic value and translate it into ENOSPC?
> 
> Sure, that's another option, but it means we have to trap EDQUOT,
> ENOSPC and the new special EDQUOT-but-really-means-ENOSPC return
> errors. I'm not sure it will improve the code a great deal, but if
> there's a clean way to implement such error handling it may make
> more sense. Have you prototyped how such error handling would look
> in these cases?
> 
> Which also makes me wonder if we should actually be returning what
> quota limit failed, not EDQUOT. To take the correct flush action, we
> really need to know if we failed on data blocks, inode count or rt
> extents. e.g. flushing data won't help alleviate an inode count
> overrun...

Yeah.  If it's an rtbcount, then it only makes sense to flush realtime
files; if it's a bcount, we flush nonrt files, and if it's an inode
count then I guess we push inodegc?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
