Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34342 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbdAZBFW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 20:05:22 -0500
Subject: [PATCH v9 1/5] xfs_db: sanitize agcount on load
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
 <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
 <17bbf8d4-39f7-a542-6c9d-3cd96e865ddf@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <886473a5-c0ff-a5b7-38bc-13d4d5d13c3c@sandeen.net>
Date: Wed, 25 Jan 2017 19:05:20 -0600
MIME-Version: 1.0
In-Reply-To: <17bbf8d4-39f7-a542-6c9d-3cd96e865ddf@sandeen.net>
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

Teach metadump to detect this and exit appropriately if truncated.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

v1->v6: Tale of woe.
v7: blow it all up
v8: use bare libxfs_readbuf so verifiers don't matter,
    "ours goes to 1 million!"
v9: Fix printf format, exit metadump with error if things look wonky.

diff --git a/db/metadump.c b/db/metadump.c
index 1ba6b38..d307771 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2760,6 +2760,16 @@ metadump_f(
 		return 0;
 	}
 
+	/*
+	 * on load, we sanity-checked agcount and possibly set to 1
+	 * if it was corrupted and large.
+	 */
+	if (mp->m_sb.sb_agcount == 1 &&
+	    XFS_MAX_DBLOCKS(&mp->m_sb) < mp->m_sb.sb_dblocks) {
+		print_warning("truncated agcount, giving up");
+		return 0;
+	}
+
 	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
 		switch (c) {
 			case 'a':
diff --git a/libxfs/init.c b/libxfs/init.c
index a08575a..85e0d15 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -817,6 +817,29 @@ libxfs_mount(
 			return NULL;
 	}
 
+	/*
+	 * libxfs_initialize_perag will allocate a perag structure for each ag.
+	 * If agcount is corrupted and insanely high, this will OOM the box.
+	 * If the agount seems (arbitrarily) high, try to read what would be
+	 * the last AG, and if that fails for a relatively high agcount, just
+	 * read the first one and let the user know to check the geometry.
+	 */
+	if (sbp->sb_agcount > 1000000) {
+		bp = libxfs_readbuf(mp->m_dev,
+				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
+				!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
+		if (bp->b_error) {
+			fprintf(stderr, _("%s: read of AG %u failed\n"),
+						progname, sbp->sb_agcount);
+			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+				return NULL;
+			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
+								progname);
+			sbp->sb_agcount = 1;
+		}
+		libxfs_putbuf(bp);
+	}
+
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
 		fprintf(stderr, _("%s: perag init failed\n"),

