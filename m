Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F15C121
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301751; cv=none; b=G/lMcvBFtVvyovtMu8l0C34idKkECzyRTfL4dXdhYVK3lhokarHKj+QOa5dPCYCxNXFJc79mWmLetGjBW7oMeyazhTMQzhGUueP6E4DoUOY7H5K4wcmUnLJ/abE1elkoBpgCOkdhJKjwwgJK6PSMWhuKgu8ewI7+tGXA16V4ySE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301751; c=relaxed/simple;
	bh=Qg6Rqr05i0QzsWtHkoH73PQVdQ1BBfoqgXOUHxS6Vn4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+HqXsH+j6Ls3qMSEGi5MDGkFzG4RIK7w2ZHeX+Y33iVKQjvhLK/ib879siPRsdwIAlPrjZd764Z4PooX+eAzDyrUr5H7wQftas62/FhNq4o+HJoX2pJI5j3s21wU8D6hINU1e4aj/bjky+aJhhxRWxKz73bX+zMQSDDtzq3K40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L45DIodz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L45DIodz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ED9C32786;
	Tue, 30 Jul 2024 01:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301751;
	bh=Qg6Rqr05i0QzsWtHkoH73PQVdQ1BBfoqgXOUHxS6Vn4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L45DIodzbNF12K9B1skk2bWceWm91NHhJqLAhiacsaDXpe4uOpuzTWIXaiQ+HmO8j
	 FLu9+YaiPxddZEbZe2J4buKw3MPJOe9hID0Js8GNg0M9DrmGqZD3oiSsixNv8brLa2
	 50GFiDud6L978ODrR5go/XBa5o9cpLTAWBVyXbzmVchcihQDDloEtbQJg1XtZ3J6N8
	 QWZ7zQcnleSSALpFT7a6SGVAT5aVBqC5pCycoaiS6QI9W7JyFGw3EEqDKF7XNYK39J
	 tFgBhO5YcSkuF6xINW4Q2Y0trxGa58eP6rCsHaPSzDzfkhbE7/2wLjyTxM7FCaUlKm
	 +ufEUrTrIuuxQ==
Date: Mon, 29 Jul 2024 18:09:11 -0700
Subject: [PATCH 13/13] xfs_scrub: dump unicode points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847727.1348850.14998443199466261121.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
References: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add some debug functions to make it easier to query unicode character
properties.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 8a896f33c..143060b56 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_arch.h"
+#include "list.h"
 #include <stdint.h>
 #include <stdlib.h>
 #include <dirent.h>
@@ -1003,14 +1004,68 @@ unicrash_check_fs_label(
 			label, 0);
 }
 
+/* Dump a unicode code point and its properties. */
+static inline void dump_uchar32(UChar32 c)
+{
+	UChar		uchrstr[UCHAR_PER_UCHAR32];
+	const char	*descr;
+	char		buf[16];
+	int32_t		uchrstrlen, buflen;
+	UProperty	p;
+	UErrorCode	uerr = U_ZERO_ERROR;
+
+	printf("Unicode point 0x%x:", c);
+
+	/* Convert UChar32 to UTF8 representation. */
+	uchrstrlen = uchar32_to_uchar(c, uchrstr);
+	if (!uchrstrlen)
+		return;
+
+	u_strToUTF8(buf, sizeof(buf), &buflen, uchrstr, uchrstrlen, &uerr);
+	if (!U_FAILURE(uerr) && buflen > 0) {
+		int32_t	i;
+
+		printf(" \"");
+		for (i = 0; i < buflen; i++)
+			printf("\\x%02x", buf[i]);
+		printf("\"");
+	}
+	printf("\n");
+
+	for (p = 0; p < UCHAR_BINARY_LIMIT; p++) {
+		int	has;
+
+		descr = u_getPropertyName(p, U_LONG_PROPERTY_NAME);
+		if (!descr)
+			descr = u_getPropertyName(p, U_SHORT_PROPERTY_NAME);
+
+		has = u_hasBinaryProperty(c, p) ? 1 : 0;
+		if (descr) {
+			printf("  %s(%u) = %d\n", descr, p, has);
+		} else {
+			printf("  ?(%u) = %d\n", p, has);
+		}
+	}
+}
+
 /* Load libicu and initialize it. */
 bool
 unicrash_load(void)
 {
-	UErrorCode		uerr = U_ZERO_ERROR;
+	char		*dbgstr;
+	UChar32		uchr;
+	UErrorCode	uerr = U_ZERO_ERROR;
 
 	u_init(&uerr);
-	return U_FAILURE(uerr);
+	if (U_FAILURE(uerr))
+		return true;
+
+	dbgstr = getenv("XFS_SCRUB_DUMP_CHAR");
+	if (dbgstr) {
+		uchr = strtol(dbgstr, NULL, 0);
+		dump_uchar32(uchr);
+	}
+	return false;
 }
 
 /* Unload libicu once we're done with it. */

