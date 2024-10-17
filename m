Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02020100C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191268; cv=none; b=STb50D519bN93PCrx2xjoYpQp0VT+26vb06SCW2ZbrIYg8Bi4ig5dJta88ry4sOLkO/YmFjoFlT6PR1/D2XE+Eg0E9a9jpIyQ0VYay67qxYpfDcnkbd9CUcBydMZEWkf0kWPcGo9o+TLed3sKThkikDyOVAf3C6ASG4vq2BvUvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191268; c=relaxed/simple;
	bh=EDO4OYcQrMAaIyf2Y3ZlWO1EckiVk+A0KqU7Wd3e5Us=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqdDBM2bpj/rNoPpDDAoCKSQpyvr+350BCg9COabur+zJBE7JMl0TsPSYmoJ3pJJBn7cbsU0h7EYFRf16DstWn+Ok2ePPStywCGvhzJWGlkvHsnUySkiyh+LXq0TlkeUaxGivFzY0tTPNKsxGtJs4Xh0vbhPr04QwYDqhRXEXxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0tkaBaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0tkaBaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE9EC4CEC3;
	Thu, 17 Oct 2024 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191267;
	bh=EDO4OYcQrMAaIyf2Y3ZlWO1EckiVk+A0KqU7Wd3e5Us=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o0tkaBaHMXi39Dt3eBpe3syGAlW+qFjvELT9/+x02OQ6ecXnqLII8Ljs0isXclP+r
	 gaLRPUXPfPdZd9Dp7Epf8n1/OelbtLX5XKyUUTHjjlJnIHZqIwd2aR42PxVPay+y8g
	 zYLP4DGciMH972qT0YZTqfe72iqoZYj9Xzc37NdvF/5e6fGuKq0lPs/FCPGfTkm8Zy
	 Ik90Yj6BU+0cOlZgY6O2xFMxxwjDjkEKrGJP9iiG4FZLwSyCyQB3cw9D1lEKL74Iq8
	 wdayi2j/tIsxIkI3V8zVFGosBvCrzH4LyimAqBgBSjSr+HALyHnWzRyxNG6aVS0EmR
	 33PFIVPbHMqJw==
Date: Thu, 17 Oct 2024 11:54:27 -0700
Subject: [PATCH 15/16] xfs: remove xfs_group_intent_hold and
 xfs_group_intent_rele
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068939.3450737.15216048626404761589.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Each of them just has a single caller, so fold them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_drain.c |   36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index a72d08947d6d10..7a728a04f7a6b1 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -94,31 +94,11 @@ static inline int xfs_defer_drain_wait(struct xfs_defer_drain *dr)
 }
 
 /*
- * Declare an intent to update group metadata.  Other threads that need
- * exclusive access can decide to back off if they see declared intentions.
- */
-static void
-xfs_group_intent_hold(
-	struct xfs_group	*xg)
-{
-	trace_xfs_group_intent_hold(xg, __return_address);
-	xfs_defer_drain_grab(&xg->xg_intents_drain);
-}
-
-/*
- * Release our intent to update this groups metadata.
- */
-static void
-xfs_group_intent_rele(
-	struct xfs_group	*xg)
-{
-	trace_xfs_group_intent_rele(xg, __return_address);
-	xfs_defer_drain_rele(&xg->xg_intents_drain);
-}
-
-/*
- * Get a passive reference to the AG that contains a fsbno and declare an intent
- * to update its metadata.
+ * Get a passive reference to the AG that contains a fsbno and declare an
+ * intent to update its metadata.
+ *
+ * Other threads that need exclusive access can decide to back off if they see
+ * declared intentions.
  */
 struct xfs_perag *
 xfs_perag_intent_get(
@@ -131,7 +111,8 @@ xfs_perag_intent_get(
 	if (!pag)
 		return NULL;
 
-	xfs_group_intent_hold(pag_group(pag));
+	trace_xfs_group_intent_hold(pag_group(pag), __return_address);
+	xfs_defer_drain_grab(pag_group(pag).xg_intents_drain);
 	return pag;
 }
 
@@ -143,7 +124,8 @@ void
 xfs_perag_intent_put(
 	struct xfs_perag	*pag)
 {
-	xfs_group_intent_rele(pag_group(pag));
+	trace_xfs_group_intent_rele(pag_group(pag), __return_address);
+	xfs_defer_drain_rele(pag_group(pag).xg_intents_drain);
 	xfs_perag_put(pag);
 }
 

