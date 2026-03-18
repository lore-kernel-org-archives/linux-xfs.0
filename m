Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0537E3B28D;
	Wed, 18 Mar 2026 21:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867693; cv=none; b=lWFkMfH94xY8Cr0E8ogtmd1Z2/1xOF4sVmvcBYVrVgRJL14Ng+qa0kljxtbhrvzHnRY+FCkBkBk/ZsDsRQKHfONJcOSc3Y360lQyypRgK0AcIMoKnjs5nxRu9lauPxWQ1a9tGbKxGF9w0cpJTjyi2b8GVFNFEgQA9AjgjdzpiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867693; c=relaxed/simple;
	bh=60KVRXDEH95d5Xeh9d+hVTbKLSJ3J2qsEzcMDk2f2VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apNKN5cBBbtNaY403HsY9G2FwZ53L7A0rwkH7GNP8uPDkDS0XjRtfla7t5WdJ0lXg6bEHZklR6sTvZZLBtDRperhT+IKnC9B6lVdiv28p5z4KI/6P2WiTQaDcXYHnnq/m38u33hs4vG7uzif4JwSK38po7xWg410OEvUDMiMrZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLBZV6Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLBZV6Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87C0C19421;
	Wed, 18 Mar 2026 21:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773867692;
	bh=60KVRXDEH95d5Xeh9d+hVTbKLSJ3J2qsEzcMDk2f2VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLBZV6BbzczMo7mdrH8zKIkSp4+W1vGkRslcDJks+EuMZIojdwHVpdWMKpQgfFtVe
	 idZcXKfJMLqqXFSFs0Df4BWvRyzkDokUFlP7DHBQiRPv5UWIJw13YuHTpdeQhwyma7
	 FG8pvukIg3gcFEQXYDNwfAfLHQL0QaiAv7jw1ow0+yIHt6svTrdCw2onZriunT6Sbk
	 wHWerLuNFDlxkXl/bud/JlFSPKwh9w9BOFKBfCgds6sMj81zPIkzZanjHAQ+d5E5C4
	 FJmft3879EMtiikfj4YnDbhRShjw2DQF9U3blFL0nAXMjdlPLf81DbaOKTpT7lTejW
	 sd7Lv3QhdPdlg==
Date: Thu, 19 Mar 2026 08:01:21 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Morduan Zang <zhangdandan@uniontech.com>, cem@kernel.org,
	zhanjun@uniontech.com, dchinner@redhat.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com,
	Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: use GFP_NOFS in __xfs_trans_alloc
Message-ID: <absSoRi8oxXSuSZ7@dread>
References: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>
 <abMhIabvChMOsUrY@dread>
 <20260316091827.GA2182@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316091827.GA2182@lst.de>

On Mon, Mar 16, 2026 at 10:18:27AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 13, 2026 at 07:25:05AM +1100, Dave Chinner wrote:
> > On Thu, Mar 12, 2026 at 03:22:14PM +0800, Morduan Zang wrote:
> > > __xfs_trans_alloc() allocates the transaction structure before
> > > xfs_trans_set_context() establishes the nofs context. If memory reclaim
> > > enters XFS through xfs_vn_sync_lazytime(), this GFP_KERNEL allocation can
> > > trigger a warning from the reclaim path.
> > 
> > PLease include the warning and stack trace in the commit message.
> > 
> > > Use GFP_NOFS for the transaction allocation to avoid filesystem reclaim
> > > recursion before the nofs context is set.
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5
> > 
> > That's a PF_MEMALLOC + __GFP_NOFAIL warning. Has nothing to do
> > with GFP_NOFS.
> 
> Yes.
> 
> > Indeed, the stack trace trivially demonstrates the cause - the
> > sync_lazytime() changes (in 6.19i, IIRC) have put a new XFS
> > transaction in the iput() path that memory reclaim runs.
> 
> The lazytime changes (in 7.0-rc).  And I think they do indeed cause
> this because we fail to clear I_DIRTY_TIME for some cases.
> 
> > We managed to remove all the xfs transactions in this path with the
> > introduction of the background inodegc infrastructure because
> > lockdep, memory allocation and other stuff really don't like us
> > running "must succeed" transactions in the memory reclaim path.
> > 
> > Hence putting a new transaction directly in that path is a
> > regression, and so I suspect the sync_lazytime() call directly from
> > iput() running a transaction needs to be rethought...
> 
> Not a new transaction, but one we didn't hit before.

Sure, but that doesn't change the fact that we should never have put
this timestamp update transaction in the direct iput_final() path.

> That being said,
> doing this separate syncing of the dirty time vs just batching it with
> the write_inode_now in iput_final looks really odd to me.  This goes back
> to Ted's original commit 0ae45f63d4ef8 adding laztime more than 10 years
> ago, which unfortunately does not explain the rationale.

Moving it to pair with write_inode_now() by itself doesn't help us
avoid the transaction in iput_final() context.

It does, however, give us a state flag we can check (I_WILL_FREE) to
change the behaviour of xfs_vn_sync_lazytime() when called from this
path. i.e. we can mark the XFS inode as needing async inodegc
processing and then skip the update transaction.

When VFS inode eviction calls us to destroy the inode, we can
schedule the inode for GC instead of marking it for immediate
reclaim. We then can safely run the timestamp update transaction
from inodegc context. This also allows us to skip the timestamp
update transaction when running GC on unlinked inodes...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
