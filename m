Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F80057314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423204; cv=none; b=i2Oivibwhg/ILhlow2963dKykwRY4MTzmnvsymAd1SJr7NfhAAKOsOI6DW+cuBtE5wicrdmj2C+CkMJGAGaTsaBA3jMjpuMg3KUIr/pLKBSSwThKe5quOd3/IGtbKhOVq8sPxxbaQhPJ2KKEjcaJc5jTxI5lYSWMnGKmpNMTB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423204; c=relaxed/simple;
	bh=baXrYmGK7Ep4AvJSxTG/fedGbhW8EgiQkHMmnuLvkF4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eee0Wa2r7URXNBZJOV1LmiNm+CQBkcFwUGkf341uYYd03OHzVzLPsr/Ir7Xuq1RyxM13KVhCnHJuJnnI3c/3zUy+wO+b+7HCRLQHANWM7rvsQwzA27o0/gTnaqngXvy6HV8HzpthM+qNt5f+4t7qVgxXK83T7sMTFSB7P1ugJ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+HbMQd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+HbMQd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27299C433C7;
	Tue, 26 Mar 2024 03:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423204;
	bh=baXrYmGK7Ep4AvJSxTG/fedGbhW8EgiQkHMmnuLvkF4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B+HbMQd6G3D2+gwapXIhUOEKQrUP/MnkHXl40Faj3WUJs90umtd0DBVE3W4KjdeMz
	 V4Vqx1oTlFqIwLUSaR5Hkb7gPW01DBF97ASAdGEAH8CbOeeAuA2QQquEGYa/1SXAFk
	 fiSYLEtmcLaeNqvw1Cel+etvcC5CkwdTRXUzHnUheQgvz7BMQJs8ggyKxfP+MhGRDg
	 aSRhskn8Wu9DN6880Pa8KGRsMfLBTXg+KooVKYTyU/XXTIrfiR5LvPfGRtT5yJlR0K
	 f/oOJO50JcIqgF16El2GbLF2syNmA0TUsQEAQOiw9YsGCX5ltFjuEEAkEBGWTskpan
	 SgA4W+0yJIwrw==
Date: Mon, 25 Mar 2024 20:20:03 -0700
Subject: [PATCH 66/67] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127909.2212320.6884202318354959465.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Source kernel commit: 82ef1a5356572219f41f9123ca047259a77bd67b

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1419846bdf9d..630065f1a392 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -419,10 +419,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 

