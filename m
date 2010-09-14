Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EMCP2D150534 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:12:26 -0500
Subject: Re: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-8-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-8-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 17:12:17 -0500
Message-ID: <1284502337.9701.89.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Under heavy multi-way parallel create workloads, the VFS struggles to write
> back all the inodes that have been changed in age order. The bdi flusher thread
> becomes CPU bound, spending 85% of it's time in the VFS code, mostly traversing
> the superblock dirty inode list to separate dirty inodes old enough to flush.
> 
> We already keep an index of all metadata changes in age order - in the AIL -
> and continued log pressure will do age ordered writeback without any extra
> overhead at all. If there is no pressure on the log, the xfssyncd will
> periodically write back metadata in ascending disk address offset order so will
> be very efficient.

So log pressure will cause the logged updates to the inode to be
written to disk (in order), which is all we really need.  Is that
right?  Therefore we don't need to rely on the VFS layer to get
the dirty inode pushed out?

Is writeback the only reason we should inform the VFS that an
inode is dirty?  (Sorry, I have to leave shortly and don't have
time to follow this at the moment--I may have to come back to
this later.)

> Hence we can stop marking VFS inodes dirty during transaction commit or when
> changing timestamps during transactions. This will keep the inodes in the
> superblock dirty list to those containing data or unlogged metadata changes.

The code looks fine to me, but I don't know whether the
change it implements is correct or not without digging
in a little deeper.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_iops.c |   18 +++++-------------


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
