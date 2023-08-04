Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F5DC001DE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjHDRMu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjHDRMq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:12:46 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827013C25
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:12:45 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HCRPT019440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169149; bh=xtB0VI+ia9DELVNK6CwAN1neDLJ4Dqpr8AhA2O99NrU=;
        h=From:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Mx4BPfwRAZGe4CZcnhTWA+3hfnRskap7/4fiAjMEQMo1NtXc3tl04kg7KGtURK1lg
         zfD6JoKeOrSQCI9cbdM6Rw6uN3Zw/0hb4KoEVgAw2/cgcUetxMzKj4FsX7yDY1YWdX
         lBbOVxjJpWoInnm8Fk4/oJEtf69teBPsSYqbVkeFKmx+TeZXY2FXChQNguJGGOUzjQ
         78Xt4LGxHIypW3Uufyx74lIXBVyCzb68whstokWa6Ek3jJzKO/wbdrY0JTO2OQ1dEi
         J7i+dw6iTuxYSwci6W6QaqkI5skRYSNA2fNsJ2TMcSQDg8jKcodPm7YQnhQQOiG28E
         jNkgThPV6H8Cw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F397615C04F3; Fri,  4 Aug 2023 13:12:26 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH CANDIDATE v6.1 3/5] xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
Date:   Fri,  4 Aug 2023 13:12:21 -0400
Message-Id: <20230804171223.1393045-3-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171223.1393045-1-tytso@mit.edu>
References: <20230804171223.1393045-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
(cherry picked from commit a9248538facc3d9e769489e50a544509c2f9cebe)
---
 fs/xfs/libxfs/xfs_dir2.c |  5 +++--
 fs/xfs/libxfs/xfs_dir2.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..f5462fd582d5 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -64,7 +64,7 @@ xfs_ascii_ci_hashname(
 	int			i;
 
 	for (i = 0, hash = 0; i < name->len; i++)
-		hash = tolower(name->name[i]) ^ rol32(hash, 7);
+		hash = xfs_ascii_ci_xfrm(name->name[i]) ^ rol32(hash, 7);
 
 	return hash;
 }
@@ -85,7 +85,8 @@ xfs_ascii_ci_compname(
 	for (i = 0; i < len; i++) {
 		if (args->name[i] == name[i])
 			continue;
-		if (tolower(args->name[i]) != tolower(name[i]))
+		if (xfs_ascii_ci_xfrm(args->name[i]) !=
+		    xfs_ascii_ci_xfrm(name[i]))
 			return XFS_CMP_DIFFERENT;
 		result = XFS_CMP_CASE;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..19af22a16c41 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
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
-- 
2.31.0

