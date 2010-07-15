Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FI6808216310 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:06:08 -0500
Subject: Re: [PATCH 3/5] xfs: fix xfs_trans_add_item() lockdep warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279154300-2018-4-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-4-git-send-email-david@fromorbit.com>
Date: Thu, 15 Jul 2010 13:09:01 -0500
Message-ID: <1279217341.2054.33.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, 2010-07-15 at 10:38 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans_add_item() is called with ip->i_ilock held, which means it
> is unsafe for memory reclaim to recurse back into the filesystem
> (ilock is required in writeback). Hence the allocation needs to be
> KM_NOFS to avoid recursion.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Lockdep report indicating memory allocation being called with the
> ip->i_ilock held is as follows:
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
