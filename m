Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D414A8B
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610046; cv=none; b=VG5d5QMfE/5ICgW348q/zop8yjs3If5v4VzgJrJ0GS2ak3x8k/8HOkVKfbt25WpuOz83mxd/wTPsnzW+SU8iuiACYpw0gG++DMKhuhFgfGaAEnk0zo7DWa8JwowbiyQs87ZJU+DLsvBxQQT+OMaXOZuHuZu1/9dB4qvmEshK7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610046; c=relaxed/simple;
	bh=xbvo58XWHu8CaLlnDKebBlUVWLYCgunZjNFBxh3Kpgk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVwP99SxhTyiG+w5ZJGNr1uYKPkmjrcMlUhPKM4CZlwX/6lResEBEHfdr0JhRKPt8q+6DP8CtetLc7QPLUWvPP7tSnf88S4GRXYtHpK0lVf4686EbfT4wA0bS7F3L49xCSskKoX9J/u3d6BZqXfDGUm0qAEM1jnKQ8FOahJyBdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RT6HiQVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RT6HiQVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E79C4CEC5;
	Fri, 11 Oct 2024 01:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610046;
	bh=xbvo58XWHu8CaLlnDKebBlUVWLYCgunZjNFBxh3Kpgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RT6HiQVUUAheOH/qVBW2GxgF2HFj8EPlqfIjV6pTruhY/qoKnBkhd5IZD0IQN0HyT
	 qVWanqq3+cHPWq8s1jxPLpugmxgoYSMGaMn/4f0PqTU5Q88zpBV+MCW7tH/OcKlLXT
	 JO8Ofah+io/th7JwBTz7/RviZigxuNGAWQOmEFpdN7YQf8T1QHPGDByWi9wPHbcR4u
	 S3d/BAMxowIINj9MLYDxsMmL3t225MZUuXXI1WRlKvY1ifiy3V2NwLPJCBDTZaFuY2
	 IvwvS4M7O6iZQKr/6dsF/CLYbjGji5aQxckavx4v60omtH983Jh0WHDj60A1aWfRuQ
	 GQC/GtaWxPjTA==
Date: Thu, 10 Oct 2024 18:27:26 -0700
Subject: [PATCH 11/43] xfs_repair: improve rtbitmap discrepancy reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655534.4184637.9047995804341717005.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
index 65d6a713f379d2..a3378ef1dd0af2 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -131,6 +131,44 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 	}
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
@@ -203,9 +241,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
-			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
-					filename, (unsigned long long)bno);
+		check_rtwords(mp, filename, bno, bp->b_addr, buf);
 
 		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
 		bno += map.br_blockcount;

