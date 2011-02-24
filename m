Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OLxNEo162459 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 15:59:23 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A44E2FABD1
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 14:02:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5Nj0SZGXRKHjwZOB for
	<xfs@oss.sgi.com>; Thu, 24 Feb 2011 14:02:08 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1OM28YN029164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 17:02:08 -0500
Message-ID: <4D66D55E.8070209@redhat.com>
Date: Thu, 24 Feb 2011 16:02:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfstests: fix fiemap-tester for fewer extents returned
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
To: xfs mailing list <xfs@oss.sgi.com>
Cc: Josef Bacik <jbacik@redhat.com>

If the fiemap call returns fewer extents than asked for,
the fiemap tester gets confused.  If this happens, advance,
and call fiemap again for the next offset.

XFS exposed this because if a file is all-delalloc, it was
only returning 1 mapped extent (this is probably also a buglet).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index f6875af..53d7a64 100644
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -467,8 +467,10 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize)
 		for (i = cur_extent, c = 1; i < blocks; i++, c++) {
 			__u64 logical_offset = i * blocksize;
 
-			if (c > blocks_to_map)
+			if (c > fiemap->fm_mapped_extents) {
+				i++;
 				break;
+			}
 
 			switch (map[i]) {
 			case 'D':

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
