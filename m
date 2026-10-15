Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3100338B7B4
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075572; cv=none; b=NzgCv3z3ZTFk/h/XElSwbadyGF9ApU5SIUKrseiloeQLmr3euXtyn0LRkRsI0EUINIvkXv+697A92wGRRaaNN8rUFPrqm/dmVbFkcoC2nfgoYuFiSnlsMUmQy4C87Vw3drSvAu90pzEMOuP57BdlGN7Jm3v1s6z+dFTReYlk8ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075572; c=relaxed/simple;
	bh=XMRui9sG15OdANcFqIIOji7ePMXqi4KsTjl1l/Vv7L0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GI9EZl5mzB7nzEVvjbPY2pXiXRmfphosTjx5xUKEEBsfbdw8bgUs/nTqfAWzMtIg10bK5f40RSGToevc8oSTR26Ow1JfahPn8wlkMw4EFD1zwCkc0pv438DWpLJ3o/fVXzmeTQGxl0lgq2MaEgsUepvCyedSnkwigbp/F0BUtGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGSWmiVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGSWmiVF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A3F251F000C5;
	Thu, 15 Oct 2026 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075570;
	bh=iHMTUnKUIhkbMeFuF9P0s6QSON5n+y+7kj1Pm5SudIg=;
	h=Date:From:To:Cc:Subject;
	b=bGSWmiVFnGT7sQRlXGrMLXFMYfqfCDa92Gnjp0Q3pWo6ZJ7Twcaz/OBV4Xsnmx5r8
	 A0sS4d3Fa1scx8eQX7dvdwnXcB8uPvH1PoBXKs/sO+aaHryLkR7POB9+CuWZesdV9j
	 658gOfZOossOgWMPXOqnm0t4lg6eQQDn6yUWKQHv2HFOgNe8+JKxawWy/KpluWV1eF
	 eFU/z66evq0IfbI35GgtMMzqP0bYUu+gQIgJlc/jzUVj/RzETleWUxhvHVfbluhUmG
	 d5BAsD6FvUUZKUPKfTzGnuvDiGF8fdW5ySj9DqYwVQESAF+DFkysk2yiyXsIN9507X
	 V0M0jSX+mXmPA==
Date: Thu, 15 Oct 2026 07:46:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfsprogs: turn on more warnings for the filesystem code
 we modify most
Message-ID: <20261015144610.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/builddefs.in |   79 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index acdbc5c865768b..41076ddf389f82 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -21,6 +21,83 @@ BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
 # only use what we calculate from the configured options above.
 LDFLAGS =
 
+# Generate more debugging info
+WARNINGS += -femit-struct-debug-detailed=any
+WARNINGS += -fstack-usage
+
+# Base warnings(?)
+WARNINGS += -Wall
+WARNINGS += -Wpointer-sign
+WARNINGS += -Wuninitialized
+WARNINGS += -Wno-error=format=		# dont trip on printf debugging
+
+# Fedora wants to modernize C...
+WARNINGS += -Wimplicit-int
+WARNINGS += -Wimplicit-function-declaration
+WARNINGS += -Wint-conversion
+WARNINGS += -Wstrict-prototypes
+WARNINGS += -Wold-style-definition
+
+# Derived from scripts/Makefile.extrawarn on 2023-09-12 (v6.6-rc1)
+
+# W=e
+WARNINGS += -Werror
+
+# W=1
+WARNINGS += -Wextra -Wunused -Wno-unused-parameter
+WARNINGS += -Wmissing-declarations
+WARNINGS += -Wrestrict
+WARNINGS += -Wmissing-format-attribute
+WARNINGS += -Wmissing-prototypes
+WARNINGS += -Wold-style-definition
+WARNINGS += -Wmissing-include-dirs
+WARNINGS += -Wunused-but-set-variable
+WARNINGS += -Wunused-const-variable
+WARNINGS += -Wpacked-not-aligned
+WARNINGS += -Wformat-overflow
+WARNINGS += -Wformat-truncation
+WARNINGS += -Wstringop-overflow
+WARNINGS += -Wstringop-truncation
+
+WARNINGS += -Wundef
+
+# W=2
+WARNINGS += -Wdisabled-optimization
+WARNINGS += -Wshadow
+WARNINGS += -Wlogical-op
+WARNINGS += -Wmissing-field-initializers
+WARNINGS += -Wtype-limits
+WARNINGS += -Wmaybe-uninitialized
+WARNINGS += -Wno-error=maybe-uninitialized	# gcc 14.2 vs xfs_bmap.c
+#WARNINGS += -Wunused-macros			# dont care about extra macros
+
+# W=3
+#WARNINGS += -Wbad-function-cast		# pagecache
+#WARNINGS += -Wcast-align			# hits char* to struct* casts on riscv64
+#WARNINGS += -Wcast-qual			# rhashtable
+#WARNINGS += -Wconversion			# everywhere
+#WARNINGS += -Wpacked				# this whines about unnecesary __packed??
+#WARNINGS += -Wpadded				# maple tree
+#WARNINGS += -Wpointer-arith			# container_of
+#WARNINGS += -Wredundant-decls			# ftrace
+#WARNINGS += -Wsign-compare			# percpu
+#WARNINGS += -Wswitch-default			# everywhere
+#WARNINGS += $(call cc-option, -Wpacked-bitfield-compat) # not a gcc thing
+
+# Stuff we need to fix in xfsprogs
+WARNINGS += -Wno-suggest-attribute=format	# dont care about printf crap
+WARNINGS += -Wno-shadow				# many programs have global variables
+WARNINGS += -Wno-missing-field-initializers	# why is this even a problem?
+WARNINGS += -Wno-sign-compare			# zomg so much macro
+WARNINGS += -Wno-dangling-pointer		# gcc 12.2 bug
+
+WARNINGS += -Wno-error=type-limits		# rtgroups patchset
+WARNINGS += -Wno-error=array-bounds		# rtgroups patchset
+
+# Comment out for release builds
+CFLAGS += $(WARNINGS)
+BUILD_CFLAGS += $(WARNINGS)
+
 LIBRT = @librt@
 LIBUUID = @libuuid@
 LIBURCU = @liburcu@
@@ -128,7 +205,7 @@ NEED_INTERNAL_STATMOUNT = @need_internal_statmount@
 HAVE_FANOTIFY_MOUNTINFO = @have_fanotify_mountinfo@
 HAVE_QUOTACTL_FD = @have_quotactl_fd@
 
-GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
+GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall -Werror -Wextra -Wno-unused-parameter
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
 # _LGPL_SOURCE is for liburcu to work correctly with GPL/LGPL programs
