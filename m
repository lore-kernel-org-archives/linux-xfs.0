Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ABD18DF85
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838215; cv=none; b=G/sLwSlZYsZv71jwG/NcsLHNXawhIoNxrXV5wFUCh8neDt+YsYkPVcuDoOG1Oe5Ngujlcu5ewhK70HqNSgHrO22wWqp/Mq2tTxbiwOS+X7NUw+NNUdhNuYAUp7isoxiiBKbflV66EMmlm37N+EdmUPQPJRtq0MiYclKKjKTiJFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838215; c=relaxed/simple;
	bh=NgO7z3TYt2jtT1+faAZdwvuECjOqF94AKAkKPZNbpKc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MaiTjjaYjUVC6ORm+5SBFTPfTxl/VwnC3IgQ4vPY5YAkvcouV+R4+S6x1y8s2yuarD7GsfN62aoNXHeOTV363uKn3Yy1+Imeg+m26iRvgffUiqM6XPR4sDAzjWjzuc/XkoBvwmhcf0lFoD8w5d8wGjbSSDCUxAaVzMZBrQpwhRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sy9/Ov4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sy9/Ov4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9058EC4CEC3;
	Fri, 25 Oct 2024 06:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838214;
	bh=NgO7z3TYt2jtT1+faAZdwvuECjOqF94AKAkKPZNbpKc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sy9/Ov4pK6juoZjoPjtlLKcG9xUpIB7fNdVTo9eKnWF/11PuUsBfHg8bAy6otExjJ
	 J8qgFMBknxmF509P3PLCo5nUh/RVRHUQoOO/4QSeLFpd77tk0VGI2cnOq25IlB4h1Z
	 Kge87U3EjydgUzkhtSHdZtIltqNWY5eGdH2S0zPoAQviK1YsaghHv2TLQ0enELeE18
	 G8AT7JezyoPyfGzay/zyI8cz+xevYq3myW7XsaaVN+vX0mOYuGjeTqQcDWUEZPKXZx
	 iczjY1LThOJAmsFJFX10CQCsAnhM61CDNN5hz3KlmX44zna37c2a57ptuMchQWzd3p
	 lLAbpN73wjNsg==
Date: Thu, 24 Oct 2024 23:36:54 -0700
Subject: [PATCH 1/6] xfs_repair: checking rt free space metadata must happen
 during phase 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774454.3041643.14059149217223950457.stgit@frogsfrogsfrogs>
In-Reply-To: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
References: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back in the really old days, xfs_repair would generate the new free
space information for the realtime section during phase 5, and write the
contents to the rtbitmap and summary files during phase 6.  This was ok
because the incore information isn't used until phase 6.

Then I changed the behavior to check the generated information against
what was on disk and complain about the discrepancies.  Unfortunately,
there was a subtle flaw here -- for a non -n run, we'll have regenerated
the AG metadata before we actually check the rt free space information.
If the AG btree regeneration should clobber one of the old rtbitmap or
summary blocks, this will be reported as a corruption even though
nothing's wrong.

Move check_rtmetadata to the end of phase 4 so that this doesn't happen.

Cc: <linux-xfs@vger.kernel.org> # v5.19.0
Fixes: f2e388616d7491 ("xfs_repair: check free rt extent count")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase4.c     |    7 +++++++
 repair/phase5.c     |    6 ------
 repair/xfs_repair.c |    3 ---
 3 files changed, 7 insertions(+), 9 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 5e5d8c3c7d9b96..071f20ed736e4b 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -401,4 +401,11 @@ phase4(xfs_mount_t *mp)
 	 */
 	quotino_check(mp);
 	quota_sb_check(mp);
+
+	/* Check the rt metadata before we rebuild */
+	if (mp->m_sb.sb_rblocks)  {
+		do_log(
+		_("        - generate realtime summary info and bitmap...\n"));
+		check_rtmetadata(mp);
+	}
 }
diff --git a/repair/phase5.c b/repair/phase5.c
index d18ec095b0524b..9207da7172c05b 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -694,12 +694,6 @@ phase5(xfs_mount_t *mp)
 	free(sb_ifree_ag);
 	free(sb_fdblocks_ag);
 
-	if (mp->m_sb.sb_rblocks)  {
-		do_log(
-		_("        - generate realtime summary info and bitmap...\n"));
-		check_rtmetadata(mp);
-	}
-
 	do_log(_("        - reset superblock...\n"));
 
 	/*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e325d61f10367e..3ade85bbcbb7fd 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1318,9 +1318,6 @@ main(int argc, char **argv)
 
 	if (no_modify) {
 		printf(_("No modify flag set, skipping phase 5\n"));
-
-		if (mp->m_sb.sb_rblocks > 0)
-			check_rtmetadata(mp);
 	} else {
 		phase5(mp);
 	}

