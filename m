Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0003A451D;
	Thu, 13 Aug 2026 05:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598831; cv=none; b=hUf8cV00xYgUBT6oJzjTpFPnXgxFT0/W/R5jJMqBew2sVmEgbeyxkieLqhUE5afT6BV6FxBzdPrHyW6ZOQ32OXei4IgPycxeIJz/TZEfRGElcQ86bZK1USRZwJaJPZc+uirf2asYjjeTGYJNKj8aDPp6SGAN634xg6pvYQvSpbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598831; c=relaxed/simple;
	bh=yj67piyJNNTZoXCr0fUE8P/uNzspASTnXYcJXldE1VU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iuiuOqV9zW2D3UXGSekTnw0hHyKFwssni0gWXvvZyYrfeOvixOvaDix9q0cGweVCUBXMvMsOjyse/kdBIuL9GHmkjzTlDK314DpjjtfLefkkvTDaicL71O3EKqiqXQ220qOi4+8UxtfC8dOq0G7MWCv2Sp8gyn6ulrfyG7CTang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ar6Bcrzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ar6Bcrzw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2086D1F000E9;
	Thu, 13 Aug 2026 05:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598819;
	bh=8Y8g297myVSLIk9Q4BQayktDEJacS7gO/k3q//TCKS8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ar6BcrzwPOe//y6uQQUII2Xqn6OWs+RUvfRDXr0U7Gp+vJN85LUaeblZEfyUft0Pg
	 D+asq3VyXRJc5LUtlSoglHTfF2D6c6b8BhpdINy8Bxf6++R7HUBXWqB1mxRD3pZwVG
	 HgqkyRVIPEFj4kZcxIIDAiwDq/ewVXCQiKJMFSBPRb78OFn0qOvABxwfT9AHbzeQuG
	 eJyA11jeBe9u5CD4dpWkdUa9CbtBhUFVUjini9pVe0gdwtDeyS8hVUdGjN58hpp4OG
	 PfA0glufKYIBj8IQ1ok+s/Yd6kINfzgjbMrtU2tsuHitiedvOmabP74AyEI5ebqDCh
	 eJuMAGOgCTgkQ==
Date: Wed, 12 Aug 2026 22:26:58 -0700
Subject: [PATCH 6/6] xfs: fix bnobt repair space reservation disposal failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659862005.833922.13291793696473888206.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
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

