Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D700F7CA1
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:24:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81A5730404E
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:57 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PRGnX390v3uGKf3a (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:54 -0700 (PDT)
Subject: [PATCH 4/7] libxcmd: fix mount option parsing to find rt/log devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:24:50 -0700
Message-ID: <147200548998.15538.11330546457799095768.stgit@birch.djwong.org>
In-Reply-To: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

It turns out that glibc's hasmntopt implementation returns NULL
if the opt parameter ends with an equals ('=').  Therefore, we
cannot directly search for the option 'rtdev='; we must instead
have hasmntopt look for 'rtdev' and look for the trailing equals
sign ourselves.  This fixes xfs_info's reporting of external
log and realtime device paths, and xfs_scrub will need it for
data block scrubbing of realtime extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxcmd/paths.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 71af25f..b08985f 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -234,10 +234,17 @@ fs_extract_mount_options(
 {
 	char		*fslog, *fsrt;
 
-	/* Extract log device and realtime device from mount options */
-	if ((fslog = hasmntopt(mnt, "logdev=")))
+	/*
+	 * Extract log device and realtime device from mount options.
+	 *
+	 * Note: the glibc hasmntopt implementation requires that the
+	 * character in mnt_opts immediately after the search string
+	 * must be a NULL ('\0'), a comma (','), or an equals ('=').
+	 * Therefore we cannot search for 'logdev=' directly.
+	 */
+	if ((fslog = hasmntopt(mnt, "logdev")) && fslog[6] == '=')
 		fslog += 7;
-	if ((fsrt = hasmntopt(mnt, "rtdev=")))
+	if ((fsrt = hasmntopt(mnt, "rtdev")) && fsrt[5] == '=')
 		fsrt += 6;
 
 	/* Do this only after we've finished processing mount options */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
