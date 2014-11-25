Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE16E7F4E
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:30:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAF4830404E
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 09:30:46 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id z8jKMOKppFLViTJK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 09:30:45 -0800 (PST)
Date: Tue, 25 Nov 2014 18:30:40 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141125173040.GD3228@quack.suse.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
	<20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125043335.GF31339@thunk.org>
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
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon 24-11-14 23:33:35, Ted Tso wrote:
> On Tue, Nov 25, 2014 at 12:52:39PM +1100, Dave Chinner wrote:
> > > +static void flush_sb_dirty_time(struct super_block *sb)
> > > +{
>   ...
> > > +}
> > 
> > This just seems wrong to me, not to mention extremely expensive when we have
> > millions of cached inodes on the superblock.
> 
> #1, It only gets called on a sync(2) or syncfs(2), which can be pretty
> expensive as it is, so I didn't really worry about it.
> 
> #2, We're already iterating over all of the inodes in the sync(2) or
> syncfs(2) path, so the code path in question is already O(N) in the
> number of inodes.
> 
> > Why can't we just add a function like mark_inode_dirty_time() which
> > puts the inode on the dirty inode list with a writeback time 24
> > hours in the future rather than 30s in the future?
> 
> I was concerned about putting them on the dirty inode list because it
> would be extra inodes for the writeback threads would have to skip
> over and ignore (since they would not be dirty in the inde or data
> pages sense).
  I agree this isn't going to work easily. Currently flusher relies on
dirty list being sorted by i_dirtied_when and that gets harder to maintain
if we ever have inodes with i_dirtied_when in future (we'd have to sort-in
newly dirtied inodes).

> Another solution would be to use a separate linked list for dirtytime
> inodes, but that means adding some extra fields to the inode
> structure, which some might view as bloat.  Given #1 and #2 above,
> yes, we're doubling the CPU cost for sync(2) and syncfs(2), since
> we're not iterating over all of the inodes twice, but I believe that
> is a better trade-off than bloating the inode structure with an extra
> set of linked lists or increasing the CPU cost to the writeback path
> (which gets executed way more often than the sync or syncfs paths).
  This would be possible and as Boaz says, it might be possible to reuse
the same list_head in the inode for this. Getting rid of the full scan of
all superblock inodes would be nice (as the scan gets really expensive for
large numbers of inodes (think of i_sb_lock contention) and this makes it
twice as bad) so I'd prefer to do this if possible.
 
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
