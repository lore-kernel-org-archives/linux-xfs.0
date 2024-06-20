Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D182D83
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925071; cv=none; b=XR5qOObd2uIP6Fh4shv40J/DJ9HIWms4zMj6xAvA8zORCtCdS24st8hk504RyRWNizaPyfZ8J93IZzHmKTJIkf7Czt8UMTS1BepM49stTpU2AOVBO+lieHu6okEzzn8HQWatuI5gNuxZ2gTOWrWonpa1Kpzq9WC87hFqyO0nKE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925071; c=relaxed/simple;
	bh=/h8cWPffz9nZ4VBRdOPAI2egf2fVQFsGwPIWcni1xNg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KoFnniVSJNdoTcOVCW2YQh4OjIVz+SrIH3/mp6rIkkTsq8dkJfQjvEAsJveJowycVL+0Uj82H5snP54fG3awXGasVNghuhbpAPeBT4593fEoHuS7DEy418l5om+2C2v2itkpp2TQEUs8W+ZzKVgi0XA7YUtYVlomaqB9s/hj1lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rKveCZ9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKveCZ9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058ACC2BD10;
	Thu, 20 Jun 2024 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925071;
	bh=/h8cWPffz9nZ4VBRdOPAI2egf2fVQFsGwPIWcni1xNg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rKveCZ9TdWAfcGY4sjezrn3v3EI48ed/DX93FM9SITTcJP5x/zEu2thMyBp3SSlNo
	 LLGI9eeKyHs9rQHkAzON4o1sfwCq7+ehXOqSVohPdeQTaw1EuizmC31Sg1/71/BJF/
	 W8oySdLzX02pnM7gbPDQ3PehJ74Z6Ml66O+ofJ/BanrXpXtYXCnkxeHOg64ycby/lb
	 OBGvwAzU74GmRzmHwqGVEwI3yIL/adf2/SB4Q6mTupStiww0XhJqrbw7Buf5sEDEFR
	 GS5f+e0fEfm1PiPfNhvolJvm+V/7cEixNiVhFKg2SvWWq99BYUterL0/EU+nYJJpFU
	 GOghesuArI4AA==
Date: Thu, 20 Jun 2024 16:11:10 -0700
Subject: [PATCH 07/10] xfs: reuse xfs_refcount_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419892.3184748.5587189586405596401.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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

Reuse xfs_refcount_update_cancel_item to put the AG/RTG and free the
item in a few places that currently open code the logic.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index cc53c733bef1b..90a019ddcc1f4 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -335,6 +335,17 @@ xfs_refcount_update_put_group(
 	xfs_perag_intent_put(ri->ri_pag);
 }
 
+/* Cancel a deferred refcount update. */
+STATIC void
+xfs_refcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+
+	xfs_refcount_update_put_group(ri);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
+}
+
 /* Process a deferred refcount update. */
 STATIC int
 xfs_refcount_update_finish_item(
@@ -354,8 +365,7 @@ xfs_refcount_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
+	xfs_refcount_update_cancel_item(item);
 	return error;
 }
 
@@ -367,17 +377,6 @@ xfs_refcount_update_abort_intent(
 	xfs_cui_release(CUI_ITEM(intent));
 }
 
-/* Cancel a deferred refcount update. */
-STATIC void
-xfs_refcount_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_refcount_intent	*ri = ci_entry(item);
-
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
-}
-
 /* Is this recovered CUI ok? */
 static inline bool
 xfs_cui_validate_phys(

