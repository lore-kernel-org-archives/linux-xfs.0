Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B61B2EC553;
	Tue, 17 Feb 2026 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370461; cv=none; b=MSRzUjWZVRf5j05Wcr/jG4IUKMom9O05SsG53+492TOLJm8vU9fqFvOmnEOneGNgyHgpjv4MRoh33EEmRHj/mt7ixQM+DBgW0xROdVPb045tm+Ji3mZZV38RvScnyDWtd6XBjo4+Q26ez8r5o1RUGo4/r6pJNSDaEw8n0ZLNOzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370461; c=relaxed/simple;
	bh=NCDsnHDKq6Cdko3p3l7SLVp7DPEb2pb1GTkcsMnsOrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbeeaivWFIigfzkVyiierPuonrsLAHoDsExr2Ti+Nsh8iFy6nSrjypmdUzHQWtJ3nT7LcB1U1nYdGZEO88ALOI4URC/NYsFWWdZT+w5yavF4BZlK/SCKJk5aaQrd7b1N7tle5W2NXC79ZTHg+1HUTJTSOsZ78CHTYJ3SE/FA/54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbaT5PB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbaT5PB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C69AC4CEF7;
	Tue, 17 Feb 2026 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370461;
	bh=NCDsnHDKq6Cdko3p3l7SLVp7DPEb2pb1GTkcsMnsOrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbaT5PB/3v1lyXtjvymCnjfRp2Rt8KS62PYbC5wSIAIOdhG8xkC9hJvILTW9MuucZ
	 xSsgCLu7hOjo/+TDfn6Hv36kPfmwpt875CEALJ4/wI28uDp8j5P4N79oyEFiKk1f22
	 dwGYG8cGrQcNVmF/KiolxYfRKZU9TcNQLm/rBTHp+El7vFR8YnHGi1MgT2PiYlvDFO
	 qi8FNJR9l8DUEQO7yWowykdsrgxQFNRBCeC+GCm87m3b/Bem4Q5+5visBVpWV72sq3
	 KHbJkBu/rGEGxL+JJtaPaNxX5dzDe1mEZH8jslKI8o2PKtAufrGbQmMH+TKn5Pdip+
	 wkKmSGV2PnzJQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 13/35] xfs: use folio host instead of file struct
Date: Wed, 18 Feb 2026 00:19:13 +0100
Message-ID: <20260217231937.1183679-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fsverity will not have file struct in ioend context
(fsverity_verify_bio() path). This will cause null pointer dereference
here.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index bf985b5e73a0..36c4b2b4b07a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -779,7 +779,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = {
 		.cur_folio	= folio,
-		.ops		= xfs_bio_read_ops(XFS_I(file->f_mapping->host)),
+		.ops		= xfs_bio_read_ops(XFS_I(folio->mapping->host)),
 	};
 
 	iomap_read_folio(&xfs_read_iomap_ops, &ctx);
-- 
2.51.2

