Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01808292099
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747050193; cv=none; b=SqoCyxKpx8vFoTG2+3rrV3yGkACgX5UhsIdKc2x+S8r37J/hbpu/sC/lV3LsWMOcUA8ffeiHPmQHUtExJ1RFrTKro44hxT2VVA5JoM3aOL+mL4q7YP3RNM2x7wFwnHSOt2m8ssHuCfQJNDO5jDlZrG563+NvyjC0tUrsO7Vnnuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747050193; c=relaxed/simple;
	bh=ZrRrPxPnncjWzvnAcRUPO8zXKeGkz0uWc/iOGE+/0uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7rgpRgyy400SHUyoifh+iN34alYMFpMv4duq+TcOE1dc9bDFScRzB0wTkVZtBZ5SfvbpVXPSZE38K6KfDoL+UFH1jWc9jiPIBII+jzNNyKKY5MoFP/5/pWrvcrAWmcyPfX5x3c5diTpQEKU/vs2VYIP7ZBrKiD7xGbi0DwWShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fI6ZReIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fI6ZReIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1838CC4CEEE;
	Mon, 12 May 2025 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747050192;
	bh=ZrRrPxPnncjWzvnAcRUPO8zXKeGkz0uWc/iOGE+/0uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI6ZReIKLvPR70aEnqS7pUDk0N7xkm8DwVAF2ddxxddBqMWnxci6Q7dXv/zMJRKhu
	 JsLqGJ7Uxkm5PclnqTWal6zY0LTYlU0nsqWK9/oJPKSH+EB6gV10dug37s8LiXhkI1
	 R+HrW8YlwrK6zAcNfeZiaD44tvpZRdHWYkJBUw025XP8Me5cET409Lmw814DI2HhU8
	 fh4cN9pIRLGcq9eVzuraIY9CKZAIK5lBRRS/j2PdrFfxwOqHwgyILd7hKwSbEW0tp3
	 YbI+uV95vVrYTkWG521Z+4f62634u6QhhbspFZ+LT9oiNBWknELZUFwawjw0kOSRzv
	 2RRXP3P3jrYaQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	david@fromorbit.com
Subject: [PATCH V2 1/2] xfs: Fix a comment on xfs_ail_delete
Date: Mon, 12 May 2025 13:42:55 +0200
Message-ID: <20250512114304.658473-2-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512114304.658473-1-cem@kernel.org>
References: <20250512114304.658473-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

It doesn't return anything.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
Changelog:
	V2:	- Update subject to include xfs subsystem

 fs/xfs/xfs_trans_ail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 85a649fec6ac..7d327a3e5a73 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -315,7 +315,7 @@ xfs_ail_splice(
 }
 
 /*
- * Delete the given item from the AIL.  Return a pointer to the item.
+ * Delete the given item from the AIL.
  */
 static void
 xfs_ail_delete(
-- 
2.49.0

