Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D1F07F57
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 11:41:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 279028F8033
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 09:41:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KMGNXqrm9647AgSR for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 09:41:06 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/5] xfs_repair: fix dir refcount when '.' missing and dir is
	rebuilt
Date: Sun,  7 Sep 2014 11:41:03 -0500
Message-Id: <1410108065-18156-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In phase 6's longform_dir2_entry_check, if we never
find a '.' entry we never add a reference to that entry;
if we subsequently rebuild it, '.' gets added, but
no ref to it is ever made.  This leads to Phase 7 doing
i.e.:

  Phase 7 - verify and correct link counts...
  resetting inode 5184 nlinks from 2 to 1

and the next run will do:

  Phase 7 - verify and correct link counts...
  resetting inode 5184 nlinks from 1 to 2

So if '.' was never found, but the directory got
rebuilt, manually add the ref for it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/phase6.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index f13069f..cc36a9c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2288,6 +2288,12 @@ out_fix:
 			if (bplist[i])
 				libxfs_putbuf(bplist[i]);
 		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
+		/*
+		 * If we didn't find a dot, we never added a ref for it;
+		 * it's there now after the rebuild, so mark it as reached.
+		 */
+		if (*need_dot)
+			add_inode_ref(irec, ino_offset);
 		*num_illegal = 0;
 		*need_dot = 0;
 	} else {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
