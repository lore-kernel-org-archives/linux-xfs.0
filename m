Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC0A3FD4
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530145; cv=none; b=gS1O/52JFM9BkqmiR97nDRYPfqLtmKP5m3qv7a1XLGxBUzgsE8IgpeHHOSQsQl9Z9bYG2cTRffRnIO0dBZyGVkZseIP2y8KOeOLO0optOGx1m4lrRP5g3m0TpD7d1fUjrw53ABipiGnSWlj3S4d1ZtvdzAWvjTuXfWr8wEVAlas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530145; c=relaxed/simple;
	bh=xFFtyiCDL3jR2vtj880L8EDoCKFIT2pjhV4fOKdM7KI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AztBDOnNZR5Gbcfqs6yk8Qit106AcLywHZwnYlP3fwY9jYmIsVdOSRSK4HKICr692Nsj2PG7Z97EMZZ29OR0evRLBUDw71JUZHsEgywdmqrXSk1TJhwOSBxPZRSmF+FcB2dm55Uw/Tagsee3nEVw6Pvi+sinSpEDXJHAVZpD+t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlC2QrN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlC2QrN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53157C4CED1;
	Sat,  7 Dec 2024 00:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530145;
	bh=xFFtyiCDL3jR2vtj880L8EDoCKFIT2pjhV4fOKdM7KI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jlC2QrN5ShnKxLn+5v/o1FoYOaFDTg9gjOCk98DC8ubGGEI0RbPy+Vtf8kM/PsgLW
	 A2BZLm9Hot067hI6oQ76BM43ptNeG1jWraOGjHi5IlHuVh/RIeZXb/a7nGuUyJp+6d
	 NJ8gpTqaOUtqiG2SmaTLtQoFjlECKulK7N3yTG0Qmbw5H5uBru5k6JDVdODEyuc6jE
	 +InvpCVbQJIhC1Dn65u/S8F5XGm7BMNwvMBnnSDAhE5G54UH9nIH1+1H9esL9lbZ+1
	 CophhlctTHGIi0Dy/n5fIDt5Oo55Q6m4PAx1WRJZ8bTaZwI9hjHKvI5z86a0OtTKdy
	 tlp+2+lL51E/g==
Date: Fri, 06 Dec 2024 16:09:04 -0800
Subject: [PATCH 16/50] xfs_repair: improve rtbitmap discrepancy reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752189.126362.11084949952818788504.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

