Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7UHTOjI038476 for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 12:29:34 -0500
Date: Sun, 30 Aug 2009 18:29:59 +0100
From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090830172959.GD7129@shareable.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-8-git-send-email-jack@suse.cz>
	<20090827173540.GA19115@infradead.org>
	<20090830163551.GA7129@shareable.org>
	<20090830163917.GA23955@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090830163917.GA23955@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Christoph Hellwig wrote:
> Linux has sync_file_range which currently is a perfect way to lose your
> synced' data, but with two more flags and calls to ->fsync we could
> turn it into range-fsync/fdatasync.

Apart from the way it loses your data, the man page for
sync_file_range never manages to explain quite why you should use the
existing flags in various combinations.  It's only obvious if you've
worked on a kernel yourself.

Having asked this before, it appears one of the reasons for
sync_file_range working as it does is to give the application more
control over writeback order and to some extent, reduce the amount of
blocking.

But it's really difficult to manage the amount of blocking with it.
You need to know the request queue size among other things, and even
if you do it's dynamic.  Writeback order would be as easy with
fdatasync_range, and if you want to reduce blocking, a good
implementation of aio_fsync would be more useful.  Or, you have to use
application writeback threads anyway, so fdatasync_range again.

The one thing sync_file_range can do is let you submit multiple ranges
which the elevators can sort for the hardware.  You can't do that with
sequential calls to fdatasync_range, and it's not clear that aio_fsync
is implemented well enough (but it's a fairly good API for it).

Nick Piggin's idea to let fdatasync_range take multiple ranges might
help with that, but it's not clear how much.

> I'm not sure if that's a good
> idea or if we should just add a sys_fdatasync_rage systems call.

fdatasync_range has the advantage of being comprehensible.  People
will use it because it makes sense.

sync_file_range could be hijacked with new flags to implement
fdatasync_range.  If that's done, I'd rename the system call, but keep
it compatible with sync_file_range's flags, which would never be set
when userspace uses the new functionality.

> I don't quite see the point of a range-fsync, but it could be easily
> implemented as a flag.

A flags argument would be good anyway: to indicate if we want an
ordinary fdatasync, or something which flushes the relevant bit of
volatile hardware caches too.  With that as a capability, it is useful
to offer fsync, because that'd be the only way to get a volatile
hardware cache flush (or maybe the only way not to?).

For that reason, it should be permitted to give an infinitely large range.

I don't see the point of range-fsync either, but I'm not sure if I see
any harm in it.  If permitted, range-fsync with a zero-byte range
would flush just the inode state and none of the data.  If that's
technically available, maybe O_ISYNC and "#define O_SYNC
(O_DATASYNC|O_ISYNC)" isn't such as daft idea.

I'd call it fsync_range for consistency with aio_fsync (POSIX), which
takes flags O_DSYNC or O_SYNC to indicate the type of sync.  But I'd
use new flag names, to keep the space clear for other flags.  Just
sketching some ideas:

/* One of FSYNC_RANGE_SYNC or FSYNC_RANGE_DATASYNC must be set. */

#define FSYNC_RANGE_SYNC	(1 << 0)	/* Like fsync, O_SYNC. */
#define FSYNC_RANGE_DATASYNC	(1 << 1)	/* Like fdatasync, O_DSYNC. */
#define FSYNC_RANGE_NO_HWCACHE	(1 << 2)	/* Not hardware caches. */

-- Jamie

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
