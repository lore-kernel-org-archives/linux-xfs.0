Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dBMrGCBS"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EF198
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e0LJKvAjx68Z7E/xoPGzFQo3lH4YDO2zpAv/dspLq48=; b=dBMrGCBSM/u2xhSJ5VmcMVNfSr
	7z3xfTwgtwBePuUu701JsLHcfl31G5NCUgqILfF/q+glmP70dhzwXk1DNw6JoQx1RDrE8m32dtJlR
	7tFNcCrGT+Vhflb6JhLeQVXNcUojQSX7Fu2rWXDcFAU4mv2zaPWo1dMMAwLLNikj5fBkkN+lgvHbp
	RLK/423opCSeeJTFtz24ZxlAR/fmQTSif4NV70xeCpAQKyAea9xYBSS0v6JTj8W4Up4yz8J0IYLA+
	/tBRXmtZDxWd40BFkw6wiAvQycShBUmHxddoTvR2vXK+0TeR0iPGIUGpGNztXMT6xPDQ+zpiJfgNp
	ExtX8KEA==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIW-005tBZ-08;
	Mon, 11 Dec 2023 16:38:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/23] libxfs: merge the file vs device cases in libxfs_init
Date: Mon, 11 Dec 2023 17:37:32 +0100
Message-Id: <20231211163742.837427-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only special handling for an XFS device on a regular file is that
we skip the checks in check_open.  Simplify perform those conditionally
instead of duplicating the entire sequence.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 74 ++++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 51 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 14962b9fa..86b810bfe 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -313,59 +313,31 @@ libxfs_init(struct libxfs_init *a)
 	radix_tree_init();
 
 	if (dname) {
-		if (a->disfile) {
-			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
-						    a->setblksize);
-			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(dname, a->dfd, &a->dsize,
-					   &a->dbsize);
-		} else {
-			if (!check_open(dname, flags))
-				goto done;
-			a->ddev = libxfs_device_open(dname,
-					a->dcreat, flags, a->setblksize);
-			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(dname, a->dfd,
-					   &a->dsize, &a->dbsize);
-		}
-	} else
-		a->dsize = 0;
+		if (!a->disfile && !check_open(dname, flags))
+			goto done;
+		a->ddev = libxfs_device_open(dname, a->dcreat, flags,
+				a->setblksize);
+		a->dfd = libxfs_device_to_fd(a->ddev);
+		platform_findsizes(dname, a->dfd, &a->dsize, &a->dbsize);
+	}
 	if (logname) {
-		if (a->lisfile) {
-			a->logdev = libxfs_device_open(logname,
-					a->lcreat, flags, a->setblksize);
-			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(dname, a->logfd, &a->logBBsize,
-					   &a->lbsize);
-		} else {
-			if (!check_open(logname, flags))
-				goto done;
-			a->logdev = libxfs_device_open(logname,
-					a->lcreat, flags, a->setblksize);
-			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(logname, a->logfd,
-					   &a->logBBsize, &a->lbsize);
-		}
-	} else
-		a->logBBsize = 0;
+		if (!a->lisfile && !check_open(logname, flags))
+			goto done;
+		a->logdev = libxfs_device_open(logname, a->lcreat, flags,
+				a->setblksize);
+		a->logfd = libxfs_device_to_fd(a->logdev);
+		platform_findsizes(logname, a->logfd, &a->logBBsize,
+				&a->lbsize);
+	}
 	if (rtname) {
-		if (a->risfile) {
-			a->rtdev = libxfs_device_open(rtname,
-					a->rcreat, flags, a->setblksize);
-			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(dname, a->rtfd, &a->rtsize,
-					   &a->rtbsize);
-		} else {
-			if (!check_open(rtname, flags))
-				goto done;
-			a->rtdev = libxfs_device_open(rtname,
-					a->rcreat, flags, a->setblksize);
-			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(rtname, a->rtfd,
-					   &a->rtsize, &a->rtbsize);
-		}
-	} else
-		a->rtsize = 0;
+		if (a->risfile && !check_open(rtname, flags))
+			goto done;
+		a->rtdev = libxfs_device_open(rtname, a->rcreat, flags,
+				a->setblksize);
+		a->rtfd = libxfs_device_to_fd(a->rtdev);
+		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
+	}
+
 	if (a->dsize < 0) {
 		fprintf(stderr, _("%s: can't get size for data subvolume\n"),
 			progname);
-- 
2.39.2

