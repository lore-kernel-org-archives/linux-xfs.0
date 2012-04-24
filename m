Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3OJUFTk104754 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 14:30:15 -0500
Message-ID: <4F96FF42.606@sgi.com>
Date: Tue, 24 Apr 2012 14:30:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 32/37] xfs: move xfs_get_extsz_hint() and kill xfs_rw.h
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-33-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/23/12 00:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The only thing left in xfs_rw.h is a function prototype for an inode
> function.  Move that to xfs_inode.h, and kill xfs_rw.h.
>
> Also move the function implementing the prototype from xfs_rw.c to
> xfs_inode.c so we only have one function left in xfs_rw.c
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
