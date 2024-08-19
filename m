Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5A316EB6D
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073747; cv=none; b=LfNueYmB8n546ipxVHQcZlrejo9T6CZjPxPrYs0P/9z8DlWmETZ++/b6Lbh5NGq5Ca4AyXjTE8jwdNiScQ3iCp1y3IJcXjIZ3b5eeNCwUDd47IiDmCTUEFOIXa2ai3VtPglT0QOxro8mWHil71M21schrpVZvGzhoCfX9Z9l4ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073747; c=relaxed/simple;
	bh=3/bBuSU02sgH/fdKONEU5q6+Z4sw+d9NT6XIrjUvGAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CUySxrN+HxNOhnq059PmGl/nidTJy6c8LIAFG4wKpcqBE/lJt1VGtAezRS89l85ILb5GZTtGV3DFnYyo9sklhHa3KLcAHkCiVukH/GRQgmzsdrMx7Zk2mQMtTS6bWdcBNxepVUI9lc9KYqSsYUeeaWoz0TCpavHV+LlkZbfrT9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBaD31+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBaD31+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6A8C4AF11;
	Mon, 19 Aug 2024 13:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724073747;
	bh=3/bBuSU02sgH/fdKONEU5q6+Z4sw+d9NT6XIrjUvGAk=;
	h=From:To:Cc:Subject:Date:From;
	b=vBaD31+kc1nkubIUvBd9S6IUVS29J96b+eQZ4iNWL0ihi1v2bOgHhZYRYKwmVtf9q
	 I6a6/0UWEaCwj8fvn9ijjYPSYMySW6GhZBxO/fWf8DsKbHyr/JpY8qBrkxlPD3W+2C
	 UiMHjMlsRhX5sYo6OSTKQuAOD8lzLrA5qZuWMape0D56asp7i83Kwq4rVOSOcCjzJ5
	 5edd/EIkiDIxQg6E9p0ZQlH2BVaRy/2JpamgRBwK7vTMl7C8/GljG91kcU72Wm8i5Q
	 6wJBRXjR52HBcwjD6+ybDwmys94h3lES2joMZdFR3A1CcDkUsCTI3eokkNyvhQGqt/
	 4bFP2+CMf8Y+Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org
Subject: [PATCH] libfrog: Unconditionally build fsprops.c
Date: Mon, 19 Aug 2024 15:22:05 +0200
Message-ID: <20240819132222.219434-1-cem@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

The new xfs_io fs properties subcommand, requires fsprops to be build,
while libfrog conditionally build it according to the existence of
libattr.

This causes builds to fail if the libattr headers are not available,
without a clear output.

Now that xfs_io unconditionally requires libfrog/fsprops.c to be built,
remove the condition from libfrog's Makefile.

Fixes: d194cb818305 ("xfs_io: edit filesystem properties")
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libfrog/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/libfrog/Makefile b/libfrog/Makefile
index acddc894e..53de7c174 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -21,6 +21,7 @@ crc32.c \
 file_exchange.c \
 fsgeom.c \
 fsproperties.c \
+fsprops.c \
 getparents.c \
 histogram.c \
 list_sort.c \
@@ -49,6 +50,7 @@ div64.h \
 file_exchange.h \
 fsgeom.h \
 fsproperties.h \
+fsprops.h \
 getparents.h \
 histogram.h \
 logging.h \
@@ -61,12 +63,6 @@ scrub.h \
 workqueue.h
 
 LSRCFILES += gen_crc32table.c
-
-ifeq ($(HAVE_LIBATTR),yes)
-CFILES+=fsprops.c
-HFILES+=fsprops.h
-endif
-
 LDIRT = gen_crc32table crc32table.h
 
 default: ltdepend $(LTLIBRARY)
-- 
2.46.0

