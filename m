Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D504052AF
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313232; cv=none; b=pxnPf9Sfgl9Hcsmxu8VODftrvBCjYuc9uoM3MKr5wktTd952GZy/JN3MIfuGmRg0YshCh+AcFjo7Tfu95PbKC4fTWnS5J4LMw5x3RvYktf/hB41OEYvFvdmU3DGdxFlL+QZX2CyqD4o/H+BfdIbX2PfKr+d4L4daieO2F4m58yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313232; c=relaxed/simple;
	bh=iSL2KiNQ37SKfDTQtvyGxgEryRXY8C68ZcHwKsIKsJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBOcGXtX8Ji5qjD630z5JCQen5IyMWeQr3IJy3xImbjdqlAXDUVasv7C6H41IbxTv0p3tKJrKTOr438Q0DkB8D8FIQP4JnIBdVM5nxec3SumKZlLhqxpDzZimpsZWPxqZqD3FzRI7D3vqu4xeRWvbT9DR964+WbNz0LNah/rnQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PdrbtNxn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PdrbtNxn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CMvQfVC/6lRw74HFjOHgGHTa9MuxNYGm6v+AhxaAYB4=; b=PdrbtNxnPkxZNht46WQnfbFQ98
	yb0FJRvMJ5i+IfKE4wmr5Jjv69CXaNpwO3iccVkkf1mI9Q3nM7d6ZTehOegRIqjBSAUT7dL9P66K8
	4qDlNDgUsAID7Ba2MpX8lMeFeDeWwJwrXi3QRgCOX5r+5XfJoUv0jMqTerEda5f250bia0L/kS+s9
	4wYOxxQ7elHZmeEf+cKC9jut0oYiMzfSWE2kPc3pI3Avi7xvOVjI/f/7eJ29C+wRCnZuLVxHJxua5
	8+OKUtoTxT0pbwS8UBQQe2mR2xfEI5JbLuYRWsKarsMoEFTJ0Onl5DB+fFKx5wiX0qpAnPgQtcGt3
	DpVRaoUg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFl-0000000CgbS-3EPn;
	Fri, 25 Sep 2026 05:13:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] libxfs: split error injection option parsing out of libxfs_buftarg_init
Date: Fri, 25 Sep 2026 07:12:48 +0200
Message-ID: <20260925051336.2997014-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a separate helper to keep this debug code separate from the main
initialization flow, and only set up the error injection once when
in libxfs_mount, thus skipping it for sb probing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 102 +++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 63015badc24e..1b5e1e1e8ba8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -445,8 +445,7 @@ static struct xfs_buftarg *
 libxfs_buftarg_alloc(
 	struct xfs_mount	*mp,
 	struct libxfs_init	*xi,
-	struct libxfs_dev	*dev,
-	unsigned long		write_fails)
+	struct libxfs_dev	*dev)
 {
 	struct xfs_buftarg	*btp;
 
@@ -461,10 +460,6 @@ libxfs_buftarg_alloc(
 	btp->bt_bdev_fd = dev->fd;
 	btp->bt_xfile = NULL;
 	btp->flags = 0;
-	if (write_fails) {
-		btp->writes_left = write_fails;
-		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
-	}
 	pthread_mutex_init(&btp->lock, NULL);
 
 	btp->bcache = cache_init(xi->bcache_flags, libxfs_bhash_size,
@@ -487,6 +482,52 @@ static char *wf_opts[] = {
 	[WF_MAX_OPTS]		= NULL,
 };
 
+static void
+setup_buftarg_write_error(
+	struct xfs_buftarg	*btp,
+	char			*val)
+{
+	if (!val) {
+		fprintf(stderr, _("write fail requires a parameter\n"));
+		exit(1);
+	}
+	if (!btp)
+		return;
+	btp->writes_left = strtoul(val, NULL, 0);
+	if (btp->writes_left)
+		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
+}
+
+static void
+libxfs_setup_write_error_injection(
+	struct xfs_mount	*mp)
+{
+	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
+
+	/* Simulate utility crash after a certain number of writes. */
+	while (p && *p) {
+		char *val;
+
+		switch (getsubopt(&p, wf_opts, &val)) {
+		case WF_DATA:
+			setup_buftarg_write_error(mp->m_ddev_targp, val);
+			break;
+		case WF_LOG:
+			setup_buftarg_write_error(mp->m_logdev_targp, val);
+			break;
+		case WF_RT:
+			if (mp->m_rtdev_targp == mp->m_ddev_targp)
+				break;
+			setup_buftarg_write_error(mp->m_rtdev_targp, val);
+			break;
+		default:
+			fprintf(stderr, _("unknown write fail type %s\n"), val);
+			exit(1);
+			break;
+		}
+	}
+}
+
 static void
 libxfs_buftarg_reinit(
 	struct xfs_mount	*mp,
@@ -529,46 +570,6 @@ libxfs_buftarg_init(
 	struct xfs_mount	*mp,
 	struct libxfs_init	*xi)
 {
-	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
-	unsigned long		dfail = 0, lfail = 0, rfail = 0;
-
-	/* Simulate utility crash after a certain number of writes. */
-	while (p && *p) {
-		char *val;
-
-		switch (getsubopt(&p, wf_opts, &val)) {
-		case WF_DATA:
-			if (!val) {
-				fprintf(stderr,
-		_("ddev write fail requires a parameter\n"));
-				exit(1);
-			}
-			dfail = strtoul(val, NULL, 0);
-			break;
-		case WF_LOG:
-			if (!val) {
-				fprintf(stderr,
-		_("logdev write fail requires a parameter\n"));
-				exit(1);
-			}
-			lfail = strtoul(val, NULL, 0);
-			break;
-		case WF_RT:
-			if (!val) {
-				fprintf(stderr,
-		_("rtdev write fail requires a parameter\n"));
-				exit(1);
-			}
-			rfail = strtoul(val, NULL, 0);
-			break;
-		default:
-			fprintf(stderr, _("unknown write fail type %s\n"),
-					val);
-			exit(1);
-			break;
-		}
-	}
-
 	/*
 	 * This can happen if the utility called libxfs_buftarg_init manually
 	 * before libxfs_mount, which calls us again.
@@ -581,17 +582,15 @@ libxfs_buftarg_init(
 		return;
 	}
 
-	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi, &xi->data, dfail);
+	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi, &xi->data);
 	if (!xi->log.dev || xi->log.dev == xi->data.dev)
 		mp->m_logdev_targp = mp->m_ddev_targp;
 	else
-		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
-				lfail);
+		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log);
 	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
 		mp->m_rtdev_targp = mp->m_ddev_targp;
 	else
-		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
-				rfail);
+		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt);
 }
 
 /* Compute maximum possible height for per-AG btree types for this fs. */
@@ -740,6 +739,7 @@ libxfs_mount(
 	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
 		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, xi);
+	libxfs_setup_write_error_injection(mp);
 
 	if (xi->data.name)
 		mp->m_fsname = strdup(xi->data.name);
-- 
2.53.0

