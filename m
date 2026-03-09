Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5EE362120;
	Mon,  9 Mar 2026 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084283; cv=none; b=RgVfhMWFaI6z2yASurGss++iSAiFQcyGfKc7OHDB8uhP2xCC9PZwC03ElK/hIgD/GW3AOvLY9ranYb9FA2J8jQT8M5Hq93oNNUvhCwGz2Zag+VVN9y1+iGlB+Ms9Fm8C/SAyFZ1zGEScGy//QvUgs1KJPRtZd60aMBoXky6Mnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084283; c=relaxed/simple;
	bh=wy0fgG+OqF6cw22y7JDQIN2MJp1BJ6acjGWjdLKi8F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXMWAGkqH+2Ehs1el7yukkhS7+ljAi9KDkyvjl819syL8ADCT72JJL1nStNzLnYCuYoiIRx7WDPZuxB3t7AuxV7O9y3f2K7DL6gWCImc7Fo0iglrI1YAKxhnK6pLWfONpPqQH5U1En5Mxvg8AbO/k4LN6vOW5NlzgzofUYUQCnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QW2xH7Hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QW2xH7Hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602A6C4CEF7;
	Mon,  9 Mar 2026 19:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084283;
	bh=wy0fgG+OqF6cw22y7JDQIN2MJp1BJ6acjGWjdLKi8F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QW2xH7HuqQXoi83jcceoja9TI1YAhDBVMJNuiv/10JIE4wTymwbz9hphQZSXdqHZk
	 1Fo8vHaMoH02qE0IMf0WXvAujp2unHUTVVoRzZpLecru3kyYMnSIWzdjeGFEwYThMr
	 yigqa4+cyKQAayODnLk1YlPFvvjkAW3IXPfO4our8ug4p2ZBIvmY5eMrtZsL89QIuw
	 RZutFoWAIwsMM6pX6NucYJSCSYjlnslXcRrKLKDopHz6Ti1snJBKH0n4qzkKcbzCOe
	 yO/ntjkLR9zJuqp5evJrth13nVO8S0skkg2N20V/7manmi/inS+jRM0KnAGLKul/JP
	 1oqZlXfBoS/SQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v4 09/25] iomap: issue readahead for fsverity merkle tree
Date: Mon,  9 Mar 2026 20:23:24 +0100
Message-ID: <20260309192355.176980-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issue reading of fsverity merkle tree on the fsverity inodes. This way
metadata will be available at I/O completion time.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a335a18c307f..1d9481f00b41 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -593,6 +593,9 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	if (iter.pos < i_size_read(iter.inode))
 		ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi)
+		fsverity_readahead(ctx->vi, folio->index,
+				   folio_nr_pages(folio));
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, ctx,
-- 
2.51.2

