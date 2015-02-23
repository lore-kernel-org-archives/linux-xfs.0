Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCD6F7F4E
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 09:51:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB6468F8049
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 07:51:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xoCrWEjPqJQ66rRi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 07:51:52 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1NFppQc018334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1NFppOt020412
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 10:51:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] metadump: include NULLFSINO check in inode copy code
Date: Mon, 23 Feb 2015 10:51:46 -0500
Message-Id: <1424706709-21594-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
References: <1424706709-21594-1-git-send-email-bfoster@redhat.com>
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

The copy_ino() function includes a check for effectively NULL inode
numbers. It checks for 0 but does not include NULLFSINO. This leads to
spurious warnings in some instances. For example, copy_ino() is called
unconditionally for sb quota inodes from copy_sb_inodes(), values of
which can be NULLFSINO.

Check for NULLFSINO and return quietly from copy_ino().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/metadump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3eafac6..604fcf4 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2112,7 +2112,7 @@ copy_ino(
 	int			offset;
 	int			rval = 0;
 
-	if (ino == 0)
+	if (ino == 0 || ino == NULLFSINO)
 		return 1;
 
 	agno = XFS_INO_TO_AGNO(mp, ino);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
