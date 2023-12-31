Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8055C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIY8U0BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BCFC433C7;
	Sun, 31 Dec 2023 23:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066845;
	bh=fJR7FiQZ81/7yi17dina0EiRqHQFLmjOENF0+OyteGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UIY8U0BE8ILkaQB+iuri9NL0WC6FPmyKi05gby3bWoofdJec2aAW9+JVEIzWF9eY4
	 gSLfuH/sVdSJSZk5WHUY9qGrdaQ2JlABNTSYinm0fJn84KcZ7BOLdkGmx3gazRBgo2
	 hdohn2GGTJjLGsnrDP0HtWzaiZobZ17X7i/Pzv+tryHK3Bag2fqWcN1tcvSNdJM9T3
	 K2PtFRnQy3pSUVml7cYffLyABIWoHcwrZMYWkjQeMAU7V7/kAxRlvKF9ppxfTuv8T4
	 HzpxX/iW2dluMwlpXthdFSFCye9NJwJ8+KVcqcO1W26+zeq0gFHPBOI6eRUYmjjdiW
	 TfduHmC2IRq9Q==
Date: Sun, 31 Dec 2023 15:54:04 -0800
Subject: [PATCH 25/52] xfs_repair: improve rtbitmap discrepancy reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012501.1811243.1771736446367395615.stgit@frogsfrogsfrogs>
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

Improve the reporting of discrepancies in the realtime bitmap and
summary files by creating a separate helper function that will pinpoint
the exact (word) locations of mismatches.  This will help developers to
diagnose problems with the rtgroups feature and users to figure out
exactly what's bad in a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/rt.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)


diff --git a/repair/rt.c b/repair/rt.c
index 5576511e7a0..f73760e9cc9 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -150,6 +150,44 @@ generate_rtinfo(
 	return(0);
 }
 
+static void
+check_rtwords(
+	struct xfs_mount	*mp,
+	const char		*filename,
+	unsigned long long	bno,
+	void			*ondisk,
+	void			*incore)
+{
+	unsigned int		wordcnt = mp->m_blockwsize;
+	union xfs_rtword_raw	*o = ondisk, *i = incore;
+	int			badstart = -1;
+	unsigned int		j;
+
+	if (memcmp(ondisk, incore, wordcnt << XFS_WORDLOG) == 0)
+		return;
+
+	for (j = 0; j < wordcnt; j++, o++, i++) {
+		if (o->old == i->old) {
+			/* Report a range of inconsistency that just ended. */
+			if (badstart >= 0)
+				do_warn(
+ _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, bno, badstart, j - 1, wordcnt);
+			badstart = -1;
+			continue;
+		}
+
+		if (badstart == -1)
+			badstart = j;
+	}
+
+	if (badstart >= 0)
+		do_warn(
+ _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, bno, badstart, wordcnt,
+					wordcnt);
+}
+
 static void
 check_rtfile_contents(
 	struct xfs_mount	*mp,
@@ -206,9 +244,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
-			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
-					filename, (unsigned long long)bno);
+		check_rtwords(mp, filename, bno, bp->b_addr, buf);
 
 		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
 		bno += map.br_blockcount;

