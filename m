Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 224CC29E40
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:20:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02EF0304032
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:20:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Vdu9veHtRykEKJAH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:57 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 881B12FE845
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvA9031595
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 11/18] xfs_repair: seed the max lsn from log state in phase
	2
Date: Fri,  2 Oct 2015 14:19:48 -0400
Message-Id: <1443809995-20395-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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

At this point, the log state is always available once repair has
progressed through phase 2 and the log is only ever zeroed when
absolutely necessary. This means that in the common case, repair runs
with the log in a non-initialized state. The libxfs max metadata LSN
tracking initializes the max LSN to zero, however, which will require
updates throughout the repair process even if all metadata LSNs are
behind the current LSN.

Since all metadata LSNs that are behind the current LSN are valid, seed
the libxfs maximum seen LSN value with the log state from phase 2. This
is a minor optimization to minimize global variable updates in the
common case where all (or most) metadata LSNs are valid.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/repair/phase2.c b/repair/phase2.c
index fe7ed2b..f9d0e22 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -126,6 +126,13 @@ zero_log(
 		if (error || head_blk != tail_blk)
 			do_error(_("failed to clear log"));
 	}
+
+	/*
+	 * Finally, seed the max LSN from the current state of the log if this
+	 * is a v5 filesystem.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		libxfs_max_lsn = log->l_last_sync_lsn;
 }
 
 /*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
