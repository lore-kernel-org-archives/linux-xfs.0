Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57166204F8D
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518623; cv=none; b=KtPTqUapL8/j+OZCjtnpQ3+rAxxh8+cU7CPzrTYtl7QVUGQd2G2WxJXb5EKOeHl0UOWpbYkemmkUiTgKuqsPhM4I9EpB+yAuKeX98bCzUqFEKfHuHlUhcgP3zipSFN6P4BRUQ/oX/cIYVlhYtpEXD/JIw6EyFNzVkCx6MQUR/ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518623; c=relaxed/simple;
	bh=hXbye2S1qZrmX0OWbmXRvJxw6sOUGyHkeRQ6ukCbCgo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkXf+/aaRfn6CxuMa+tBGPcObnanGFp9xAUb2zNYhz2Xen6fe+uZzG/bE7CkVo7B7XozUnEkn4HJOYbFfvnNo3xBn9fLzelilgcibuEMqYu+R7yMY+cpC+DffhOqT16EwuFkH1jM5dYRAnzurEfe4VQUyKC6XHgPrRe1R685zWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8EHRRyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8EHRRyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9473C4CEE4;
	Tue,  1 Apr 2025 14:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743518621;
	bh=hXbye2S1qZrmX0OWbmXRvJxw6sOUGyHkeRQ6ukCbCgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S8EHRRyvNRGumfosWT0QSb582pRtb6Vx4D28++EmIl5cmFeo8B6nIL9CiaTaIUGYB
	 XriLETt0oVv88elLS9Hq2a8dKOrhssNAgVPy495DNp15GDikDSXtkBePkWrN3j55HV
	 jhYQDA15+vM+NYxUzz1Yhmw7F06C77kLqtOtYN/i7fHsmur3dRJ9Y5zFuKYWBvcrUk
	 BD8EhAlIboLyon/G85pcqpF2qXuIcOppbYn+AVfE4d+SgzXcq3RcFSBcQqFHECxIzA
	 6W9KXjJYAzICpHWu8J7CVB0NOMfPQNHSrJeydP0U6iEPHGnXaK5naXR1GbEaNjzr16
	 1bLV/Fsxj2j1w==
Date: Tue, 01 Apr 2025 07:43:41 -0700
Subject: [PATCH 1/5] xfs_protofile: rename source code to .py.in
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174351857595.2774496.18089631693216742204.stgit@frogsfrogsfrogs>
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
References: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Rename this source code file to have an extention of ".py.in" so that
editors and xgettext can "smartly" detect the source code type from the
file extension.  This will become important for adding localization to
the strings printed.  No functional changes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/Makefile            |    4 ++--
 mkfs/xfs_protofile.py.in |    0 
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename mkfs/{xfs_protofile.in => xfs_protofile.py.in} (100%)


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 3d3f08ad54f844..b1369e1853a98f 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -6,7 +6,7 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = mkfs.xfs
-XFS_PROTOFILE = xfs_protofile
+XFS_PROTOFILE = xfs_protofile.py
 
 HFILES =
 CFILES = proto.c xfs_mkfs.c
@@ -38,7 +38,7 @@ $(XFS_PROTOFILE): $(XFS_PROTOFILE).in
 install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 $(XFS_PROTOFILE) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 $(XFS_PROTOFILE) $(PKG_SBIN_DIR)/xfs_protofile
 	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
 	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
 
diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.py.in
similarity index 100%
rename from mkfs/xfs_protofile.in
rename to mkfs/xfs_protofile.py.in

