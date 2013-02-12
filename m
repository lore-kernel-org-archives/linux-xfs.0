Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 584E17F8D
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 05:07:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E0638F8033
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:07:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jbXa21DmOaxnweXZ for
	<xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:07:00 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1CB6xoL026373
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 06:06:59 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs_mkfs: wipe old signatures from the device
Date: Tue, 12 Feb 2013 12:06:55 +0100
Message-Id: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
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
Cc: sandeen@redhat.com, kzak@redhat.com, Lukas Czerner <lczerner@redhat.com>

We should wipe off all the signatures from the device prior the file
system creation. It is because because some file systems (btrfs) may
still have their signatures on the device which can be confusing for
userspace possibly resulting in the unmountable file system.

This patch adds a function which uses libblkid library to wipe all the
signatures from the device.

If user disables libblkid library or does not have it installed this new
feature will not be used. This case can be implemented separately.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 mkfs/xfs_mkfs.c |  134 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 97 insertions(+), 37 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d636549..a889620 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -286,18 +286,73 @@ calc_stripe_factors(
 }
 
 #ifdef ENABLE_BLKID
+static int
+wipe_signatures(
+	char		*device,
+	int		dryrun)
+{
+	blkid_probe	pr = NULL;
+	int		ret = 0;
+	int		fd;
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		goto out;
+
+	fd = open(device, O_RDWR|O_CLOEXEC);
+	if (fd < 0) {
+		ret = -1;
+		goto out;
+	}
+	ret = blkid_probe_set_device(pr, fd, 0, 0);
+	if (ret)
+		goto out;
+
+	/* No need to check return values we know that 'pr' is initialized */
+	blkid_probe_enable_partitions(pr, 1);
+	blkid_probe_enable_superblocks(pr, 1);
+	blkid_probe_set_partitions_flags(pr, BLKID_PARTS_MAGIC);
+	blkid_probe_set_superblocks_flags(pr,
+					BLKID_SUBLKS_MAGIC | BLKID_SUBLKS_TYPE);
+
+	while (1) {
+		ret = blkid_do_probe(pr);
+		if (ret != 0)
+			break;
+
+		/* Wipe off the signature */
+		ret = blkid_do_wipe(pr, dryrun);
+		if (ret)
+			break;
+	}
+	close(fd);
+
+out:
+	if (pr)
+		blkid_free_probe(pr);
+	if (ret < 0)
+		fprintf(stderr,
+			_("%s: Cannot wipe off existing signatures\n"), progname);
+	return (ret < 0 ? ret : 0);
+}
+
 /*
  * Check for existing filesystem or partition table on device.
  * Returns:
  *	 1 for existing fs or partition
  *	 0 for nothing found
  *	-1 for internal error
+ * If wipe is set, we'll attempt to wipe of all the signatures from
+ * the device. In this case we never return 1 (existing fs or partition).
  */
 static int
 check_overwrite(
-	char		*device)
+	char		*device,
+	int		wipe,
+	int		dryrun)
 {
 	const char	*type;
+	const char	*name;
 	blkid_probe	pr = NULL;
 	int		ret;
 	int		fd;
@@ -325,40 +380,43 @@ check_overwrite(
 	if (!pr)
 		goto out;
 
-	ret = blkid_probe_enable_partitions(pr, 1);
-	if (ret < 0)
-		goto out;
+	/* No need to check return values we know that 'pr' is initialized */
+	blkid_probe_enable_partitions(pr, 1);
+	blkid_probe_enable_superblocks(pr, 1);
+	blkid_probe_set_partitions_flags(pr, BLKID_PARTS_MAGIC);
+	blkid_probe_set_superblocks_flags(pr,
+					BLKID_SUBLKS_MAGIC | BLKID_SUBLKS_TYPE);
 
-	ret = blkid_do_fullprobe(pr);
-	if (ret < 0)
-		goto out;
+	ret = 0;
+	while (1) {
+		int retval = 0;
 
-	/*
-	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
-	 * but we want the exact opposite, so reverse the return value here.
-	 *
-	 * In addition print some useful diagnostics about what actually is
-	 * on the device.
-	 */
-	if (ret) {
-		ret = 0;
-		goto out;
-	}
+		retval = blkid_do_probe(pr);
+		if (retval != 0) {
+			ret = retval;
+			break;
+		}
 
-	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
-		fprintf(stderr,
-			_("%s: %s appears to contain an existing "
-			"filesystem (%s).\n"), progname, device, type);
-	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
-		fprintf(stderr,
-			_("%s: %s appears to contain a partition "
-			"table (%s).\n"), progname, device, type);
-	} else {
-		fprintf(stderr,
-			_("%s: %s appears to contain something weird "
-			"according to blkid\n"), progname, device);
+		if (blkid_probe_lookup_value(pr, "TYPE", &type, NULL) == 0)
+			name = "filesystem";
+
+		else if (blkid_probe_lookup_value(pr, "PTTYPE",
+						    &type, NULL) == 0)
+			name = "partition table";
+		else
+			continue;
+
+		if (wipe)
+			fprintf(stderr, _("%s: Wiping off %s signature.\n"),
+				progname, type);
+		else {
+			fprintf(stderr,
+				_("%s: %s appears to contain an existing "
+				"%s (%s).\n"), progname, device, name, type);
+			ret = 1;
+			continue;
+		}
 	}
-	ret = 1;
 
 out:
 	if (pr)
@@ -367,6 +425,8 @@ out:
 		fprintf(stderr,
 			_("%s: probe of %s failed, cannot detect "
 			  "existing filesystem.\n"), progname, device);
+	if (ret == 1 && wipe)
+		ret = wipe_signatures(device, dryrun);
 	return ret;
 }
 
@@ -464,7 +524,8 @@ static void get_topology(
 #else /* ENABLE_BLKID */
 static int
 check_overwrite(
-	char		*device)
+	char		*device,
+	int		wipe)
 {
 	char		*type;
 
@@ -1939,16 +2000,15 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	xi.rtsize &= sector_mask;
 	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
 
-	if (!force_overwrite) {
-		if (check_overwrite(dfile) ||
-		    check_overwrite(logfile) ||
-		    check_overwrite(xi.rtname)) {
+	if (check_overwrite(dfile, force_overwrite, Nflag) ||
+	    check_overwrite(logfile, force_overwrite, Nflag) ||
+	    check_overwrite(xi.rtname, force_overwrite, Nflag))
+		if (force_overwrite) {
 			fprintf(stderr,
 			_("%s: Use the -f option to force overwrite.\n"),
 				progname);
 			exit(1);
 		}
-	}
 
 	if (discard) {
 		discard_blocks(xi.ddev, xi.dsize);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
