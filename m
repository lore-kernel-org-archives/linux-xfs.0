Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BD0387581;
	Mon, 16 Mar 2026 09:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773652712; cv=none; b=hDkOoFeXD8GioxDYnxIcOv16TpQR5CwpF1wwjai5me+gsWiegySxNUyDwFicw6jjwsH9U/eFTgpNiOHietr7Vsqp1v00yZc4IE0rNb/Xvq8KPVosutDtK2I3x8aQfUOeqx70BDiFl11vWfrsuBsuMkb72C2U0uM/NEwRwr+D/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773652712; c=relaxed/simple;
	bh=1cgsREaGcFJTJmExozLA1hsb5xrO6Jf4rJPPMKxFl6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQE+mYPer5d/rnljOa0w4q1EpLIsP224BKqmS2YxoF/qv80SNI36AwUqJZYNoIykE7TTWDIeT+zUYLVZWdGrlTFfMscQw6nixvODko2xwiGwfWMHANXdCkJi7UW/V7XwmSaBt+Igimq0AHJNRGhMAUycbJF60v3FV/LEUyu6Faw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B18B68B05; Mon, 16 Mar 2026 10:18:27 +0100 (CET)
Date: Mon, 16 Mar 2026 10:18:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Morduan Zang <zhangdandan@uniontech.com>, cem@kernel.org,
	zhanjun@uniontech.com, hch@lst.de, dchinner@redhat.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com,
	Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: use GFP_NOFS in __xfs_trans_alloc
Message-ID: <20260316091827.GA2182@lst.de>
References: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com> <abMhIabvChMOsUrY@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abMhIabvChMOsUrY@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 13, 2026 at 07:25:05AM +1100, Dave Chinner wrote:
> On Thu, Mar 12, 2026 at 03:22:14PM +0800, Morduan Zang wrote:
> > __xfs_trans_alloc() allocates the transaction structure before
> > xfs_trans_set_context() establishes the nofs context. If memory reclaim
> > enters XFS through xfs_vn_sync_lazytime(), this GFP_KERNEL allocation can
> > trigger a warning from the reclaim path.
> 
> PLease include the warning and stack trace in the commit message.
> 
> > Use GFP_NOFS for the transaction allocation to avoid filesystem reclaim
> > recursion before the nofs context is set.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5
> 
> That's a PF_MEMALLOC + __GFP_NOFAIL warning. Has nothing to do
> with GFP_NOFS.

Yes.

> Indeed, the stack trace trivially demonstrates the cause - the
> sync_lazytime() changes (in 6.19i, IIRC) have put a new XFS
> transaction in the iput() path that memory reclaim runs.

The lazytime changes (in 7.0-rc).  And I think they do indeed cause
this because we fail to clear I_DIRTY_TIME for some cases.

> We managed to remove all the xfs transactions in this path with the
> introduction of the background inodegc infrastructure because
> lockdep, memory allocation and other stuff really don't like us
> running "must succeed" transactions in the memory reclaim path.
> 
> Hence putting a new transaction directly in that path is a
> regression, and so I suspect the sync_lazytime() call directly from
> iput() running a transaction needs to be rethought...

Not a new transaction, but one we didn't hit before.  That being said,
doing this separate syncing of the dirty time vs just batching it with
the write_inode_now in iput_final looks really odd to me.  This goes back
to Ted's original commit 0ae45f63d4ef8 adding laztime more than 10 years
ago, which unfortunately does not explain the rationale.

