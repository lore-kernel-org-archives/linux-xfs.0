Received: from mail.wilcox-tech.com (mail.wilcox-tech.com [45.32.83.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCE4261B91
	for <linux-xfs@vger.kernel.org>; Sat,  6 Sep 2025 08:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.83.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757146777; cv=none; b=ra10g+P73U0xlxA8QJJDv3iWWr9GWh6X/cKfQti4YUVlw566Y5pqmQ6J9C7ErA6Q9zwKsg8pU845+EfFdCeFMGTu3DMB+kLXRLonpXVFfO30jMUkEeiSdspPUGRkmTG18gVXmN24RhFMKOfXIqzrNuU5xR3fRKqEZ6AUVpqdsmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757146777; c=relaxed/simple;
	bh=FnHciGSb+gPups0lr0kt7817VJssrLPHHtWlFFs5sjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHGJ1hszkHekOHuagdjU4is6eyBNpis4c6GtmfBdrjIwcwGQugYNwgIP0l8+n/hvQ285kohtrHavIS5H3j/Taq48L4ZUxIq6QEXqk9gE82wwMR+YCJKNB/EUIQefmQMHhWrolWFqFMhbWZN6/8tOBk4V/NbSmOe/Baff8oKZuUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com; spf=pass smtp.mailfrom=Wilcox-Tech.com; arc=none smtp.client-ip=45.32.83.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Wilcox-Tech.com
Received: (qmail 6773 invoked from network); 6 Sep 2025 08:11:17 -0000
Received: from 23.sub-75-224-99.myvzw.com (HELO gwyn.foxkit.us) (awilcox@wilcox-tech.com@75.224.99.23)
  by mail.wilcox-tech.com with ESMTPA; 6 Sep 2025 08:11:17 -0000
From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
To: linux-xfs@vger.kernel.org
Cc: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
Subject: [PATCH v2] xfs_scrub: Use POSIX-conformant strerror_r
Date: Sat,  6 Sep 2025 03:12:07 -0500
Message-ID: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building xfsprogs with musl libc, strerror_r returns int as
specified in POSIX.  This differs from the glibc extension that returns
char*.  Successful calls will return 0, which will be dereferenced as a
NULL pointer by (v)fprintf.

Signed-off-by: A. Wilcox <AWilcox@Wilcox-Tech.com>
---
 scrub/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/common.c b/scrub/common.c
index 14cd677b..9437d0ab 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -126,7 +126,8 @@ __str_out(
 	fprintf(stream, "%s%s: %s: ", stream_start(stream),
 			_(err_levels[level].string), descr);
 	if (error) {
-		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
+		strerror_r(error, buf, DESCR_BUFSZ);
+		fprintf(stream, _("%s."), buf);
 	} else {
 		va_start(args, format);
 		vfprintf(stream, format, args);
-- 
2.49.0

