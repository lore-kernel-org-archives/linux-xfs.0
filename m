Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LFMwSE177374 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 10:23:08 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77E9B3EAF16
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 08:23:41 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TDrfmN6NtiFx8czL for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2009 08:23:41 -0700 (PDT)
Date: Fri, 21 Aug 2009 17:23:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090821152339.GD3007@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-8-git-send-email-jack@suse.cz>
	<20090819162638.GE6150@infradead.org>
	<20090820121531.GC16486@duck.novell.com>
	<20090820162729.GA24659@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090820162729.GA24659@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Thu 20-08-09 12:27:29, Christoph Hellwig wrote:
> On Thu, Aug 20, 2009 at 02:15:31PM +0200, Jan Kara wrote:
> > On Wed 19-08-09 12:26:38, Christoph Hellwig wrote:
> > > Looks good to me.  Eventually we should use those SYNC_ flags also all
> > > through the fsync codepath, but I'll see if I can incorporate that in my
> > > planned fsync rewrite.
> >   Yes, I thought I'll leave that for later. BTW it should be fairly easy to
> > teach generic_sync_file() to do fdatawait() before calling ->fsync() if the
> > filesystem sets some flag in inode->i_mapping (or somewhere else) as is
> > needed for XFS, btrfs, etc.
> 
> Maybe you can help brain storming, but I still can't see any way in that
> the
> 
>   - write data
>   - write inode
>   - wait for data
> 
> actually is a benefit in terms of semantics (I agree that it could be
> faster in theory, but even that is debatable with todays seek latencies
> in disks)
> 
> Think about a simple non-journaling filesystem like ext2:
> 
>  (1) block get allocated during ->write before putting data in
>       - this dirties the inode because we update i_block/i_size/etc
>  (2) we call fsync (or the O_SNC handling code for that matter)
>       - we start writeout of the data, which takes forever because the
> 	file is very large
>       - then we write out the inode, including the i_size/i_blocks
> 	update
>       - due to some reason this gets reordered before the data writeout
> 	finishes (without that happening there would be no benefit to
> 	this ordering anyway)
>  (3) no we call filemap_fdatawait to wait for data I/O to finish
> 
> Now the system crashes between (2) and (3).  After that we we do have
> stale data in the inode in the area not written yet.
  Yes, that's true.

> Is there some case between that simple filesystem and the i_size update
> from I/O completion handler in XFS/ext4 where this behaviour actually
> buys us anything?  Any ext3 magic maybe?
  Hmm, I can imagine it would buy us something in two cases (but looking at
the code, neither is implemented in such a way that it would really help
us in any way):
1) when an inode and it's data are stored in one block (e.g. OCFS2 or UDF) do
   this.
2) when we journal data
  In the first case we would wait for block with data to be written only to
submit it again because inode was still dirty.
  In the second case, it would make sence if we waited for transaction
commit in fdatawait() because only then data is really on disk. But I don't
know about a fs which would do it - ext3 in data=journal mode just adds
page buffers to the current transaction in writepage and never sets
PageWriteback so fdatawait() is nop for it. The page is pinned in memory
only by the fact that its buffer heads are part of a transaction and thus
cannot be freed.
  So currently I don't know about real cases where fdatawait after ->fsync()
would buy us anything...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
