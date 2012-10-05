Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95IEIlm085191 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 13:14:19 -0500
Date: Fri, 5 Oct 2012 14:15:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch v4 06/13] [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121005181543.GA1056@infradead.org>
References: <20121005171853.985930109@sgi.com>
	<20121005171946.330155632@sgi.com> <506F1F21.6000104@sgi.com>
	<20121005180446.GN25175@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121005180446.GN25175@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Fri, Oct 05, 2012 at 01:04:46PM -0500, Ben Myers wrote:
> Christoph suggested that xfs_flush_inodes should take an xfs_mount instead of
> an inode.  It is operating on the super_block level to flush multiple inodes
> rather than the single inode whose pointer was passed in, so I moved it from
> xfs_inode.h to xfs_mount.h.

It's more than a trivial wrapper now, so I'd suggest to move out of line
to e.g. xfs_super.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
