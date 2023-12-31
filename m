Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D039B671
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJTfqGkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7825C433C7;
	Sun, 31 Dec 2023 20:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053676;
	bh=Jm7ZwVE4AZYwsVyJeRm4wZsMYgEmjVsDz1PJZFZUGT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KJTfqGkwgv1+f+yjQo0PYd0sdIhvS5yz1TR0wCG0jm82FnDMYhCORHktFjfejl60E
	 kNRpynO+VFzwwVB1pk+fr6JEzuMGxBOF/ahUZ3cQXeHYNeE2iDWtmWd9btPmMORvCt
	 wWhXFf1Ri5SFXvfQsMbi/AR68xVl2wSqg8e1pLZwLfdAbOTdYcYXdyjtQQPu4etVGA
	 oO76lroPj4HWTpBYteAa00JF1BVbFI4xt1PHJJuCFj1NHpRWIAiwr/3hM/xxaNGTa1
	 if46XTFYbZgOUssZr72avEwSyd5U72/h9ZTJ0vNtZ60S27cwDXk0eNMjRnQRJ69BQb
	 tmopuvJrLdftw==
Date: Sun, 31 Dec 2023 12:14:36 -0800
Subject: [PATCH 4/9] xfs: make GFP_ usage consistent when allocating buftargs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829643.1748854.8931317156367817589.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
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

Convert kmem_zalloc to kzalloc, and make it so that both memory
allocation functions in this function use GFP_NOFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0ae9a37cd1ddb..05b651672085d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1981,7 +1981,7 @@ xfs_free_buftarg(
 	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
 		bdev_release(btp->bt_bdev_handle);
 
-	kmem_free(btp);
+	kvfree(btp);
 }
 
 int
@@ -2026,7 +2026,7 @@ xfs_alloc_buftarg_common(
 {
 	struct xfs_buftarg	*btp;
 
-	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
+	btp = kzalloc(sizeof(*btp), GFP_NOFS);
 	if (!btp)
 		return NULL;
 
@@ -2042,7 +2042,7 @@ xfs_alloc_buftarg_common(
 	if (list_lru_init(&btp->bt_lru))
 		goto error_free;
 
-	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_NOFS))
 		goto error_lru;
 
 	btp->bt_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-%s:%s",
@@ -2063,7 +2063,7 @@ xfs_alloc_buftarg_common(
 error_lru:
 	list_lru_destroy(&btp->bt_lru);
 error_free:
-	kmem_free(btp);
+	kvfree(btp);
 	return NULL;
 }
 

