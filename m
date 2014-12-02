Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9BD57F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 06:58:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AC76AC03D
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 04:58:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2W5VHOZ9VjCDlDGa (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 04:58:22 -0800 (PST)
Date: Tue, 2 Dec 2014 13:58:20 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Message-ID: <20141202125820.GE9092@quack.suse.cz>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
	<1417154411-5367-2-git-send-email-tytso@mit.edu>
	<20141128172323.GD738@quack.suse.cz>
	<20141128181421.GA19461@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141128181421.GA19461@google.com>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri 28-11-14 13:14:21, Ted Tso wrote:
> On Fri, Nov 28, 2014 at 06:23:23PM +0100, Jan Kara wrote:
> > Hum, when someone calls fsync() for an inode, you likely want to sync
> > timestamps to disk even if everything else is clean. I think that doing
> > what you did in last version:
> > 	dirty = inode->i_state & I_DIRTY_INODE;
> > 	inode->i_state &= ~I_DIRTY_INODE;
> > 	spin_unlock(&inode->i_lock);
> > 	if (dirty & I_DIRTY_TIME)
> > 		mark_inode_dirty_sync(inode);
> > looks better to me. IMO when someone calls __writeback_single_inode() we
> > should write whatever we have...
> 
> Yes, but we also have to distinguish between what happens on an
> fsync() versus what happens on a periodic writeback if I_DIRTY_PAGES
> (but not I_DIRTY_SYNC or I_DIRTY_DATASYNC) is set.  So there is a
> check in the fsync() code path to handle the concern you raised above.
  Ah, this is the thing you have been likely talking about but which I was
constantly missing in my thoughts. You don't want to write times when inode
has only dirty pages and timestamps - I was always thinking about a
situation where inode has only dirty timestamps and not pages. This
situation also complicates the writeback logic because when inode has dirty
pages, you need to track it as normal dirty inode for page writeback (with
dirtied_when correspoding to time when pages were dirtied) but in
parallel you now need to track the information that inode has timestamps
that weren't written for X long. And even if we stored how old are
timestamps it isn't easily possible to keep the list of inodes with just
dirty timestamps sorted by dirty time. So now I finally understand why you
did things the way you did them... Sorry for misleading you.

So let's restart the design so that things are clear:
1) We have new inode bit I_DIRTY_TIME. This means that only timestamps in
the inode have changed. The desired behavior is that inode is with
I_DIRTY_TIME and without I_DIRTY_SYNC | I_DIRTY_DATASYNC is written by
background writeback only once per 24 hours. Such inodes do get written by
sync(2) and fsync(2) calls.

2) Inodes with only I_DIRTY_TIME are tracked in a new dirty list
b_dirty_time. We use i_wb_list list head for this. Unlike b_dirty list,
this list isn't kept sorted by dirtied_when. If queue_io() sees for_sync
bit set in the work item, it will call mark_inode_dirty_sync() for all
inodes in b_dirty_time before queuing io from b_dirty list. Once per hour
(or something like that) flusher thread scans the whole b_dirty_time list
and calls mark_inode_dirty_sync() for all inodes that have too old dirty
timestamps (to detect this we need a new time stamp in the inode).

3) When fsync() sees inode with I_DIRTY_TIME set, it calls
mark_inode_dirty_sync().

4) When we are dropping last inode reference and inode has I_DIRTY_TIME
set, we call mark_inode_dirty_sync().

And that should be it, right?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
