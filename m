Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 01:43:40 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T8hYqK023961
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 01:43:36 -0700
Message-ID: <48E097B5.3010906@sgi.com>
Date: Mon, 29 Sep 2008 18:54:13 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Increase the default size of the reserved blocks pool
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

The current default size of the reserved blocks pool is easy to deplete
with certain workloads, in particular workloads that do lots of concurrent
delayed allocation extent conversions.  If enough transactions are running
in parallel and the entire pool is consumed then subsequent calls to
xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
warning so we know if this starts happening again.

--- a/fs/xfs/xfs_mount.c	2008-09-29 18:30:26.000000000 +1000
+++ b/fs/xfs/xfs_mount.c	2008-09-29 18:27:37.000000000 +1000
@@ -1194,7 +1194,7 @@ xfs_mountfs(
 	 */
 	resblks = mp->m_sb.sb_dblocks;
 	do_div(resblks, 20);
-	resblks = min_t(__uint64_t, resblks, 1024);
+	resblks = min_t(__uint64_t, resblks, 16384);
 	error = xfs_reserve_blocks(mp, &resblks, NULL);
 	if (error)
 		cmn_err(CE_WARN, "XFS: Unable to allocate reserve blocks. "
@@ -1483,6 +1483,7 @@ xfs_mod_incore_sb_unlocked(
 	int		scounter;	/* short counter for 32 bit fields */
 	long long	lcounter;	/* long counter for 64 bit fields */
 	long long	res_used, rem;
+	static int	depleted = 0;
 
 	/*
 	 * With the in-core superblock spin lock held, switch
@@ -1535,6 +1536,9 @@ xfs_mod_incore_sb_unlocked(
 				if (rsvd) {
 					lcounter = (long long)mp->m_resblks_avail + delta;
 					if (lcounter < 0) {
+						if ((depleted % 100) == 0)
+							printk(KERN_DEBUG "XFS reserved blocks pool depleted.\n");
+						depleted++;
 						return XFS_ERROR(ENOSPC);
 					}
 					mp->m_resblks_avail = lcounter;
