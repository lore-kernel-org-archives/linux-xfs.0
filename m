Received: from mail.wilcox-tech.com (mail.wilcox-tech.com [45.32.83.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F908F70
	for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 02:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.83.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723345102; cv=none; b=UHYMN4F04yTjby7VNziXWtCu+VF7vHXI4CLs2Y6CPEi18Lye3o+gYpj4bKu7yZrBxtOHv9sJ4gEvw7UDX6FuCZvOreuWjd/m2cIxasfuEQeE51G9k3Wofxyd+0yujkKfon3fUDCG4aZupazppsaYpm8O9kMz84R8olRkseRXtDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723345102; c=relaxed/simple;
	bh=sLvB8h5kEgnFYBlUDboaOWE7xmdEFZ/flUNS9l/ZaNo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e8L9Brp2z8l49EGBySD6mINZ0dfXEE5j6gA/Cc8kXsRrjRaelnCq1lnMp0fPsW55CSMqvBcvbk4F8P6QAAFya5yx81ywJQ5DHu4BYHwVVRetjgENBn1Wo/nRpbrriwcOaRpiRMATDScbLF+mNUKCkNl/u/heDeej7p7EXpLbrgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com; spf=pass smtp.mailfrom=Wilcox-Tech.com; arc=none smtp.client-ip=45.32.83.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Wilcox-Tech.com
Received: (qmail 8356 invoked from network); 11 Aug 2024 02:50:47 -0000
Received: from ip98-184-130-195.tu.ok.cox.net (HELO gwyn.us) (awilcox@wilcox-tech.com@98.184.130.195)
  by mail.wilcox-tech.com with ESMTPA; 11 Aug 2024 02:50:47 -0000
From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
To: linux-xfs@vger.kernel.org
Cc: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
Subject: [PATCH] xfs_scrub: Use POSIX-conformant strerror_r
Date: Sat, 10 Aug 2024 21:51:04 -0500
Message-Id: <20240811025104.54614-1-AWilcox@Wilcox-Tech.com>
X-Mailer: git-send-email 2.40.0
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
 scrub/inodes.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scrub/common.c b/scrub/common.c
index 283ac84e..bd8bde35 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -122,7 +122,8 @@ __str_out(
 	fprintf(stream, "%s%s: %s: ", stream_start(stream),
 			_(err_levels[level].string), descr);
 	if (error) {
-		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
+		strerror_r(error, buf, DESCR_BUFSZ);
+		fprintf(stream, _("%s."), buf);
 	} else {
 		va_start(args, format);
 		vfprintf(stream, format, args);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 16c79cf4..f0e7289c 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -65,9 +65,9 @@ bulkstat_for_inumbers(
 	error = -xfrog_bulkstat(&ctx->mnt, breq);
 	if (error) {
 		char	errbuf[DESCR_BUFSZ];
+		strerror_r(error, errbuf, DESCR_BUFSZ);
 
-		str_info(ctx, descr_render(dsc), "%s",
-			 strerror_r(error, errbuf, DESCR_BUFSZ));
+		str_info(ctx, descr_render(dsc), "%s", errbuf);
 	}
 
 	/*
-- 
2.40.0

