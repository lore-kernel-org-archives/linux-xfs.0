Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A448A20102B
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746611568; cv=none; b=OoBA5SmBYYlAZYbXk2VxsqRUfJKjSIg0ZnF5bYQ2YTaL5Ih3JcO5VrWNgLlyRtbOOrP/ymMWydFXYLRVKMijFubSt03udvkwd7iOzztuh7DPx6JqlrN8wtEjmTQT6oyOxV1awSYxW19wOjiNAesSP9D7PdEos3yly3D179PTAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746611568; c=relaxed/simple;
	bh=kTsM0NHj4mYuuRP91dMqzPZspnlMn2AHEw57g9aUMaU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2oSPIG/hkMrvmNqCkrweSaoscMAkdf9g0h1+uomJ397I7e1NilgunFqvGhYWSkjFk//N/kdOZps5fug3cZwWsh6szoI+/ITK0NYksUAzq+dUiTwa1SO2nzDIF5/2Y0ZgkyOgt+Z0Dbfzzbyk0lr88i6dkDPEoDLwTSv8UYcwhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TLudexeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLudexeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69276C4CEE7
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 09:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746611568;
	bh=kTsM0NHj4mYuuRP91dMqzPZspnlMn2AHEw57g9aUMaU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TLudexeOg3xM7ZWoGjhORzsMtuUg8ZUvxWnmtDc/snQCoYQLfMtFPpxq/bIme8p4Y
	 XX4XAhEnfx4rnh+KRMAj5wnKY9Zf79GNttk/fomh5lcReZbt24EGTfnazRmEaFlQ1V
	 SmXHu53iHJu9tT3tWRtj2jUH8xX5P1eneTP21k91+WYIutpLJFikAzX0jH3m6fseXd
	 tuGKkv1ARZtZuZV2PvHmTB1rDTL2KG9tH2JQM6hnLFTRm2xbkDmcEDoLGC+xLwyp15
	 GT9KdY9VmPCXWbMhKN2pud5JFbXLPb9XNAsmePz+JcVvtzByIKy/p+hkzlZ2xosvCc
	 P2fX8HOsBShpA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] Fix comment on xfs_ail_delete
Date: Wed,  7 May 2025 11:52:30 +0200
Message-ID: <20250507095239.477105-2-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507095239.477105-1-cem@kernel.org>
References: <20250507095239.477105-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

It doesn't return anything.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
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

