Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30313262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388703; cv=none; b=tNgPyksPXnvuy5PQMKKoSLmA43TUnDoWKndvFSMHqs4l8kogsRnj0wQPfxpVl89ZkVslgGJo3fCvqCepEV2hChBs47NViVhM+/FJQfO4gBLDMSoNEvWa4tuJ4yDaEoLG7SqZbYM29QCrZ/lxx96qxzEnOC0uucuduHtjo+tK/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388703; c=relaxed/simple;
	bh=WxayAJldjBxWKrVMK58EYWQL6YHiFovnbOqQ0xY1dzo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQFJA8K28et4YWh2q2yNNMSC4Us9m3vpL9D15B+UGmxHPbLF3zmcEkB3WhMgbTs+BixTPYjjRDYBXZpyhrZtwTnTcLzGBsxJOBSf8/lVQo3uakpYrNhUzj4DcI6/2O2hWL2S+gBNpLLUZmJVQbQa2QGdI3NHjyBNowNYynj2esE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aov6qk+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aov6qk+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E059C072AA;
	Wed, 17 Apr 2024 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388703;
	bh=WxayAJldjBxWKrVMK58EYWQL6YHiFovnbOqQ0xY1dzo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aov6qk+eO59xWtlIWtysMKTvXyGLEB9Mhis2Lgdr2lS2kviZnAQ2aPSfOaQVtvun8
	 u3Wv5MPXVLVc3nkydbqQUl9/ujThdEgOc5pdNx4r6oZweDbU+NuW81eNGhba87n0nd
	 iMVmxBjD979gR8tpHimL0XYLFT3NVxuuy3pv7sSUy20h54xR9dJdCoY+NOHvWXcKx7
	 y1Z03+t0Bh9EaHHcaIoGNeLg32uBIWc6R54lD5i+lj42J/VIRLoH6oUMHPhzND7//E
	 2sjgqGoW9IrqzSjarGpta0/LVN1OFhxb4gc7xfFF4t7MrbZKJxOLhXOEnREL7wEIQd
	 cwbgSIGzJR8aQ==
Date: Wed, 17 Apr 2024 14:18:22 -0700
Subject: [PATCH 1/2] debian: fix package configuration after removing
 platform_defs.h.in
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841078.1852814.8154538108927404452.stgit@frogsfrogsfrogs>
References: <171338841078.1852814.8154538108927404452.stgit@frogsfrogsfrogs>
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

In commit 0fa9dcb61b4f, we made platform_defs.h a static header file
instead of generating it from platform_defs.h.in.  Unfortunately, it
turns out that the debian packaging rules use "make
include/platform_defs.h" to run configure with the build options
set via LOCAL_CONFIGURE_OPTIONS.

Since platform_defs.h is no longer generated, the make command in
debian/rules does nothing, which means that the binaries don't get built
the way the packaging scripts specify.  This breaks multiarch for
libhandle.so, as well as libeditline and libblkid support for
xfs_db/io/spaceman.

Fix this by correcting debian/rules to make include/builddefs, which
will start ./configure with the desired options.

Fixes: 0fa9dcb61b4f ("include: stop generating platform_defs.h")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 debian/rules |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/debian/rules b/debian/rules
index 7e4b83e2b..0c1cef92d 100755
--- a/debian/rules
+++ b/debian/rules
@@ -61,15 +61,17 @@ config: .gitcensus
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
 	dh_update_autotools_config
-	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
+	# runs configure with $(options)
+	$(options) $(MAKE) $(PMAKEFLAGS) include/builddefs
 	cp -f include/install-sh .
 	touch .gitcensus
 
 dibuild:
 	$(checkdir)
 	@echo "== dpkg-buildpackage: installer" 1>&2
+	# runs configure with $(options)
 	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
-		$(diopts) $(MAKE) include/platform_defs.h; \
+		$(diopts) $(MAKE) include/builddefs; \
 		mkdir -p include/xfs; \
 		for dir in include libxfs; do \
 			$(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \

