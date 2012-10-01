Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91HqdwE169867 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 12:52:39 -0500
Date: Mon, 1 Oct 2012 12:54:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07/13] xfs: syncd workqueue is no more
Message-ID: <20121001175402.GL13214@sgi.com>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-8-git-send-email-david@fromorbit.com>
	<5065E9A3.3040707@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5065E9A3.3040707@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 28, 2012 at 01:17:07PM -0500, Mark Tinguely wrote:
> On 09/27/12 23:44, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >With the syncd functions moved to the log and/or removed, the syncd
> >workqueue is the only remaining bit left. It is used by the log
> >covering/ail pushing work, as well as by the inode reclaim work.
> >
> >Given how cheap workqueues are these days, give the log and inode
> >reclaim work their own work queues and kill the syncd work queue.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> <deleted info>
> 
> >diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >index fed1eb2..65cf42c 100644
> >--- a/fs/xfs/xfs_super.c
> >+++ b/fs/xfs/xfs_super.c
> >@@ -776,8 +776,23 @@ xfs_init_mount_workqueues(
> >  			WQ_MEM_RECLAIM, 0, mp->m_fsname);
> >  	if (!mp->m_cil_workqueue)
> >  		goto out_destroy_unwritten;
> >+
> >+	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
> >+			WQ_NON_REENTRANT, 0, mp->m_fsname);
> >+	if (!mp->m_reclaim_workqueue)
> >+		goto out_destroy_cil;
> >+
> >+	mp->m_log_workqueue = alloc_workqueue("xfs-reclaim/%s",
> >+			WQ_NON_REENTRANT, 0, mp->m_fsname);

Changed this to "xfs-log/%s" on Dave's behalf.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
