Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4AA457F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 12:02:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 34A338F8033
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 10:02:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Yk7xD3g7AnUpTVCd for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 10:02:11 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D379761A5851
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 12:02:10 -0500 (CDT)
Message-ID: <540C8F92.5050704@sandeen.net>
Date: Sun, 07 Sep 2014 12:02:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 6/5] xfs_repair: don't re-add root dotdot if root dir was
	rebuilt
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If we've rebuilt the root directory, ".." was taken
care of, so clear need_root_dotdot.

Otherwise it will be added twice, and a subsequent repair
will say:

  entry ".." (ino 5824) in dir 5824 is a duplicate name, would junk entry

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(sorry for 6/5, this just popped out and is similar to the
patch 3/5 I just sent, so probably worth doing at the same time.

diff --git a/repair/phase6.c b/repair/phase6.c
index cc36a9c..2e67c60 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2294,6 +2297,9 @@ out_fix:
  		 */
  		if (*need_dot)
  			add_inode_ref(irec, ino_offset);
+		/* If we rebuilt the root dir, dot dot is in good shape */
+		if (ino == mp->m_sb.sb_rootino)
+			need_root_dotdot = 0;
  		*num_illegal = 0;
  		*need_dot = 0;
  	} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
