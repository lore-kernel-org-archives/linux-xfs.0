Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E89155757;
	Wed,  2 Sep 2026 05:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327894; cv=none; b=RjRw+4qaX7wmuoQw6FX3dg2h5d7Dkl/lyR8wEkR87jbl3ZGMZq4HUX+i+9Ez1iOY5q3POOvwX/D25j+94/r+AFPVclrftv2zpFhcCBFPY0+pmBWwE0wI+VuqbnUq7wwO637JiseA8VOvZYPu+MoEkWYT8PwkDcsqBX6Iz1OuKRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327894; c=relaxed/simple;
	bh=OjX9ZpTPdoqc2G7NW/pXmu/sveVrO9C8UWHCietsrnQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/22sG3Y0xFRyQjJ45ctEca4LAshpyPk/QhaLei1OA4kiUzVxio7hMv3CGlYj4eXc0bzIl7OxyhAfhMe7i3ica5I1bcGcIbdy99RTu44L6dkhueihiXryWJ2nEgbSxk4pMzJ5Vhex0/dHkP2k9qM+mrgQvnOMCPzGq6fWPnVWfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbOls7s8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbOls7s8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E42C21F000E9;
	Wed,  2 Sep 2026 05:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327893;
	bh=7VToqIbNigHuAubz5lk1OfQbRfK+VT8UpAC7jXFC8fM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VbOls7s8l5wLU57kvswWKZxZGvOq6XCd43yNriIUBPaJ74097qcOtgDYPc8SJTyic
	 WsmeVGf5ESvFLJegHFA2iyG/vO/NxuQ7ZcwezjSYnk4/XSt+LVhMef7dcaf/a+q3HU
	 Rro7i4bGRUZH6s9z3ohjNr/jw387Kp0YJ08emesQSapxW9zaBcOC/cVIpukyx2JCRV
	 LjfayMiqHjHCnpmEtDomnIXe07/ArbX5Wtr9y5V56cfo75H7Aq7J4pUOG3MggSr6+w
	 5co62pbgO4eVktKjQhrQtrYF/v2VuQxNHO0wD6krdpQeO1nuPMd7ewTvQ7Uw5yCtUy
	 ffiY1mvpTlJlQ==
Date: Tue, 01 Sep 2026 22:44:52 -0700
Subject: [PATCH 6/6] xfs: fix bnobt repair space reservation disposal failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749549.3507209.7789046496766271639.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we don't bubble failures from xrep_abt_dispose_one
upwards in the callstack.  A failure to clean up the space used (or
reserved but not used) by the new bnobt/cntbt should be reported.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/alloc_repair.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index dce6ab0429dcfe..95e318e4f3a6c7 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -571,7 +571,7 @@ xrep_abt_dispose_one(
  * allocation, and blocks that didn't get used can be freed via the usual
  * (deferred) means.
  */
-STATIC void
+STATIC int
 xrep_abt_dispose_reservations(
 	struct xrep_abt		*ra,
 	int			error)
@@ -582,9 +582,13 @@ xrep_abt_dispose_reservations(
 		goto junkit;
 
 	list_for_each_entry_safe(resv, n, &ra->new_bnobt.resv_list, list) {
-		error = xrep_abt_dispose_one(ra, resv);
-		if (error)
+		int		error2 = xrep_abt_dispose_one(ra, resv);
+
+		if (error2) {
+			if (!error)
+				error = error2;
 			goto junkit;
+		}
 	}
 
 junkit:
@@ -596,6 +600,7 @@ xrep_abt_dispose_reservations(
 
 	xrep_newbt_cancel(&ra->new_bnobt);
 	xrep_newbt_cancel(&ra->new_cntbt);
+	return error;
 }
 
 /* Retrieve free space data for bulk load. */
@@ -801,7 +806,9 @@ xrep_abt_build_new_trees(
 		goto err_newbt;
 
 	/* Dispose of any unused blocks and the accounting information. */
-	xrep_abt_dispose_reservations(ra, error);
+	error = xrep_abt_dispose_reservations(ra, error);
+	if (error)
+		return error;
 
 	return xrep_roll_ag_trans(sc);
 
@@ -812,8 +819,7 @@ xrep_abt_build_new_trees(
 	xfs_btree_del_cursor(cnt_cur, error);
 	xfs_btree_del_cursor(bno_cur, error);
 err_newbt:
-	xrep_abt_dispose_reservations(ra, error);
-	return error;
+	return xrep_abt_dispose_reservations(ra, error);
 }
 
 /*

