Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 133AC7F52
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 12:35:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DEC65304051
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 10:35:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bpF7UWqPbHX6Z0Xm for
	<xfs@oss.sgi.com>; Mon, 07 Oct 2013 10:35:19 -0700 (PDT)
Message-ID: <5252F0D4.8090209@redhat.com>
Date: Mon, 07 Oct 2013 12:35:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove incorrect l_sectBBsize assignment in
	xfs_repair
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
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>

Commit e0607266 xfsprogs: add crc format support to repair

added a 2nd assignment to l_sectBBsize:

	log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;

which is incorrect; sb_logsectlog is log2 of the sector size,
in bytes; l_sectBBsize is the size of the log sector in
512-byte units.

So for a 4k sector size log, we were assigning 4096 rather
than 8.  This broke xlog_find_tail, and caused xfs_repair
to think that a log was dirty even when it was clean:

"ERROR: The filesystem has valuable metadata changes in a log"

(xfs_logprint didn't have this error, so xfs_logprint -t
agreed that the filesystem really was clean).

Just remove the incorrect assignment; it was already properly
assigned about 12 lines prior:

        log.l_sectBBsize  = BTOBB(x.lbsize);

and things work again.

(This worked accidentally for 512-sector devices, because
we special-case those and set sb_logsectlog to "0" rather
than 9, so l_sectBBsize came out to "1" (as in 1 sector),
as it should have).

Reporteed-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase2.c b/repair/phase2.c
index a62854e..2817fed 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -64,7 +64,6 @@ zero_log(xfs_mount_t *mp)
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
 	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
-	log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;
 
 	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
 		do_warn(_("zero_log: cannot find log head/tail "

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
