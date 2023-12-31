Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1697C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVIhkuWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD1DC433C7;
	Sun, 31 Dec 2023 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062906;
	bh=JEVDK+1q3KSO8Ijx13YnzF4+hglbNW9cq30HGfPzVEE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PVIhkuWXIb6oSSZLRgByaL738wy1ms/7jcfdTzG8SjsOFOKHUzVPjAJoj9lIXesAR
	 C+Dhzd85Eb+srV4Zd9J95QIkghJ72l2GOVQFwEZiF4zP/q0h57My8MECH5NvFmWBKd
	 tQVAC+IRRG8uBMHfMHu42I5zMxgZax/uVrLocKh1zGt6rKzP+rDhfIUb5C9mwjdWeK
	 epda1QhEwXNKFa5wCZFcAcn97iWBnMYuHT1Z9ey94Y12j0tRhllzER7qD0D5G6PcXk
	 l4sZOGyzOTPG5tFY0Hcjid7h2u6JWwbbpj9WSaYxXskJhtaZ7QAWJy8cAfzaPYYaMx
	 rbVTx2OVjkuVA==
Date: Sun, 31 Dec 2023 14:48:25 -0800
Subject: [PATCH 13/13] xfs_scrub: dump unicode points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000755.1798385.14586557471677458655.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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
---
 scrub/unicrash.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index e895afe32aa..119656b0b9d 100644
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
@@ -1001,14 +1002,68 @@ unicrash_check_fs_label(
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

