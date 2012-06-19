Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J7mF7c054660 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 02:48:16 -0500
Date: Tue, 19 Jun 2012 03:48:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: xfs_release don't free eofblocks with extsize hint
Message-ID: <20120619074813.GB30375@infradead.org>
References: <20120611192948.GX29173@sgi.com> <20120612011102.GJ22848@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120612011102.GJ22848@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Tue, Jun 12, 2012 at 11:11:02AM +1000, Dave Chinner wrote:
> Alternatively, (and I think a better solution) is to treat files
> with extent size hints on them exactly the same as files with
> preallocation on them. i.e. in xfs_set_diflags() we set
> XFS_DIFLAG_PREALLOC at the same time we set the XFS_DIFLAG_EXTSIZE,
> and then all our truncate logic just works as expected for
> physical preallocation beyond EOF on extsize hint files without
> changing anything else....

I think that is a much better approach.  The user explicitly asked to
do allocation in the specified unit, so we should not truncate it down.

On something slightly related:  Currently the calls to
xfs_free_eofblocks in xfs_release and in xfs_inactive are guarded by
similar but not quite the same checks on the inode type/flags/allocated
blocks, etc.  It would be really good to factor the common parts into
a helper, and then document why the other checks need to be different.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
