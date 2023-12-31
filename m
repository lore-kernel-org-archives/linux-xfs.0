Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88858C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUna5Wzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17004C433C7;
	Sun, 31 Dec 2023 23:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066314;
	bh=w87gFzzSfIo51Mhcgd5KQrhoLPcDoIi/kJeHE0KGN34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PUna5Wzd+4gbnpzuUuHufHEpNnl241k8cGGZJ3udc7l6juNBb4fRmJ769Tmb4z/m2
	 bDne/ncEugjYu+g2Z2TTLn6bouaesMaXKNtXXQZDlgnm6Qe7YabxSYU6KGSCZbSyZI
	 58cWLHst9m9W288aFywAnFYjn+J9qX2E/ZY0hbs+OZPW09Zzq2xPZYxbpUxCPz1uzI
	 g7+MSjsqWai9atUHtDwVLD4E7X4lfv/lWP1SZjbWm/jZjYshx0d4D6xnx6fIQ8yyOp
	 /PmSRlhwJqkFmFFV4InEw+CgJC1qcCv6TtJyyIxkwvFpNZVE/LJ5rIWc6VE2EhRXcv
	 xoUv+WgHfCbYg==
Date: Sun, 31 Dec 2023 15:45:13 -0800
Subject: [PATCH 2/8] xfs_db: report the realtime device when associated with
 each io cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011047.1810817.17496823242420962977.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
References: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
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

When db is reporting on an io cursor and the cursor points to the
realtime device, print that fact.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |    2 ++
 db/io.c    |   11 +++++++++++
 db/io.h    |    1 +
 3 files changed, 14 insertions(+)


diff --git a/db/block.c b/db/block.c
index d730c779671..b2b5edf9385 100644
--- a/db/block.c
+++ b/db/block.c
@@ -132,6 +132,8 @@ daddr_f(
 			dbprintf(_("datadev daddr is %lld\n"), daddr);
 		else if (iocur_is_extlogdev(iocur_top))
 			dbprintf(_("logdev daddr is %lld\n"), daddr);
+		else if (iocur_is_rtdev(iocur_top))
+			dbprintf(_("rtdev daddr is %lld\n"), daddr);
 		else
 			dbprintf(_("current daddr is %lld\n"), daddr);
 
diff --git a/db/io.c b/db/io.c
index 61befb43437..580d3401586 100644
--- a/db/io.c
+++ b/db/io.c
@@ -159,6 +159,15 @@ iocur_is_extlogdev(const struct iocur *ioc)
 	return bp->b_target == bp->b_mount->m_logdev_targp;
 }
 
+bool
+iocur_is_rtdev(const struct iocur *ioc)
+{
+	if (!ioc->bp)
+		return false;
+
+	return ioc->bp->b_target == ioc->bp->b_mount->m_rtdev_targp;
+}
+
 void
 print_iocur(
 	char	*tag,
@@ -171,6 +180,8 @@ print_iocur(
 		block_unit = "fsbno";
 	else if (iocur_is_extlogdev(ioc))
 		block_unit = "logbno";
+	else if (iocur_is_rtdev(ioc))
+		block_unit = "rtbno";
 
 	dbprintf("%s\n", tag);
 	dbprintf(_("\tbyte offset %lld, length %d\n"), ioc->off, ioc->len);
diff --git a/db/io.h b/db/io.h
index bb5065f06c0..8eab4cd9c9a 100644
--- a/db/io.h
+++ b/db/io.h
@@ -60,6 +60,7 @@ extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
 bool iocur_is_ddev(const struct iocur *ioc);
 bool iocur_is_extlogdev(const struct iocur *ioc);
+bool iocur_is_rtdev(const struct iocur *ioc);
 
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good

