Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAC907F4E
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 03:28:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9E86304032
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 01:28:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lF003ZGaWmoXn7sW (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 01:28:12 -0800 (PST)
Date: Mon, 1 Dec 2014 01:28:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
	write_time()
Message-ID: <20141201092810.GA5538@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-2-git-send-email-tytso@mit.edu>
	<20141126192328.GA20436@infradead.org>
	<20141127144116.GA14091@thunk.org>
	<20141127153315.GC14091@thunk.org>
	<20141127164952.GA1622@infradead.org>
	<20141127202731.GG14091@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141127202731.GG14091@thunk.org>
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
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Thu, Nov 27, 2014 at 03:27:31PM -0500, Theodore Ts'o wrote:
> I can do that, but part of the reason why we were doing this rather
> involved set of changes was to allow other file systems to be able to
> take advantage of lazytime.  I suppose there is value in allowing
> other file systems, such as jfs, f2fs, etc., to use it, but still,
> it's a bit of a shame to drop btrfs and xfs support for this feature.

I want to see xfs and btrfs support, but I think we're running in some
conceptual problems here.  I don't have the time right now to fully
review the XFS changes for correctness and test them, and I'd rather
keep things as-is for a while and then add properly designed and fully
teste support in rather than something possible broken.

> I'll note by the way that ext3 and ext4 doesn't really use VFS dirty
> tracking either --- see my other comments about the naming of
> "mark_inode_dirty" being a bit misleading, at least for all/most of
> the major file systems.  The problem seems to be that replacement
> schemes that we've all using are slightly different.  :-/

Indeed.  It seems all existing ->dirty_inode instances basically
just try to work around the problem that the VFS simply updates
timestamps by writing into the inode without involving the filesystem.
There are all kinds of bugs in different instances, as well as comments
mentioning an assumption that this only happens for atime although
the VFS also dos this "trick" for c/mtime, including a caller from
the page fault code that the filesystems can't even avoid by providing
non-default methods everywhere.

> I suppose should let the btrfs folks decide whether they want to add
> is_readonly() and write_time() function --- or maybe help with the
> cleanup work so that mark_inode_dirty() can reflect an error to its
> callers.   Chris, David, what do you think?


The ->is_readonly method seems like a clear winner to me, I'm all for
adding it, and thus suggested moving it first in the series.

I've read a bit more through the series and would like to suggest
the following approach for the rest:

 - convert ext3/4 to use ->update_time instead of the ->dirty_time
   callout so it gets and exact notifications (preferably the few
   remaining filesystems as well, although that shouldn't really be a
   blocker)
 - defer timestamp updates for any filesystems not defining
   ->update_time (or ->dirty_time for now), and allow filesystems
   using ->update_time to defer the update as well by calling
   mark_inode_dirty with the I_DIRTY_TIME flag so that XFS and btrfs
   don't have to opt-in without testing.
 - Convert xfs, btrfs and the remaining filesystes using ->dirty_inode
   incrementally.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
