Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B319394EB0;
	Tue, 15 Sep 2026 05:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450659; cv=none; b=pvLCEHEIRgwcdocwG2KrZVo4d28eNfd0+ryTOAkQO1wbFyD6d86Tbj/oysMJXyBh9JaRECGHBtk7CCNmUS+ec1QMId3DK0Qt6pg9dogSuFU8XMh4tGYY6SuDYgzx4CSXsl5gPRqkUxBziIF/Q4Jozxe06lkFhnJGuiKDI9CzCh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450659; c=relaxed/simple;
	bh=qX3Hphxr2Rd0URLj8TB394o2oAv/huxugEh3Yb084Ak=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8UCa5V7pXcdSYbU+HQkQgYtQ0EKRUzOS1WSEirIYCtClpxdDDDKkvF56JTe/gezTquxu8yFi9Yfqr4DT0c88VvCWfzudhsz2IaY/gAbbNrYYzNXjoZ8++2GstHR0+VwzP8Pq7QUv2C2oNCk7U0zY7GVJv82DGQL+8E+ME5rzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONB44U5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONB44U5Z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E58D91F000FF;
	Tue, 15 Sep 2026 05:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450657;
	bh=Guavk7nHq9JTyoPEXZ9FnIhdwbhGGnccJiNwgtJ3no4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ONB44U5ZjOb6bSgXKc+nisVtVUIPLneDcd1duAXH4cw4AKELC4GFRFG1TTRzAfbqs
	 AsldNkUTedzXaTChayETI5Wh91yZ+8E5yS+ijfokZDULAlF7+bind6p54+T4GSwoVm
	 YAq3hTAlw1Sr0FXBiFg1RK/5KouV3D5BjVvCFbKINmozx6CGK7p4P780i26vZMJcwZ
	 KOnF86wDANxHL7QZ3eB0VD+Vaab+Z+6+j+sxtZm0rdW7RZDjfuZzo0Dz2EgEX5BuwC
	 2C+jkdLDVUSllvbmjokof47PJrtJA4Ednct133nxnVfEa3U+7e99XB7jK09Gcht259
	 GRnruHfyI0AtA==
Date: Mon, 14 Sep 2026 22:37:36 -0700
Subject: [PATCH 04/11] xfs: don't cross reference rmapbt with bitmaps if
 they're incomplete
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048585.3061055.4137479524844786489.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that runtime errors (e.g. ENOMEM) when we're trying to
compute space usag bitmaps are silently dropped by the rmapbt scrubber.
We ought to flag that as an incomplete scrub instead of reporting
cross-referencing errors based on faulty data.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: fed050f3452da0 ("xfs: cross-reference rmap records with ag btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rmap.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 0cd3eecd2ca5b4..68e2847c962bb2 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -493,11 +493,18 @@ xchk_rmapbt_walk_ag_metadata(
 	 * If there's an error, set XFAIL and disable the bitmap
 	 * cross-referencing checks, but proceed with the scrub anyway.
 	 */
-	if (error)
-		xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
-				sc->sa.rmap_cur->bc_nlevels - 1, &error);
-	else
-		cr->bitmaps_complete = true;
+	if (error) {
+		if (!xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
+				sc->sa.rmap_cur->bc_nlevels - 1, &error)) {
+			/* only set incomplete if we didn't set xfail */
+			if (error)
+				xchk_set_incomplete(sc);
+		}
+
+		return 0;
+	}
+
+	cr->bitmaps_complete = true;
 	return 0;
 }
 
@@ -567,7 +574,8 @@ xchk_rmapbt(
 	if (error)
 		goto out;
 
-	xchk_rmapbt_check_bitmaps(sc, cr);
+	if (cr->bitmaps_complete)
+		xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
 	xagb_bitmap_destroy(&cr->refcbt_owned);

