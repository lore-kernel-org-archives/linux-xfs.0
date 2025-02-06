Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF592376E6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882262; cv=none; b=IRpMxU1wLNLnw5iBq/tDV5mf1FQC4XEmhO9lRVbPv6vK6jSYwCF6RCjRzuqC7zZKpobigGuC/yo/RCk+0xAF88aIN465nD4b+oDCnYA2jfH7deVHQkBufgMtLVlMxgtKfcqVNCPRM7DGKZr4n9d4ttEDeEh59nQfPkdGbzj9OWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882262; c=relaxed/simple;
	bh=Yh+dsNuw+AYg16qsqlYbAmAJg7yIuz+E8rUV96mAFBQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3DcJzWIwbAE2sjfSTfghImd4xsSt//tphLuGzHgY5r4nzjmvefLB7hPmV49sfN15C+GdBIl26A/rmEMDK6oFq1yjMhCSOdl8S2/cwjHY9lNBPxSuMpwKDFoPGGEIJdSzNcb8gy5g+yhN4gqcxd5DM2OXa1cDjxm9w/MFFX4CHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlyChZbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlyChZbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978BAC4CEDD;
	Thu,  6 Feb 2025 22:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882262;
	bh=Yh+dsNuw+AYg16qsqlYbAmAJg7yIuz+E8rUV96mAFBQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LlyChZbzVkxzfSxzC9Peduw2EwxQnbkIDQvLWa+IeBV9Ocn3LS6Ptu5aEbq8TDn6x
	 XnTnTmGzN4BctixLf9MCC86dUSaVk0/pPT4HqhNXDN0In8DtBkh/1WFGWWPY2JbCf2
	 Y++nqyY66iE6+3/sNMXmSKQ0P5ruVFCcsW7mXrcuJkP2gBuzYQoIqCNF50iepRm7FU
	 A4nXgQVxCuDzx8FnraALrx4ptjZI9MWIwMz1Mww4bv0W4ipr4fjPHjqcTb7N9eWJ2i
	 zgCBLdY3AymTAK44wmTcIn9alwGeCywHJG6vF0MkQwykEroxYo1PvXnZ5SLWqFLYT/
	 GdPVLI8/CRcSw==
Date: Thu, 06 Feb 2025 14:51:02 -0800
Subject: [PATCH 05/27] xfs_db: compute average btree height
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088172.2741033.4230304960811159164.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Compute the btree height assuming that the blocks are 75% full.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/btheight.c     |   31 +++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    6 +++++-
 2 files changed, 36 insertions(+), 1 deletion(-)


diff --git a/db/btheight.c b/db/btheight.c
index 98165b522e4f6f..0456af08b39edf 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -259,6 +259,7 @@ _("%s: pointer size must be less than selected block size (%u bytes).\n"),
 #define REPORT_MAX	(1 << 0)
 #define REPORT_MIN	(1 << 1)
 #define REPORT_ABSMAX	(1 << 2)
+#define REPORT_AVG	(1 << 3)
 
 static void
 report_absmax(const char *tag)
@@ -317,6 +318,34 @@ _("%s: best case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
 		calc_height(nr_records, records_per_block);
 	}
 
+	if (report_what & REPORT_AVG) {
+		records_per_block[0] *= 3;
+		records_per_block[0] /= 4;
+		records_per_block[1] *= 3;
+		records_per_block[1] /= 4;
+
+		if (records_per_block[0] < 2) {
+			fprintf(stderr,
+_("%s: cannot calculate average case scenario due to leaf geometry underflow.\n"),
+				tag);
+			return;
+		}
+
+		if (records_per_block[1] < 4) {
+			fprintf(stderr,
+_("%s: cannot calculate average case scenario due to node geometry underflow.\n"),
+				tag);
+			return;
+		}
+
+		printf(
+_("%s: average case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
+				tag, blocksize, records_per_block[0],
+				records_per_block[1]);
+
+		calc_height(nr_records, records_per_block);
+	}
+
 	if (report_what & REPORT_MIN) {
 		records_per_block[0] /= 2;
 		records_per_block[1] /= 2;
@@ -393,6 +422,8 @@ btheight_f(
 				report_what = REPORT_MAX;
 			else if (!strcmp(optarg, "absmax"))
 				report_what = REPORT_ABSMAX;
+			else if (!strcmp(optarg, "avg"))
+				report_what = REPORT_AVG;
 			else {
 				btheight_help();
 				return 0;
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 06f4464a928596..acee900adbda50 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -519,7 +519,7 @@ .SH COMMANDS
 Dump all keys and pointers in intermediate btree nodes, and all records in leaf btree nodes.
 .RE
 .TP
-.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|" min "|" absmax "] btree types..."
+.BI "btheight [\-b " blksz "] [\-n " recs "] [\-w " max "|" min "|" absmax "|" avg "] btree types..."
 For a given number of btree records and a btree type, report the number of
 records and blocks for each level of the btree, and the total number of blocks.
 The btree type must be given after the options.
@@ -562,6 +562,10 @@ .SH COMMANDS
 .B \-w min
 shows only the worst case scenario, which is when the btree blocks are
 half full.
+.TP
+.B \-w avg
+shows only the average case scenario, which is when the btree blocks are
+three quarters full.
 .RE
 .TP
 .BI "convert " "type number" " [" "type number" "] ... " type

