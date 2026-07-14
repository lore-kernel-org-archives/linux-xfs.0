Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C53C37E5D6
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 20:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784061137; cv=none; b=ij1WiZtcm/1CgXpyKUPN8hh1CHFtT2VxIcsbKhdX9ayW2fMZkzryw+zaj/pqaQZk/2hjCl5eyqsZjJGkZHJRSElCKWf7lUt4BkrI1ednj+TvHOEB8TmmGKCJlktXg+5Th0MLmzr/NTXmBFj/LRfbkU2DKJyC1aX2EY4436bAlrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784061137; c=relaxed/simple;
	bh=qhSG+S6qWF4R8afj1Gf5uzl9TnHibre+Ux97KllGku4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OgEqU16bgaw7mzITo680uRbpN2Zt7+5qmqPwhW5Tflo2A0chm4s35Xd44v1rjv64NRIHXP0vRtA9YRKsAwnMfa3iRbOSCk2oPgS4DGgpwz+zGWZwYpeQYwINXNvMKjYOYH2t7HwqXzLZJd/ol4/sNukEC3Fsaf7mgYirlvcr/30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4h09vs6RkJzMlJm;
	Tue, 14 Jul 2026 22:32:09 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: aalbersh@kernel.org
Cc: pankaj.raghav@linux.dev,
	hch@lst.de,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	gost.dev@samsung.com,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3] fiemap: add a nosync option
Date: Tue, 14 Jul 2026 22:32:06 +0200
Message-ID: <20260714203206.520348-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io/fiemap adds FIEMAP_FLAG_SYNC by default. There are some test cases
where adding this flag might have an undesired side effect on the
results [1].

Add an option that does not pass FIEMAP_FLAG_SYNC flag.

[1] https://lore.kernel.org/linux-xfs/ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com/

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Changes since v2:
- Add this option to the man page (Darrick)
- Add more information about this flag in the help.
Changes since v1:
- Change '-s' to '-e' to match xfs_bmap (Christoph).

 io/fiemap.c       | 9 +++++++--
 man/man8/xfs_io.8 | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index b41f71bf..cf3a1b3e 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -36,6 +36,7 @@ fiemap_help(void)
 " -a -- prints the attribute fork map instead of the data fork.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
+" -e -- obtains also delayed allocation extents by not using FIEMAP_FLAG_SYNC.\n"
 " -v -- Verbose information\n"
 " offset is the starting offset to map, and is optional.  If offset is\n"
 " specified, mapping length may (optionally) be specified as well."
@@ -242,7 +243,7 @@ fiemap_f(
 
 	init_cvtnum(&fsblocksize, &fssectsize);
 
-	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
+	while ((c = getopt(argc, argv, "aln:ev")) != EOF) {
 		switch (c) {
 		case 'a':
 			fiemap_flags |= FIEMAP_FLAG_XATTR;
@@ -253,6 +254,10 @@ fiemap_f(
 		case 'n':
 			max_extents = atoi(optarg);
 			break;
+		case 'e':
+			/* nosync */
+			fiemap_flags &= ~(FIEMAP_FLAG_SYNC);
+			break;
 		case 'v':
 			vflag++;
 			break;
@@ -393,7 +398,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
+	fiemap_cmd.args = _("[-alev] [-n nx] [offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 61defcc3..a3ddab02 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -353,7 +353,7 @@ Prints the block mapping for the current open file. Refer to the
 .BR xfs_bmap (8)
 manual page for complete documentation.
 .TP
-.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
+.BI "fiemap [ \-alev ] [ \-n " nx " ] [ " offset " [ " len " ]]"
 Prints the block mapping for the current open file using the fiemap
 ioctl.  Options behave as described in the
 .BR xfs_bmap (8)

base-commit: e80b048d87fdc5735e0d03ae29b497b402ea8bbe
-- 
2.51.2

