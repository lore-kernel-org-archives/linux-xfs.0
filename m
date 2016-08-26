Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8881A7CA3
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 14:03:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA8E4AC001
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 12:03:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8anI3GFA4zmwrgta for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2016 12:03:26 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 57AF34A1
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 14:03:26 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs_db: properly set dquot_buf when operating on dquot
Message-ID: <d2abfb81-38d2-3f00-fea9-8a405664dea1@sandeen.net>
Date: Fri, 26 Aug 2016 14:03:25 -0500
MIME-Version: 1.0
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

The earlier commit:

66a40d02 db: verify and calculate dquot CRCs

added a "dquot_buf" to the iocur to specify when we were operating
on a dquot and thus handle dquot CRC updates - but nothing ever
actually set dquot_buf to a non-zero value.

Without doing so, we don't recalculate the dquot crc when
changing contents of a dquot:

# xfs_db -x -c "dquot -u 500" -c "p crc" -c "write diskdq.bcount 2" \
	    -c "p crc" crctestfile
crc = 0xfd293c68 (correct)
diskdq.bcount = 2
crc = 0xfd293c68 (correct)

[ the "(correct)" tag is another, different issue ]

# xfs_db -x -c "dquot -u 500" -c "p crc" crctestfile
Metadata CRC error detected at xfs_dquot block 0xd8/0x1000
crc = 0xfd293c68 (bad)

With this change, dquot CRCs are properly recalculated in write_cur.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/dquot.c b/db/dquot.c
index 47740f0..061eca5 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -164,6 +164,7 @@ dquot_f(
 	}
 	set_cur(&typtab[TYP_DQBLK], XFS_FSB_TO_DADDR(mp, bm.startblock), blkbb,
 		DB_RING_IGN, NULL);
+	iocur_top->dquot_buf = 1;
 	off_cur(qoff * (int)sizeof(xfs_dqblk_t), sizeof(xfs_dqblk_t));
 	ring_add();
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
