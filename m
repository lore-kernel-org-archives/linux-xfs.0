Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58JWkBo248860 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 14:32:46 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XUAPncq3i89GfO12 for
	<xfs@oss.sgi.com>; Fri, 08 Jun 2012 12:32:45 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q58JWiI3009968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 15:32:44 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q58JWg5B009639
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 15:32:44 -0400
Message-ID: <4FD2535A.3050302@redhat.com>
Date: Fri, 08 Jun 2012 14:32:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: use INIT_WORK_ONSTACK in xfs_alloc_vextent()
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
To: xfs-oss <xfs@oss.sgi.com>

w/o this change I was getting:

[  742.376495] ODEBUG: object is on stack, but not annotated
[  742.377007] ------------[ cut here ]------------
[  742.377007] WARNING: at lib/debugobjects.c:302 __debug_object_init+0x1c0/0x3d0()
...
[  742.377007] Call Trace:
[  742.377007]  [<ffffffff81060dbf>] warn_slowpath_common+0x7f/0xc0
[  742.377007]  [<ffffffff81060e1a>] warn_slowpath_null+0x1a/0x20
[  742.377007]  [<ffffffff81336640>] __debug_object_init+0x1c0/0x3d0
[  742.377007]  [<ffffffff8133689f>] debug_object_init+0x1f/0x30
[  742.377007]  [<ffffffff81081cd9>] __init_work+0x19/0x30
[  742.377007]  [<ffffffffa0299f81>] xfs_alloc_vextent+0x101/0x190 [xfs]

on a debug 3.4 kernel.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I think it's right?  :)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0f0df27..0be396d 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2443,7 +2443,7 @@ xfs_alloc_vextent(
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	args->done = &done;
-	INIT_WORK(&args->work, xfs_alloc_vextent_worker);
+	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
 	return args->result;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
