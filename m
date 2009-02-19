Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JJYZLo125089 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 13:34:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD705135963
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:34:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CqYFMc5ThcS4YMBP for
	<xfs@oss.sgi.com>; Thu, 19 Feb 2009 11:34:03 -0800 (PST)
Date: Thu, 19 Feb 2009 14:34:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, needs a new owner] XFS misc patches
Message-ID: <20090219193403.GA22736@infradead.org>
References: <49939FDA.6090401@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49939FDA.6090401@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 12, 2009 at 03:04:42PM +1100, Mark Goodwin wrote:
>
> Series of 12 patches, originally by Dave Chinner. These will need
> forward porting to top-of-tree and careful review. See the description
> in each individual patch for details of each patch.
>
> 01/12 readpage-unwritten-mapping

Is there any other reason for this except for the slight cleanup?
Looks goodish to me and I'll throw it into my QA queue.

> 02/12 xfs-fix-log-io-latency
> 03/12 xfs-use-meta-io-for-async-metadata

Whered did we get stuck on these?  IIRC there was some sort of
regression on either the AS or deadlinke scheduler, right?

> 04/12 xfs-inval-page-fixup

Looks good to me, but not really useful until we actually have back
tracing in some useable tree..

> 05/12 xfs-iolock-on-page-mkwrite

Do we have a testcase for those races?

> 06/12 xfs-non-block-writes-when-frozen

We don't actually ever set O_NDELAY for regular files, so this can't
actually be triggered.

> 07/12 xfs-non-block-setattr-size-when-frozen

I wonder if we should do these kinds of things higher up, e.g. in the
vfsmount writer count API in the VFS.

> 08/12 xfs-inode-search

Interesting idea, but really wants some refactoring of the surrounding
code first..

> 09/12 xfs-v2-inodes-default

Do we really care?  There shouldn't be any Linux filesystems with v1
inodes in the wild.

> 10/12 xfs-inode-writeback-checking

b_io_callback is now in the CRC patch series, and we could add
additional checking there.  Must say I don't really like the string
buffer on stack in that path.

> 11/12 xfs-inode-swap

Yeah, we need to revisit this eventually.  Big qustions is what we want
to do with symlinks in an xfs_reno or shrinkfs using this ioctl.

> 12/12 xfs-increase-iclogs

Interesting idea.  But 2MB is much larger than the current log buffer
window..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
