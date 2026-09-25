Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B00A37418C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 04:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309557; cv=none; b=Ru9Sbtt1BQVl0E7c0s757iVkYFqPVN3azYs03tkHAA6JsKD4It9glk0vCVkiE24QKDfKk2yWVAgmoL6nq2ZmzE+TiGW+xSX9KrfPxi1Hea9ohQb1tulSH/Sp6EYhBJDzIKcEiqTQvhWigGsK1sdR8eS4WxiWflqntqjR0WhIvpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309557; c=relaxed/simple;
	bh=3p0rKGvm+zDSJgwDVgk7sgjbn3T4FCIQS//fKnSFdfs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FwhGQVqex3v3QL5beSFpVZYhAKhvVkPNxKloPAH86I+FjO8IpMAtmCZ7NK2Ix/yPCzDTSY22VoAzP2O/839puZCYM5x/P0jvVo7/qUutnJF+NRP+zwmhDGIM/eHlhg9RbGuqdbntLtm0ZmV4sU3Y4vNNWZuIGCnPUvTwjpkzSUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtCsypp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtCsypp/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0951B1F000FF;
	Fri, 25 Sep 2026 04:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309556;
	bh=sjIJZFCtsvDgxuI4qlYGrDa64/3HSY2s4tUyGi9wASQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LtCsypp//EpRTB5MPNTpUFHmarcpvdi2XdRM50E9UCq9jLNmi3nW/KFRlfgteuWjI
	 I6wPCTyxnRiixL9ZdQuMvmZowgKRF6Oq0vC7Mk0eVpc8ENacSUHVhAYKbVDP61mN5v
	 QQxoaXuDifc7+tlEFq3D/ZZCZCNzKcCoW6NsMlruXYcJ89EA/nVWkk1OlcYXW+GBP5
	 nTcNT1wfRr6o5lf08BfSimaWopJ91atNlo1Ujd1Rfv2Hxer8lWENqakuf4d0Fv02eC
	 klEKFFRX0YxF30CDvZNDk+5WIV4lr6QiEwQZjTaf4ucShMp3R4XXe/KDfNCD/CNVMA
	 ELoEbH0f5A2pw==
Date: Thu, 24 Sep 2026 21:12:35 -0700
Subject: [PATCH 08/12] xfs: read primary superblock from disk during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179030932219.3344850.3980099326844933037.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The primary superblock scrubber isn't that useful right now because the
disk contents could have been corrupted after mount time.  Perform an
uncached re-read of the super buffer to perform a fresh verification,
and schedule a repair if it doesn't pass muster.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 43f3c3a5060b51..a765d3e5e0686b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -119,8 +119,40 @@ xchk_superblock(
 	if (!pag)
 		return -ENOENT;
 
-	if (agno == 0)
+	if (agno == 0) {
+		/*
+		 * Reread the primary super from disk in case it's become
+		 * corrupted enough since mount time to fail the verifier.
+		 * Crashing now with a bad primary super will prevent remount
+		 * (which might recover the primary super from the log) so we
+		 * want to trigger a repair to write the incore primary
+		 * superblock out to disk ASAP.
+		 *
+		 * Note that we don't check the geometry (like we do for a
+		 * secondary super) because the incore copy is the source of
+		 * truth while the filesystem is mounted.
+		 *
+		 * If the read races with a write, we end up writing the
+		 * primary super unnecessarily, but that's not a big deal.
+		 */
+		error = xfs_buf_read_uncached(sc->mp->m_ddev_targp,
+				XFS_SB_DADDR, BTOBB(mp->m_sb.sb_sectsize), &bp,
+				&xfs_sb_buf_ops);
+		switch (error) {
+		case -EINVAL:	/* also -EWRONGFS */
+		case -ENOSYS:
+		case -EFBIG:
+			error = -EFSCORRUPTED;
+			fallthrough;
+		default:
+			break;
+		}
+		if (!xchk_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
+			goto out_pag;
+
+		xfs_buf_relse(bp);
 		goto out_xref;
+	}
 
 	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
 	/*

