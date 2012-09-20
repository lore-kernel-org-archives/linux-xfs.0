Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KDmpHp090996 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 08:48:51 -0500
Message-ID: <505B1F03.4070004@sgi.com>
Date: Thu, 20 Sep 2012 08:49:55 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
References: <20120919163133.097340199@sgi.com> <20120919233435.GF31501@dastard>
In-Reply-To: <20120919233435.GF31501@dastard>
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

On 09/19/12 18:34, Dave Chinner wrote:
> I suspect the only way to fix this is to re-use the old workqueue
> method of avoiding blocking on the workqueue indefinitely. That is,
> if we fail to get the lock in this case, we return with EGAIN and
> requeue the work. __xfs_alloc_vextent() and xfs_alloc_fix_freelist()
> already have trylock support, so this should be fairly easy to do.
> If I also convert the work to delayed work, I can easily add a
> backoff that will prevent busy looping on the workqueue.
>
> I'll have a quick look at this and see what falls out....

Okay.

Many of these paths are not using an allocator worker (userdata==0)
and/or the loops are done within a new transaction.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
