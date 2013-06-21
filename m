Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 014807F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 16:24:28 -0500 (CDT)
Message-ID: <51C4C488.4040304@sgi.com>
Date: Fri, 21 Jun 2013 16:24:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/60] xfs: xfs_ifree doesn't need to modify the inode
	buffer
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-7-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/18/13 23:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Long ago, bulkstat used to read inodes directly fromteh backing
> buffer for speed. This had the unfortunate problem of being cache
> incoherent with unlinks, and so xfs_ifree() had to mark the inode
> as free directly in the backing buffer. bulkstat was changed some
> time ago to use inode cache coherent lookups, and so will never see
> unlinked inodes in it's lookups. Hence xfs_ifree() does not need to
> touch the inode backing buffer anymore.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_inode.c |   32 ++++----------------------------

looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
