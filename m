Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE6FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiLaCjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiLaCjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:39:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C6D2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:39:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2A1961CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658AEC433D2;
        Sat, 31 Dec 2022 02:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454347;
        bh=J9RYt16ZmbTbvNEa+O3+ANGGiqe1oWrOIjmuXlMgFkg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FjwsCpWgepS4t6jfw6gDwDe0tPcgtg+UA8jf4CHQqZJA+N1BvSHxujAdy6Yvh5YAO
         YBNw4hHmVdewwjX4/9537SzfmsAc+LhTUNZT9HgdFkKxJixzL1ZvQMxx9znocxD6wq
         wmaFD5JBmaDD52+Y3E8dMalMuFTgIwokUzgq9ZcgzvtIrydIiKlFOWugJmInUCtYf/
         ZBv0d+r+K/5tSDDz77JA2dVaBmkuhPlqyYliFemMAyh/FkHR2aFYEhMkYBoWKauSWZ
         MK2bRNmE3yAuz/FJauaLIvqaoif5szkI0OR8COJcn2TCic0tpjzPKH8dIfIHhDQxb6
         x/K1Qi2mGzQ+A==
Subject: [PATCH 35/45] xfs_mdrestore: restore rt group superblocks to realtime
 device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878823.731133.6732858030193291234.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support restoring realtime device metadata to the realtime device, if
the dumped filesystem had one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_mdrestore.8  |    7 +++++++
 mdrestore/xfs_mdrestore.c |   30 ++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 4626b98e749..4a6b335a380 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -7,6 +7,8 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B \-gi
 ] [
 .B \-l logdev
+] [
+.B \-R rtdev
 ]
 .I source
 .I target
@@ -15,6 +17,8 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B \-i
 [
 .B \-l logdev
+] [
+.B \-R rtdev
 ]
 .I source
 .br
@@ -57,6 +61,9 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
+.B \-R
+Restore realtime device metadata to this device.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 672010bcc6e..b75b30830ea 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -115,7 +115,8 @@ perform_restore(
 	int			dst_fd,
 	int			is_target_file,
 	const struct xfs_metablock	*mbp,
-	char			*log_path)
+	char			*log_path,
+	char			*rtdev_path)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -127,7 +128,7 @@ perform_restore(
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
 	int64_t			mb_read = 0;
-	int			log_fd = -1;
+	int			log_fd = -1, rtdev_fd = -1;
 	bool			is_mdx;
 
 	is_mdx = mbp->mb_magic == cpu_to_be32(XFS_MDX_MAGIC);
@@ -201,9 +202,19 @@ perform_restore(
 			write_fd = log_fd;
 		}
 		if (metablock->mb_info & XFS_METADUMP_RTDEV) {
+			int rtdev_is_file;
+
 			if (!is_mdx)
 				fatal("rtdev set on an old style metadump?\n");
-			fatal("rtdev not supported\n");
+			if (rtdev_fd == -1) {
+				if (!rtdev_path)
+					fatal(
+	"metadump has rtdev contents but -R was not specified?\n");
+				rtdev_fd = open_device(rtdev_path, &rtdev_is_file);
+				check_dev(rtdev_fd, rtdev_is_file,
+						sb.sb_rblocks * sb.sb_blocksize);
+			}
+			write_fd = rtdev_fd;
 		}
 
 		if (show_progress) {
@@ -267,6 +278,8 @@ perform_restore(
 	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
+	if (rtdev_fd >= 0)
+		close(rtdev_fd);
 	if (log_fd >= 0)
 		close(log_fd);
 
@@ -276,7 +289,7 @@ perform_restore(
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] [-R rtdev] source target\n", progname);
 	exit(1);
 }
 
@@ -286,6 +299,7 @@ main(
 	char 		**argv)
 {
 	char		*log_path = NULL;
+	char		*rtdev_path = NULL;
 	FILE		*src_f;
 	int		dst_fd;
 	int		c;
@@ -294,7 +308,7 @@ main(
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "gl:iV")) != EOF) {
+	while ((c = getopt(argc, argv, "gl:iVR:")) != EOF) {
 		switch (c) {
 			case 'g':
 				show_progress = 1;
@@ -308,6 +322,9 @@ main(
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
+			case 'R':
+				rtdev_path = optarg;
+				break;
 			default:
 				usage();
 		}
@@ -363,7 +380,8 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	perform_restore(src_f, dst_fd, is_target_file, &mb, log_path);
+	perform_restore(src_f, dst_fd, is_target_file, &mb, log_path,
+			rtdev_path);
 
 	close(dst_fd);
 	if (src_f != stdin)

