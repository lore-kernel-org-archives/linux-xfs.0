Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 22:09:15 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1969BC7006141
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 22:09:12 -0800
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C446F5B9E4B
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 22:09:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id qAkjqTLZJdcy2oyS for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 22:09:34 -0800 (PST)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m195jsUY028495
	for <xfs@oss.sgi.com>; Sat, 9 Feb 2008 00:45:54 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m195jstU007078
	for <xfs@oss.sgi.com>; Sat, 9 Feb 2008 00:45:54 -0500
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m195jrh1027192
	for <xfs@oss.sgi.com>; Sat, 9 Feb 2008 00:45:53 -0500
Message-ID: <47AD3E11.7020608@redhat.com>
Date: Fri, 08 Feb 2008 23:45:53 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] recover from iclog allocation failures
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

A user in #xfs had some strange thing hogging up vmalloc
space, and after mounting several xfs filesystems with 
aggressive log memory usage, started hitting vmalloc failures 
which led to an oops.

I inserted a fake failure at i=3 in the iclog alloc loop, and 
this patch let me exit with a graceful "ENOMEM" instead of an 
oops.

Also, somehow the use of "uuid_mounted" has gone stale; after
the graceful mount failure, I got dup uuid errors on the next
mount.  This patch fixes that problem as well.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

Index: linux-2.6.24.noarch/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.24.noarch.orig/fs/xfs/xfs_log.c
+++ linux-2.6.24.noarch/fs/xfs/xfs_log.c
@@ -513,6 +513,8 @@ xfs_log_mount(xfs_mount_t	*mp,
 	}
 
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
+	if (!mp->m_log)
+		return ENOMEM;
 
 	/*
 	 * skip log recovery on a norecovery mount.  pretend it all
@@ -1219,6 +1221,13 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		prev_iclog = iclog;
 
 		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
+		if (!iclog || !bp) {
+			if (iclog)
+				kmem_free(iclog, sizeof(xlog_in_core_t));
+			log->l_iclog_bufs = i;
+			xlog_dealloc_log(log);
+			return NULL;
+		}
 		if (!XFS_BUF_CPSEMA(bp))
 			ASSERT(0);
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
Index: linux-2.6.24.noarch/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.24.noarch.orig/fs/xfs/xfs_mount.c
+++ linux-2.6.24.noarch/fs/xfs/xfs_mount.c
@@ -1007,6 +1007,7 @@ xfs_mountfs(
 			error = XFS_ERROR(EINVAL);
 			goto error1;
 		}
+		uuid_mounted = 1;
 	}
 
 	/*
