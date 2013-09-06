Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEDE67F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:06:24 -0500 (CDT)
Message-ID: <522A199D.9040509@sgi.com>
Date: Fri, 06 Sep 2013 13:06:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 40/55] xfs: make struct xfs_perag kernel only
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-41-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The struct xfs_perag has many kernel-only definitions in it,
> requiring a __KERNEL__ guard so userspace can use it to. Move it to
> xfs_mount.h so that it it kernel-only, and let userspace redefine
> it's own version of the structure containing only what it needs.
> This gets rid of another __KERNEL__ check in the XFS header files.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Yeah, this is the end of the kernel / user sync part of the series.
Thanks Dave.

The major difference seem to come from this series user patch 31/55.

Other differences between kernel/user header/sources are in:
include major difference to TOT:
struct xfs_perag is in xfs_ag.h user and xfs_mount.h in kernel.

some differences between
xfs_alloc_btree.c xfs_bmap_btree.c xfs_btree.c xfs_ialloc_btree.c 
xfs_inode_buf.c xfs_rtalloc.c

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
