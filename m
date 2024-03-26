Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C594013D255
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 19:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711481089; cv=none; b=lBvhwfC5EAAaXI93pf/B0zw6VZ8SUPSnt60CjEze22DkkJAK2hQOX9fe3Q30pDzGcMZHW1xqlppP+nB9989ge1v9/qai27JgJLUxT/wCEspmPCMTjejw+QCSZUDFJbaIgzp1DfBA3V06QE3LbtEIpMRPi6K0T7YeOXQy8DHQoAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711481089; c=relaxed/simple;
	bh=WPlNKavuG79pvtjF9QVszbiOTNjP8Y+JD2t49Ga0jsI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NIwTEIlgiuhUxHwuxPo38iXUWw5VUGQXHgld3DmCJjAl+3co8Z5uoITfJAybDu8CwMheeeTz8rILjtrpwEl8q32y8wF+xCCZbdJxbDuxXaPSRJeoGIZ4T81NC8eqGx2R2I9hRSthuwnqdHvz3/gI6nl6MKbLg3k4RwJ3ISANd/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBpkfS6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBpkfS6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AFBC433F1;
	Tue, 26 Mar 2024 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711481089;
	bh=WPlNKavuG79pvtjF9QVszbiOTNjP8Y+JD2t49Ga0jsI=;
	h=Date:From:To:Cc:Subject:From;
	b=OBpkfS6f4Ag31BfeCtf2qdWDHIyHeOjwvZacNK7vuAc5w8VogwlYwwhBjD31cWbgy
	 mf+qwBsFEvXis6sZVRMWCrogf+R39w7VHIarF9SwlJSZpM0OrtvLO8fuobfu9djqMj
	 5r3WPrGoKafEPSKm9aecYYWUWSt3WrZqBK+plRG1mGteh2vln/srX/jM0oHVugdXMI
	 KoNT2RRq7wfjK6AKrga9tcdEzSk9J70Ubt0tMDQbqcs07OuVa4I//kVXyQWVze50T1
	 wyti4JgRqJPRY7eqXaSbMDNCOwchmrFwy9bePa9ZRV6YbI6VU4PbEGF0rP5xvUtW1c
	 nGgA6NoQIsxxw==
Date: Tue, 26 Mar 2024 12:24:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH] debian: fix package configuration after removing
 platform_defs.h.in
Message-ID: <20240326192448.GI6414@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
will start ./configure with the desired options.  This needs to go in
before 6.7.

Fixes: 0fa9dcb61b4f ("include: stop generating platform_defs.h")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/debian/rules b/debian/rules
index bfe83b4c3bdc..185765b16140 100755
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
