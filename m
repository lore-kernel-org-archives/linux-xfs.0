Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EF784A39
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708705725; cv=none; b=qp4f9l4z2AtHrTkGIyLTFB8OXjcIK0efTErtHuYXfZm5nnqmnj+xQGIzYgwVh2lc67nDoSPNruVisdiMw9MJkkl10c01qv49UQ8NbqMhCHKTPUBEluMdVmAEWdchgIsr93934b/b6Y+Lny0IGmfbWh1M6ODyft+nrH/LKh3eJ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708705725; c=relaxed/simple;
	bh=/0F+4MCcMr3clyUrs1QTNbJ4s2Ht6deLDskUiUlbSRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWp/tE0UGowHJNdzKIWHuogABEb0VOHWNk13z+mm4YzeE16M9d2Px+AmegpCk8Z5yVPSIm4yc42yMcWMprB6iqao6iFN3MJ75jys0MItLhdLG1GF5xNKlTgFidxcUTPdQfrGqXMxOzeVXDuIZhUXgCbhnAC0Rv6wlFM0V8crzxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcXxQAuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcXxQAuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60290C43390;
	Fri, 23 Feb 2024 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708705724;
	bh=/0F+4MCcMr3clyUrs1QTNbJ4s2Ht6deLDskUiUlbSRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DcXxQAuVq/fPWluYCjdwDpCL3MRFY8OxFJ7ziCJNIN4xHF/m8oTAXagIRnOZikZ/1
	 +iWHTGR57RoLF0SXQ4MZsh6WGit1Mex2X6q2F76RY6oz45MlfIaOqqva3sGRpyaGGD
	 W7/85MpBWG4CDNT0EoUIOfLCzh1IK+8cW8Qz7pQoDEU37sWO7meCVWkYtrfhItNhMc
	 mO42PXAR+9ry9BuoMs0i2Df+Hdv1w5KJUprU+bp2IcP/9UcyiDAPdtYyBfpoVKyOjm
	 i/GgFQyRk6Ng1PqUyrvbg5AcpcIE3j/stmaQXiM8XHzFwRzcBF2/txJ0zpZjJuBB1O
	 BlCaBhm1ymS2g==
Date: Fri, 23 Feb 2024 08:28:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: don't use current->journal_info
Message-ID: <20240223162843.GL616564@frogsfrogsfrogs>
References: <20240221224723.112913-1-david@fromorbit.com>
 <20240221232536.GH616564@frogsfrogsfrogs>
 <ZdafCN+mNecltZ1T@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdafCN+mNecltZ1T@dread.disaster.area>

On Thu, Feb 22, 2024 at 12:10:32PM +1100, Dave Chinner wrote:
> On Wed, Feb 21, 2024 at 03:25:36PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 22, 2024 at 09:47:23AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > syzbot reported an ext4 panic during a page fault where found a
> > > journal handle when it didn't expect to find one. The structure
> > > it tripped over had a value of 'TRAN' in the first entry in the
> > > structure, and that indicates it tripped over a struct xfs_trans
> > > instead of a jbd2 handle.
> > > 
> > > The reason for this is that the page fault was taken during a
> > > copy-out to a user buffer from an xfs bulkstat operation. XFS uses
> > > an "empty" transaction context for bulkstat to do automated metadata
> > > buffer cleanup, and so the transaction context is valid across the
> > > copyout of the bulkstat info into the user buffer.
> > > 
> > > We are using empty transaction contexts like this in XFS in more
> > > places to reduce the risk of failing to release objects we reference
> > > during the operation, especially during error handling. Hence we
> > > really need to ensure that we can take page faults from these
> > > contexts without leaving landmines for the code processing the page
> > > fault to trip over.
> > > 
> > > We really only use current->journal_info for a single warning check
> > > in xfs_vm_writepages() to ensure we aren't doing writeback from a
> > > transaction context. Writeback might need to do allocation, so it
> > > can need to run transactions itself. Hence it's a debug check to
> > > warn us that we've done something silly, and largely it is not all
> > > that useful.
> > > 
> > > So let's just remove all the use of current->journal_info in XFS and
> > > get rid of all the potential issues from nested contexts where
> > > current->journal_info might get misused by another filesytsem
> > > context.
> > 
> > I wonder if this is too much, though?
> 
> We ran XFS for 15+ years without setting current->journal_info, so I
> don't see it as a necessary feature...

Indeed, I don't see it as a necessary feature for XFS, merely a "bs
coming in from other parts of the kernel" detector.  And boy howdy did I
ever find bs.

> > Conceptually, I'd rather we set current->journal_info to some random
> > number whenever we start a !NO_WRITECOUNT (aka a non-empty) transaction
> > and clear it during transaction commit/cancel.  That way, *we* can catch
> > the case where some other filesystem starts a transaction and
> > accidentally bounces into an updating write fault inside XFS.
> 
> I could just leave the ASSERT(current->journal_info == NULL); in
> xfs_trans_set_context() and we would catch that case. But, really,
> having a page fault from some other filesystem bounce into XFS where
> we then have to run a transaction isn't a bug at all.
> 
> The problem is purely that we now have two different contexts that
> now think they own current->journal_info. IOWs, no filesystem can 
> allow page faults while current->journal_info is set by the
> filesystem because the page fault processing might use
> current->journal_info itself.
> 
> If we end up with nested XFS transactions from a page fault whilst
> holding an empty transaction, then it isn't an issue as the outer
> transaction does not hold a log reservation. The only problem that
> might occur is a deadlock if the page fault tries to take the same
> locks the upper context holds, but that's not a problem that setting
> current->journal_info would solve, anyway...

This, however, is a much better justification (IMHO) for removing the
places where xfs touches journal_info.  Would you mind adding that to
the commit message?

> Hence if XFS doesn't use current->journal_info, then we just don't
> care what context we are running the transaction in, above or below
> the fault.
> 
> > That might be outweighed by the weird semantics of ext4 where the
> > zeroness of journal_info changes its behavior in ways I don't want to
> > understand.  Thoughts?
> 
> That's exactly the problem we're trying to avoid. Either we don't
> allow faults in (empty) transaction context, or we don't use
> current->journal_info. I prefer the latter as it gives us much more
> implementation freedom with empty transaction contexts..

Heh.  I also found much much more bs and shenanigans of exactly the type
you'd expect from a global(ish) void pointer.

With the commit message amended, you can add:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
