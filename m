Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80827C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 17:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbjDDRHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 13:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbjDDRHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 13:07:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4795E69
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 10:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 703FA62E9F
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 17:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB39CC433D2;
        Tue,  4 Apr 2023 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680628026;
        bh=wQDuB+yjBgfqlO4n/ciSY7Nw4RepBsjmQr/vW0RrBF4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XCejV9N3rxCRfxnr77HYxMXAOasSWaiw+CqkrUWoQSZS8tRGuAZPk8bd/IEzztrqh
         D/LC/VlkNHxnEjF79M73D/cyJqHBUuJV/T+ns98ZCnQyuAgsWpcwt4HpTMujoArUC7
         lar1aDJegWOhB9fsTHfDdlW5yE6rpPJltMuNNr5LRioQB6HB638hiZm1j9y1F59xKv
         s7uA6x7SA4mBi2A+Z5cJmrf5Gib9W5oMAWnetFDGWLD7cXnTMctji+BSff1QgK7zvb
         Q/iX8oq3eqcQPNx9ltHyZJF6whu2bLQDFc9MNPLettQTj9jPaEbei+J3eFBqRVtMF2
         rwo7sBAoPTFtg==
Subject: [PATCH 1/3] xfs: stabilize the tolower function used for ascii-ci dir
 hash computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     torvalds@linux-foundation.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 04 Apr 2023 10:07:06 -0700
Message-ID: <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
In-Reply-To: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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
libxfs.  This makes userspace's behavior consistent with the kernel.

Found by auditing obfuscate_name in xfs_metadump as part of working on
parent pointers, wondering how it could possibly work correctly with ci
filesystems, writing a test tool to create a directory with
hash-colliding names, and watching xfs_repair flag it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |    4 ++--
 fs/xfs/libxfs/xfs_dir2.h |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..eb3187ee977d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -64,7 +64,7 @@ xfs_ascii_ci_hashname(
 	int			i;
 
 	for (i = 0, hash = 0; i < name->len; i++)
-		hash = tolower(name->name[i]) ^ rol32(hash, 7);
+		hash = xfs_ascii_ci_tolower(name->name[i]) ^ rol32(hash, 7);
 
 	return hash;
 }
@@ -85,7 +85,7 @@ xfs_ascii_ci_compname(
 	for (i = 0; i < len; i++) {
 		if (args->name[i] == name[i])
 			continue;
-		if (tolower(args->name[i]) != tolower(name[i]))
+		if (xfs_ascii_ci_tolower(args->name[i]) != xfs_ascii_ci_tolower(name[i]))
 			return XFS_CMP_DIFFERENT;
 		result = XFS_CMP_CASE;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..2772fd53279c 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -248,4 +248,24 @@ unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 bool xfs_dir2_namecheck(const void *name, size_t length);
 
+static inline bool
+xfs_ascii_ci_isupper(unsigned char c)
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
+static inline unsigned char
+xfs_ascii_ci_tolower(unsigned char c)
+{
+	if (xfs_ascii_ci_isupper(c))
+		c -= 'A' - 'a';
+	return c;
+}
+
 #endif	/* __XFS_DIR2_H__ */

