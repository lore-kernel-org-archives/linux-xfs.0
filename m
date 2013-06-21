Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F02B97F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 08:57:24 -0500 (CDT)
Message-ID: <51C45BC2.8010100@sgi.com>
Date: Fri, 21 Jun 2013 08:57:22 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/60] xfs: don't do IO when creating an new inode
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-6-git-send-email-david@fromorbit.com>
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
> When we are allocating a new inode, we read the inode cluster off
> disk to increment the generation number. We are already using a
> random generation number for newly allocated inodes, so if we are not
> using the ikeep mode, we can just generate a new generation number
> when we initialise the newly allocated inode.
>
> This avoids the need for reading the inode buffer during inode
> creation. This will speed up allocation of inodes in cold, partially
> allocated clusters as they will no longer need to be read from disk
> during allocation. It will also reduce the CPU overhead of inode
> allocation by not having the process the buffer read, even on cache
> hits.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

As a side note, the comment in xfs_inode.h for the i_d:
xfs_icdinode_t          i_d;            /* most of ondisk inode */

In Linux 3.10, it is no longer just most.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
