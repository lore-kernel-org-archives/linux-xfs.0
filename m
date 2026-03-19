Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE03ED12C;
	Thu, 19 Mar 2026 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939784; cv=none; b=qBfTvzwoIJMc1bodS4noVYSFkNFHF7lcZtbRrnTKK9bcJ8QGoGdMRH94qDeZcErjqPzPA0cHNrSh0RPsZVVjDfPO0dEDPosUxUePX2AMlVJ2uTQzDUpnEkZuroPe5fFCNl8Ktl8FcHs2PtXhHWsfy91gCUWRvz+U1mkAzBOWWf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939784; c=relaxed/simple;
	bh=Wo+UuQLdk6GPC6ALAqWBqjfZM9K9vXrNOXXWK2txflU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciQcrentzVVwJpIxFtRbhKUUGaMx7KskOB/dch5VHQoAXH7DnUEUoRNmkFrp8vZAzdReVFzU0J5toDB0Q3vhlXlngPrmEK0vBycoKRzEMxFqcmhgk9A1e8gJNZAZiYC2ZVTLUTrh6q7f8NcnvL8QNr3bZ8gnlzsVf+K923DKtyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtXJWQXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtXJWQXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8715DC2BCAF;
	Thu, 19 Mar 2026 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939783;
	bh=Wo+UuQLdk6GPC6ALAqWBqjfZM9K9vXrNOXXWK2txflU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtXJWQXS2PIpp+IaV9MGZf+6cX9Tp6X6eaDG66r3xNazLOY8wSJv/hKNQhDqt9ev5
	 k7DQ7Dr5une2NVZTGFSj+iS/6NP7HqAeMLtqrANblJkIAmMwKdsKl5HXzrA2YI9O+Z
	 NLa0DCMJgijWJ3txgtP1WRwhDvmv5OwNQ88WuieVLN6fhtttg/OboFGLCG3KlcvLtu
	 g2bx6PofeSxgjG6F0f+ntGbFe9VumS3ckfh1rpKuZ+d5V4VGlCOynIHM198EJ2gsEP
	 05noM+8OF3M6CoKLrcvB4vbP7N7hEsusrPYjnIfHcVH9D2LaZkqurOuhJdcE2ZAyvs
	 oGffw05UnurYA==
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
Subject: [PATCH v5 09/25] iomap: issue readahead for fsverity merkle tree
Date: Thu, 19 Mar 2026 18:01:56 +0100
Message-ID: <20260319170231.1455553-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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
 fs/iomap/buffered-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bcfbfbf5cf7c..a11e54975df8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -602,6 +602,9 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	if (iter.pos < i_size_read(iter.inode))
 		ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi)
+		fsverity_readahead(ctx->vi, folio->index,
+				   folio_nr_pages(folio));
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, ctx,
@@ -672,6 +675,9 @@ void iomap_readahead(const struct iomap_ops *ops,
 
 	if (iter.pos < i_size_read(iter.inode))
 		ctx->vi = fsverity_get_info(iter.inode);
+	if (ctx->vi)
+		fsverity_readahead(ctx->vi, readahead_index(rac),
+				readahead_count(rac));
 
 	while (iomap_iter(&iter, ops) > 0)
 		iter.status = iomap_readahead_iter(&iter, ctx,
-- 
2.51.2

