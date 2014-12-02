Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 14C657F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 03:20:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0336330407F
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 01:20:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5NBO4kdTCV334DmS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 01:20:35 -0800 (PST)
Date: Tue, 2 Dec 2014 01:20:33 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
	write_time()
Message-ID: <20141202092033.GA29712@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-2-git-send-email-tytso@mit.edu>
	<20141126192328.GA20436@infradead.org>
	<20141127144116.GA14091@thunk.org>
	<20141127153315.GC14091@thunk.org>
	<20141127164952.GA1622@infradead.org>
	<20141127202731.GG14091@thunk.org>
	<20141201092810.GA5538@infradead.org>
	<20141201150450.GA3337@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141201150450.GA3337@thunk.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

On Mon, Dec 01, 2014 at 10:04:50AM -0500, Theodore Ts'o wrote:
> >  - convert ext3/4 to use ->update_time instead of the ->dirty_time
> >    callout so it gets and exact notifications (preferably the few
> >    remaining filesystems as well, although that shouldn't really be a
> >    blocker)
> 
> We could do that, although ext3/4's ->update_time() would be exactly
> the same as the generic update_time() function, so there would be code
> duplication.  If the goal is to get rid of the magic in
> -->dirty_inode() being used to work around how the VFS makes changes
> to fields that end up in the on-disk inode, we would need to audit a
> lot of extra code paths; at the very least, in how the generic quota
> code handles updates to i_size and i_blocks (for example).
> 
> And BTW, we don't actually have a dirty_time() function any more in
> the current patch series.  update_time() is currently looking like
> this:

Sorry, I actually meant ->dirty_inode, which is where ext4 currently
hooks in for time updates.  ->update_time was introduced to

 a) more specificly catch the kind of update
 b) allow the filesystem to take locks or a start a transaction
    before the inode fields are updated to provide proper atomicy.

It seems like the quota code has the same problem, but given that
neither XFS nor btrfs use it it seems like no one cared enough to sort
it out properly..

> static int update_time(struct inode *inode, struct timespec *time, int flags)
> {
> 	if (inode->i_op->update_time)
> 		return inode->i_op->update_time(inode, time, flags);
> 
> 	if (flags & S_ATIME)
> 		inode->i_atime = *time;
> 	if (flags & S_VERSION)
> 		inode_inc_iversion(inode);
> 	if (flags & S_CTIME)
> 		inode->i_ctime = *time;
> 	if (flags & S_MTIME)
> 		inode->i_mtime = *time;
> 
> 	if ((inode->i_sb->s_flags & MS_LAZYTIME) && !(flags & S_VERSION) &&
> 	    !(inode->i_state & I_DIRTY))
> 		__mark_inode_dirty(inode, I_DIRTY_TIME);
> 	else
> 		__mark_inode_dirty(inode, I_DIRTY_SYNC);
> 	return 0;

Why do you need the additional I_DIRTY flag?  A "lesser"
__mark_inode_dirty should never override a stronger one.

Otherwise this looks fine to me, except that I would split the default
implementation into a new generic_update_time helper.

> XFS doesn't have a ->dirty_time yet, but that way XFS would be able to
> use the I_DIRTY_TIME flag to log the journal timestamps if it so
> desires, and perhaps drop the need for it to use update_time().

We will probably always need a ->update_time to proide proper locking
around the timestamp updates.

> (And
> with XFS doing logical journalling, it may be that you might want to
> include the timestamp update in the journal if you have a journal
> transaction open already, so the disk is spun up or likely to be spin
> up anyway, right?)

XFS transactions are explicitly opened and closed, so during the atime
updates we'll never have one open.

What we could try is to have CIL items that are on "indefinit" hold
before they are batched into a checkpoint.  We'd still commit them to
an in-memory transaction in ->upate_time for that.  All this requires
a lot of through and will take some time, though.

In the current from the generic lazytime might even be a loss for XFS as
we're already really good at batching updates from multiple inodes in
the same cluster for the in-place writeback, so I really don't want
to just enable it without those optimizations without a lot of testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
