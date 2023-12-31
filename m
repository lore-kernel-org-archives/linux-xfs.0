Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28798C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np9I/jCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5AFC433C8;
	Sun, 31 Dec 2023 23:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066970;
	bh=htVxWdfzEXcwQYeCQarIE14gnFA9IfG03qSveSO3b64=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=np9I/jCapuMWCl/dfatpct++PkfVJhqLZBS1l46EjcVY2b2Z8LQTqsvYaPABo2PWD
	 eKaRPjUgkP8Gw3f4+t2v17c8yAZKVgUmm+s67VkbvFhND/w2pMJEyQHQIWEj1X/knG
	 U/yWzJAOS/lTSzb9/xvg6Vur7fKntlUtI2SfbgfOKjc3BCVTRAc5SJYLSRyg7fPSqA
	 erMDBl4hKcv1wQ/O3BeeymDxeMl63kh3li4FchDdtzCz3ec6mF1Q+7eZDJXFwMa3kS
	 Xj7tTgQgzd2LLb7h5SChBd9XZ6HZSvQsVRBHZqkW765F/a+vlFiD6MmtsesAPjAnsk
	 mNzSXP2KcY9iw==
Date: Sun, 31 Dec 2023 15:56:10 -0800
Subject: [PATCH 33/52] xfs_db: implement check for rt superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012607.1811243.2083492752605436904.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Implement the bare minimum needed to avoid xfs_check regressions when
realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/db/check.c b/db/check.c
index 0c29c38eee0..7d0687a9db7 100644
--- a/db/check.c
+++ b/db/check.c
@@ -56,6 +56,7 @@ typedef enum {
 	DBM_BTREFC,
 	DBM_RLDATA,
 	DBM_COWDATA,
+	DBM_RTSB,
 	DBM_NDBM
 } dbm_t;
 
@@ -187,6 +188,7 @@ static const char	*typename[] = {
 	"btrefcnt",
 	"rldata",
 	"cowdata",
+	"rtsb",
 	NULL
 };
 
@@ -809,6 +811,23 @@ blockfree_f(
 	return 0;
 }
 
+static void
+rtgroups_init(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		xfs_rtblock_t	rtbno;
+
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+		set_rdbmap(rtbno, mp->m_sb.sb_rextsize, DBM_RTSB);
+	}
+}
+
 /*
  * Check consistency of xfs filesystem contents.
  */
@@ -843,6 +862,7 @@ blockget_f(
 				 "filesystem.\n"));
 		}
 	}
+	rtgroups_init(mp);
 	if (blist_size) {
 		xfree(blist);
 		blist = NULL;

