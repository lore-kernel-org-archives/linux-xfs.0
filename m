Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E55777F51
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 13:14:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE8408F8065
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 11:14:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cHBeGXgijvdegkrU for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 11:14:00 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s23JDxYw028404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2014 14:14:00 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s23JDwLI004584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2014 14:13:59 -0500
Message-ID: <5314D476.7030503@redhat.com>
Date: Mon, 03 Mar 2014 13:13:58 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix array overrun in do_inode_prefetch
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
To: xfs-oss <xfs@oss.sgi.com>

Coverity spotted this:

do_inode_prefetch() does a while loop, creating queues:

        for (i = 0; i < thread_count; i++) {
		...
		create_work_queue(&queues[i], mp, 1);
		...
	}

and then does this to wait for them all to complete:

	for (; i >= 0; i--)
 		destroy_work_queue(&queues[i]);

But we leave the first for loop with (i == thread_coun)t, and
the second one will try to index queues[] one past the end.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 0f9e3fe..e47a48e 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -995,7 +995,7 @@ do_inode_prefetch(
 	/*
 	 * wait for workers to complete
 	 */
-	for (; i >= 0; i--)
+	while (i--)
 		destroy_work_queue(&queues[i]);
 	free(queues);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
