Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 528DA7F94
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 10:27:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22AB1304039
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 08:27:32 -0800 (PST)
Received: from 10.mo174.mail-out.ovh.net (10.mo174.mail-out.ovh.net
	[46.105.58.75]) by cuda.sgi.com with ESMTP id eHmhasQEoC4a0zck
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 08:13:14 -0800 (PST)
Received: from ex2.OVH.local (corp.ovh.com [5.196.251.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mo174.mail-out.ovh.net (Postfix) with ESMTPS id 59FBBFF828C
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 17:13:13 +0100 (CET)
Message-ID: <56CC852F.7010507@corp.ovh.com>
Date: Tue, 23 Feb 2016 17:13:35 +0100
From: Jean-Tiare Le Bigot <jean-tiare.le-bigot@corp.ovh.com>
MIME-Version: 1.0
Subject: backport 7a29ac474a47eb8cf212b45917683ae89d6fa13b to stable ?
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

We've hit kernel hang related to XFS reclaim under heavy I/O load on a
couple of storage servers using XFS over flashcache over a 3.13.y kernel.

On the crash dumps, kthreadd is blocked, waiting for XFS to reclaim some
memory but the related reclaim job is queued on a worker_pool stuck
waiting for some I/O, itself depending on other jobs on other queues
which would require additional threads to go forward. Unfortunately
kthreadd is blocked.
The host has plenty of memory (~128GB), about 80% of which being used
for the page cache.

It looks like this is fixed by commit
7a29ac474a47eb8cf212b45917683ae89d6fa13b. We manually applied a fix to
our internal branch but I could not find a similar commit on the
longterm branches. Maybe it could be a good candidate for backport for
other users ?

On linux-3.14.y, this would be

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d971f49..36af881 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -858,17 +858,17 @@ xfs_init_mount_workqueues(
                goto out_destroy_unwritten;

        mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-                       0, 0, mp->m_fsname);
+                       WQ_MEM_RECLAIM, 0, mp->m_fsname);
        if (!mp->m_reclaim_workqueue)
                goto out_destroy_cil;

        mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-                       0, 0, mp->m_fsname);
+                       WQ_MEM_RECLAIM, 0, mp->m_fsname);
        if (!mp->m_log_workqueue)
                goto out_destroy_reclaim;

        mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-                       0, 0, mp->m_fsname);
+                       WQ_MEM_RECLAIM, 0, mp->m_fsname);
        if (!mp->m_eofblocks_workqueue)
                goto out_destroy_log;

Regards,

-- 
Jean-Tiare Le Bigot, OVH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
