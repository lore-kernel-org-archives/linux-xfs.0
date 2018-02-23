Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33210 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751351AbeBWPfO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 10:35:14 -0500
Date: Fri, 23 Feb 2018 16:35:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: implement the lazytime mount options
Message-ID: <20180223153513.GA17023@lst.de>
References: <20180222152957.19624-1-hch@lst.de> <20180222152957.19624-3-hch@lst.de> <20180223005048.GK7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180223005048.GK7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Fri, Feb 23, 2018 at 11:50:48AM +1100, Dave Chinner wrote:
> > +	if ((inode->i_sb->s_flags & SB_LAZYTIME) &&
> > +	    !((flags & S_VERSION) && inode_maybe_inc_iversion(inode, false)))
> > +		return generic_update_time(inode, now, flags);
> 
> So if we've incremented iversion here on a lazytime update (hence
> making it not lazy), we won't do the iversion update in
> xfs_trans_log_inode() because the query bit has been cleared here.
> Hence we won't set XFS_ILOG_CORE in the transaction and the iversion
> update will not be logged.

Indeed, I'll fix this up.

> > +	if (inode->i_state & (I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED)) {
> > +		spin_lock(&inode->i_lock);
> > +		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
> > +		spin_unlock(&inode->i_lock);
> > +	}
> 
> I suspect this is racy w.r.t other code that sets/clears the
> I_DIRTY_TIME fields. Shouldn't both the check and clear be under the
> spin lock?

I don;t think so.  The racy check is perfectly fine - if someone
cleared the flag racing with the above nothing bad will happen.
If someone raced setting it we won't capture this update in the
transaction and will have to log another one 24 hours later in the
worst case.  The only reason for the lock is to not corrupt i_state
itself by overlapping rmw cycles.
