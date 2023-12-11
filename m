Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RUe2wtvU"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017AAC2
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kFRVmyseUjRZgsiWDUd88An0u1cuEV0SuqTwpagIn+s=; b=RUe2wtvUJYvSs4BXyfCDi1qH12
	psEuxqY/e1bcf46mhPV0xLLLCn5fkJ4wxRA7kzzcHldIpyUgoOtZ75g6kfMyiHAzomByYzjNwtavD
	ORSkJ2d23WUjIIqsjAIOSfVZDkJjViSmkMqagcMd6WAWjbaAAZoWdpgifue9H5dUxB7YMIInPU4he
	8lhP074yvy2Nr3ig8JkppqGpbz6j3rsWVP2biUrL8C6rPBGihJtynUXXM8GloyirO4sgNu1ciY7ai
	wvJhuXQ9+gwGhEhoJaDgS2JuFzjGCDNAcJVRS0RlsdTHO7HId5HVFchNrY5ZoikTCYLMqCAWGq75a
	1bnGFbfQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjI9-005sxF-0v;
	Mon, 11 Dec 2023 16:38:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/23] xfs_logprint: move all code to set up the fake xlog into logstat()
Date: Mon, 11 Dec 2023 17:37:24 +0100
Message-Id: <20231211163742.837427-6-hch@lst.de>
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

Isolate the code that sets up the fake xlog into the logstat() helper to
prepare for upcoming changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/logprint.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/logprint/logprint.c b/logprint/logprint.c
index 9a8811f46..7d51cdd91 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -52,7 +52,9 @@ Options:\n\
 }
 
 static int
-logstat(xfs_mount_t *mp)
+logstat(
+	struct xfs_mount	*mp,
+	struct xlog		*log)
 {
 	int		fd;
 	char		buf[BBSIZE];
@@ -103,6 +105,11 @@ logstat(xfs_mount_t *mp)
 		x.lbsize = BBSIZE;
 	}
 
+	log->l_dev = mp->m_logdev_targp;
+	log->l_logBBstart = x.logBBstart;
+	log->l_logBBsize = x.logBBsize;
+	log->l_sectBBsize = BTOBB(x.lbsize);
+	log->l_mp = mp;
 
 	if (x.logname && *x.logname) {    /* External log */
 		if ((fd = open(x.logname, O_RDONLY)) == -1) {
@@ -212,8 +219,8 @@ main(int argc, char **argv)
 	if (!libxfs_init(&x))
 		exit(1);
 
-	logstat(&mount);
 	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev);
+	logstat(&mount, &log);
 
 	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
 
@@ -226,15 +233,9 @@ main(int argc, char **argv)
 	}
 
 	printf(_("daddr: %lld length: %lld\n\n"),
-		(long long)x.logBBstart, (long long)x.logBBsize);
+		(long long)log.l_logBBstart, (long long)log.l_logBBsize);
 
-	ASSERT(x.logBBsize <= INT_MAX);
-
-	log.l_dev = mount.m_logdev_targp;
-	log.l_logBBstart  = x.logBBstart;
-	log.l_logBBsize   = x.logBBsize;
-	log.l_sectBBsize  = BTOBB(x.lbsize);
-	log.l_mp          = &mount;
+	ASSERT(log.l_logBBsize <= INT_MAX);
 
 	switch (print_operation) {
 	case OP_PRINT:
-- 
2.39.2

