Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6F1C7EE2C
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbjFEPh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbjFEPhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CB9120
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7E4962175
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E4CC433D2;
        Mon,  5 Jun 2023 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979436;
        bh=MGmoxv3Wp0qimVeIpNCt2TJO7KYtNsKLOYhgGy31VGY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OMoO2VIap0Juy6Po22m7jzUOFl34fhTVh1ur4zqg4+lmFBvvjxCr33xE6+z+QTQ7W
         fTS7CwXs9c5QcWXnxPr9YNAo9Z/DB/LmoWr4BPUq5JMaEikO4JHN8F1Oe88Szcje3z
         qYc2jF2cZPON+ygmM/colEbw4SGBFHLM87pDDlVdhUKnpGl0Xczgcj/yeiBwWAnqBs
         DbFG2lmrr8ZbuRZZLDI3y/9GpcRMEqk4ybOGkzzrk4Rf3lEaLP7sbTLpGoExyRPCx/
         WRv2rXxjRmKMje3ai4LtgcRPOW4b5HYYkZIiYbKkwYb1z1AxaR/xHHvPKwqdiMV0R7
         nHuMq9r7vNobQ==
Subject: [PATCH 3/3] xfs_db: make the hash command print the dirent hash
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:15 -0700
Message-ID: <168597943560.1226265.697249744236069044.stgit@frogsfrogsfrogs>
In-Reply-To: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
References: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It turns out that the da and dir2 hashname functions are /not/ the same,
at least not on ascii-ci filesystems.  Enhance this debugger command to
support printing the dir2 hashname.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/hash.c         |   42 +++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_db.8 |    8 +++++++-
 2 files changed, 44 insertions(+), 6 deletions(-)


diff --git a/db/hash.c b/db/hash.c
index 79a250526e9..716da88baf9 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -18,9 +18,15 @@
 static int hash_f(int argc, char **argv);
 static void hash_help(void);
 
-static const cmdinfo_t hash_cmd =
-	{ "hash", NULL, hash_f, 1, 1, 0, N_("string"),
-	  N_("calculate hash value"), hash_help };
+static const cmdinfo_t hash_cmd = {
+	.name		= "hash",
+	.cfunc		= hash_f,
+	.argmin		= 1,
+	.argmax		= -1,
+	.args		= N_("string"),
+	.oneline	= N_("calculate hash value"),
+	.help		= hash_help,
+};
 
 static void
 hash_help(void)
@@ -43,9 +49,35 @@ hash_f(
 	char		**argv)
 {
 	xfs_dahash_t	hashval;
+	bool		use_dir2_hash = false;
+	int		c;
+
+	while ((c = getopt(argc, argv, "d")) != EOF) {
+		switch (c) {
+		case 'd':
+			use_dir2_hash = true;
+			break;
+		default:
+			exitcode = 1;
+			hash_help();
+			return 0;
+		}
+	}
+
+	for (c = optind; c < argc; c++) {
+		if (use_dir2_hash) {
+			struct xfs_name	xname = {
+				.name	= (uint8_t *)argv[c],
+				.len	= strlen(argv[c]),
+			};
+
+			hashval = libxfs_dir2_hashname(mp, &xname);
+		} else {
+			hashval = libxfs_da_hashname(argv[c], strlen(argv[c]));
+		}
+		dbprintf("0x%x\n", hashval);
+	}
 
-	hashval = libxfs_da_hashname((unsigned char *)argv[1], (int)strlen(argv[1]));
-	dbprintf("0x%x\n", hashval);
 	return 0;
 }
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index fde1c5c6c69..60dcdc52cba 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -763,10 +763,16 @@ Skip write verifiers but perform CRC recalculation; allows invalid data to be
 written to disk to test detection of invalid data.
 .RE
 .TP
-.BI hash " string
+.BI hash [-d]" strings
 Prints the hash value of
 .I string
 using the hash function of the XFS directory and attribute implementation.
+
+If the
+.B \-d
+option is specified, the directory-specific hash function is used.
+This only makes a difference on filesystems with ascii case-insensitive
+lookups enabled.
 .TP
 .BI "hashcoll [-a] [-s seed] [-n " nr "] [-p " path "] -i | " names...
 Create directory entries or extended attributes names that all have the same

