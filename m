Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2FEC761A6
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDFAJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjDFAJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D3E76A7
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 128F862AA2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775ECC433D2;
        Thu,  6 Apr 2023 00:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739779;
        bh=2+uOlWYqFchxzhSVBwuydEHmDQpfTM/qFys3ZcXBhjc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GscP6RtmW0im/GjjfXnUAuDzL/EVT/b6pF4DaBmBdQVJZO2tRVcHC7WDupidLbO8A
         1eOmHWbgI0FEM93/Ua8s+2SjY5cfJtImoKrJpuVipZ35uD3veT+5YwJmdn0I2mj5Bj
         vSJIwMblIeHF5YFTXCo8sbiQDwua62wtT8Z5rmQ0Qcv31KelnduKeFnv8bFHSeqFob
         qX8rzAYP225QsLQUzzi8uI9dWuOCvy0ZuuLZKoqKhppeIpnUxXAkUYpBgdsbCbFzmU
         68W42ERGHZrj/RuNG/VqXdCB1Nvr808Ncy8gbmtxevTOs9pKlplVcucOzdc7wlo3ip
         wAdsA8LhNariQ==
Subject: [PATCH 1/6] xfs: stabilize the dirent name transformation function
 used for ascii-ci dir hash computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:09:39 -0700
Message-ID: <168073977906.1656666.2780744038650675596.stgit@frogsfrogsfrogs>
In-Reply-To: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Back in the old days, the "ascii-ci" feature was created to implement
case-insensitive directory entry lookups for latin1-encoded names and
remove the large overhead of Samba's case-insensitive lookup code.  UTF8
names were not allowed, but nobody explicitly wrote in the documentation
that this was only expected to work if the system used latin1 names.
The kernel tolower function was selected to prepare names for hashed
lookups.

There's a major discrepancy in the function that computes directory entry
hashes for filesystems that have ASCII case-insensitive lookups enabled.
The root of this is that the kernel and glibc's tolower implementations
have differing behavior for extended ASCII accented characters.  I wrote
a program to spit out characters for which the tolower() return value is
different from the input:

glibc tolower:
65:A 66:B 67:C 68:D 69:E 70:F 71:G 72:H 73:I 74:J 75:K 76:L 77:M 78:N
79:O 80:P 81:Q 82:R 83:S 84:T 85:U 86:V 87:W 88:X 89:Y 90:Z

kernel tolower:
65:A 66:B 67:C 68:D 69:E 70:F 71:G 72:H 73:I 74:J 75:K 76:L 77:M 78:N
79:O 80:P 81:Q 82:R 83:S 84:T 85:U 86:V 87:W 88:X 89:Y 90:Z 192:À 193:Á
194:Â 195:Ã 196:Ä 197:Å 198:Æ 199:Ç 200:È 201:É 202:Ê 203:Ë 204:Ì 205:Í
206:Î 207:Ï 208:Ð 209:Ñ 210:Ò 211:Ó 212:Ô 213:Õ 214:Ö 215:× 216:Ø 217:Ù
218:Ú 219:Û 220:Ü 221:Ý 222:Þ

Which means that the kernel and userspace do not agree on the hash value
for a directory filename that contains those higher values.  The hash
values are written into the leaf index block of directories that are
larger than two blocks in size, which means that xfs_repair will flag
these directories as having corrupted hash indexes and rewrite the index
with hash values that the kernel now will not recognize.

Because the ascii-ci feature is not frequently enabled and the kernel
touches filesystems far more frequently than xfs_repair does, fix this
by encoding the kernel's toupper predicate and tolower functions into
libxfs.  Give the new functions less provocative names to make it really
obvious that this is a pre-hash name preparation function, and nothing
else.  This change makes userspace's behavior consistent with the
kernel.

Found by auditing obfuscate_name in xfs_metadump as part of working on
parent pointers, wondering how it could possibly work correctly with ci
filesystems, writing a test tool to create a directory with
hash-colliding names, and watching xfs_repair flag it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |    4 ++--
 libxfs/xfs_dir2.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index d6a19296..ae21ee34 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -63,7 +63,7 @@ xfs_ascii_ci_hashname(
 	int			i;
 
 	for (i = 0, hash = 0; i < name->len; i++)
-		hash = tolower(name->name[i]) ^ rol32(hash, 7);
+		hash = xfs_ascii_ci_xfrm(name->name[i]) ^ rol32(hash, 7);
 
 	return hash;
 }
@@ -84,7 +84,7 @@ xfs_ascii_ci_compname(
 	for (i = 0; i < len; i++) {
 		if (args->name[i] == name[i])
 			continue;
-		if (tolower(args->name[i]) != tolower(name[i]))
+		if (xfs_ascii_ci_xfrm(args->name[i]) != xfs_ascii_ci_xfrm(name[i]))
 			return XFS_CMP_DIFFERENT;
 		result = XFS_CMP_CASE;
 	}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index dd39f17d..19af22a1 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -248,4 +248,35 @@ unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 bool xfs_dir2_namecheck(const void *name, size_t length);
 
+/*
+ * The "ascii-ci" feature was created to speed up case-insensitive lookups for
+ * a Samba product.  Because of the inherent problems with CI and UTF-8
+ * encoding, etc, it was decided that Samba would be configured to export
+ * latin1/iso 8859-1 encodings as that covered >90% of the target markets for
+ * the product.  Hence the "ascii-ci" casefolding code could be encoded into
+ * the XFS directory operations and remove all the overhead of casefolding from
+ * Samba.
+ *
+ * To provide consistent hashing behavior between the userspace and kernel,
+ * these functions prepare names for hashing by transforming specific bytes
+ * to other bytes.  Robustness with other encodings is not guaranteed.
+ */
+static inline bool xfs_ascii_ci_need_xfrm(unsigned char c)
+{
+	if (c >= 0x41 && c <= 0x5a)	/* A-Z */
+		return true;
+	if (c >= 0xc0 && c <= 0xd6)	/* latin A-O with accents */
+		return true;
+	if (c >= 0xd8 && c <= 0xde)	/* latin O-Y with accents */
+		return true;
+	return false;
+}
+
+static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
+{
+	if (xfs_ascii_ci_need_xfrm(c))
+		c -= 'A' - 'a';
+	return c;
+}
+
 #endif	/* __XFS_DIR2_H__ */

