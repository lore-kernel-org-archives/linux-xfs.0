Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49980 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbdAXWxA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 17:53:00 -0500
Subject: [PATCH v7 1/5] xfs_db: sanitize agcount on load
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
Date: Tue, 24 Jan 2017 16:52:59 -0600
MIME-Version: 1.0
In-Reply-To: <20170123213108.GD31202@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Before we get into libxfs_initialize_perag and try to blindly
allocate a perag struct for every (possibly corrupted number of)
AGs, see if we can read the last one.  If not, assume it's corrupt,
and load only the first AG.

Do this only for an arbitrarily high-ish agcount, so that normal-ish
geometry on a possibly truncated file or device will still do
its best to make all readable AGs available.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/init.c b/libxfs/init.c
index a08575a..ca5101e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -817,6 +817,28 @@ libxfs_mount(
 			return NULL;
 	}
 
+	/*
+	 * libxfs_initialize_perag will allocate a perag structure for each AG.
+	 * If agcount is corrupted and insanely high, this will OOM the box.
+	 * If the agount seems (arbitrarily) high, try to read what would be
+	 * the last AG, and if that fails, just read the first one and let
+	 * the user know what happened.
+	 */
+	if (sbp->sb_agcount > 10000) {
+		error = xfs_read_agf(mp, NULL, sbp->sb_agcount - 1, 0, &bp);
+		if (error) {
+			fprintf(stderr, _("%s: read of AG %d failed\n"),
+						progname, sbp->sb_agcount);
+			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+				return NULL;
+			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
+								progname);
+			sbp->sb_agcount = 1;
+		}
+		if (bp)
+			libxfs_putbuf(bp);
+	}
+
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
 		fprintf(stderr, _("%s: perag init failed\n"),


