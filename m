Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EHSBD9138243 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 12:28:11 -0500
Subject: Re: [PATCH 04/18] xfs: lockless per-ag lookups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-5-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-5-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 12:28:47 -0500
Message-ID: <1284485327.2098.81.camel@doink>
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

Nice.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ag.h    |    3 +++
>  fs/xfs/xfs_mount.c |   25 +++++++++++++++++--------
>  2 files changed, 20 insertions(+), 8 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
