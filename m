Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EEnj8L130989 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:49:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49A94DD9EE3
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 08:02:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Lv6LW7zjzR2Wm6G4 for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 08:02:20 -0700 (PDT)
Date: Tue, 14 Sep 2010 10:50:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/18] xfs: lockless per-ag lookups
Message-ID: <20100914145034.GD3400@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-5-git-send-email-david@fromorbit.com>
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

On Tue, Sep 14, 2010 at 08:56:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we start taking a reference to the per-ag for every cached
> buffer in the system, kernel lockstat profiling on an 8-way create
> workload shows the mp->m_perag_lock has higher acquisition rates
> than the inode lock and has significantly more contention. That is,
> it becomes the highest contended lock in the system.
> 
> The perag lookup is trivial to convert to lock-less RCU lookups
> because perag structures never go away. Hence the only thing we need
> to protect against is tree structure changes during a grow. THis can
> be done simply by replacing the locking in xfs_perag_get() with RCU
> read locking. This removes the mp->m_perag_lock completely from this
> path.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
