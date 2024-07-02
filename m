Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E1D3D64
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882047; cv=none; b=ucIIYwsIeB3dMZYElmvOYMS9CD5rGR+7nIGfpiwpAGBoVj91kJqqWyqy6TSqjKoVuJhc/sdiFw2hq1a0P3uM9gSEez6e5HwIxkUiN/jNuxGlUArqsaF++fF/3lKdRK5RWK6Tjm5YN4d2ZA2rLcVImjDXJLpjgpY6JO3DrGvrgbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882047; c=relaxed/simple;
	bh=274yWZmMBpjVxsIaYYljQoAxadW6ioZMZY6MW+HW758=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfKD4o0mSwxyFQEz9aASwz/5nojPkq9iUm7b6uMxhFLhmL1Df8g58Birkr1Ol2mW0ENoEDGdey9TnjW55CEeCvCiZk7aETq9bw54N+/OQAwiXyq5kCAdIBnRLxU9wA35oZJJIbTF9kXYdyum73thPmLvfuzo8DCDF8Ztg779CBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBmUYnRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBmUYnRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA61C116B1;
	Tue,  2 Jul 2024 01:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882047;
	bh=274yWZmMBpjVxsIaYYljQoAxadW6ioZMZY6MW+HW758=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GBmUYnRKruKhUS5X9ZkgJVXrevgQVpuR45HhREeAzMPRJ4rDTpmIYc7fiq+v+3mhp
	 BCFyfudVZUWFBwPfNeMXMzRIGAcYPvtviUNe7eiVHzjdagyK8BH7Ocqn0wmKEdzxMP
	 DbOzDrX0JK2NJezOJB8Gy7+hFlklyXf2fX2o+qeR0oZPn+GBw8P71ZRPNGl4WhMpou
	 MLQVuTEDRtrk4UKALGFKFJ3NybPmduBnOIA07meWpn1zRXqKuOacsqI6f38r9coE9s
	 zdkc27BGBtuOfFxn0Ei2gklHjxZvRxQjVJ1/Z26GLKYBRk7J7ePEjf9KMmiMKbvisg
	 wTXrQUEMS3Hpw==
Date: Mon, 01 Jul 2024 18:00:46 -0700
Subject: [PATCH 13/13] xfs_scrub: dump unicode points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117809.2007123.1252324748291441519.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
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
index e895afe32aab..119656b0b9d5 100644
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

