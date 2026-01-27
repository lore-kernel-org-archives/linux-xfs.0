Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287BB21CC7B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769531991; cv=none; b=B1nwuRLt9qmf39OTCBfEPUHtG06QPxfPXGs757EYboeMe0vIGsbBFzdS9osKizGJFtCNo8LGj9O6obj20iaX7d9mFVz1LaQ2G245ybHzMylh4plE8XTAYTL2CYT5rvLPxa1CmFa8gczB5c9N5epQqqMXCkGQE8fIeo9q0V2Irxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769531991; c=relaxed/simple;
	bh=cZftfP6YCQML8iURw4M1QSDpsXDbC4+RwpZVVwJqAMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eg3XLXCH6n1kHeoMYv8hR8Tga9Ax5wfQmXU7RRPLQUkWiOxRwsoTA4VREjSA4IWtki7EnnrVCRaRF9DaKI6VmcCE42cNi7T4JLj1/QAKuTbbr4jnXTRyNBCcPK/Tc5Fvl8PanP/fv9EzaPml6Xdi5fqRXkhZ3YmaumxAzZHHDZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbbrzG5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbbrzG5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E586C116C6;
	Tue, 27 Jan 2026 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769531990;
	bh=cZftfP6YCQML8iURw4M1QSDpsXDbC4+RwpZVVwJqAMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbbrzG5mDihEa3iD0Ya3huTow0ev7weTvFAuBlavLSFSg8b1ecJIcjVHC/nbS/hOd
	 /aZZPdMmT0b9jcrBwws61gw0JoqsXGuYlrRfD7KKrFbYP7xIIDkNHwgwzpA+pWB28d
	 7q9HTBEZKBn7JNTV7A+kSOf/dbkKSyV/PhViBT+CtHf4FKMTM5kkkstM6EtRj+yeD8
	 0ehZUI9Gn9O1O4oKJzmJuuQZolFVpGAOnIy0dqTZmjDn9auz7WGtgNqn+GQv6xi0Xf
	 WfJgzxSCQeZO/xpU2l/mFu2mR6WuQr8k46PQa6jT95+gcZsY1ue1EVyZvFC3fuaszF
	 DEjlP1tPNnD1Q==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: hch@lst.de,
	linux-xfs@vger.kernel.org,
	dlemoal@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] libfrog: adjust header order for BLK_ZONE_COND_ACTIVE #ifndef check
Date: Tue, 27 Jan 2026 17:39:29 +0100
Message-ID: <20260127163934.871422-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121064924.GA11068@lst.de>
References: <20260121064924.GA11068@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Even after kernel fix via defining BLK_ZONE_COND_ACTIVE the compiler
is still failing on this with:

In file included from zones.c:5:
../include/platform_defs.h:311:33: error: expected identifier before numeric constant
  311 | #define BLK_ZONE_COND_ACTIVE    0xff
      |                                 ^~~~
/linux-headers-v6.19-rc7/include/linux/blkzoned.h:84:9: note: in expansion of macro ‘BLK_ZONE_COND_ACTIVE’
   84 |         BLK_ZONE_COND_ACTIVE    = 0xFF, /* added in Linux 6.19 */
      |         ^~~~~~~~~~~~~~~~~~~~
In file included from ../libfrog/zones.h:8,
                 from zones.c:7:
/linux-headers-v6.19-rc7/include/linux/blkzoned.h:85:9: warning: ‘BLK_ZONE_COND_ACTIVE’ redefined
   85 | #define BLK_ZONE_COND_ACTIVE    BLK_ZONE_COND_ACTIVE
      |         ^~~~~~~~~~~~~~~~~~~~
../include/platform_defs.h:311:9: note: this is the location of the previous definition
  311 | #define BLK_ZONE_COND_ACTIVE    0xff
      |         ^~~~~~~~~~~~~~~~~~~~

This is because of the order of #ifndef (in platform_defs.h) and #define
(in blkzoned.h). The platform_defs.h defines BLK_ZONE_COND_ACTIVE first
and this causes enum to fail and macro being redefined. Fix this by
including libfrog/zones.h first, which includes blkzoned.h. Add stdint.h for
uint64_t in xfrog_report_zones().

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libfrog/zones.c | 2 +-
 libfrog/zones.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libfrog/zones.c b/libfrog/zones.c
index f1ef0b24c564..68be7388172b 100644
--- a/libfrog/zones.c
+++ b/libfrog/zones.c
@@ -2,9 +2,9 @@
 /*
  * Copyright (c) 2025, Western Digital Corporation or its affiliates.
  */
+#include "libfrog/zones.h"
 #include "platform_defs.h"
 #include "atomic.h"
-#include "libfrog/zones.h"
 #include <sys/ioctl.h>
 
 /*
diff --git a/libfrog/zones.h b/libfrog/zones.h
index 33c1da7ef192..4cc4d15c4dab 100644
--- a/libfrog/zones.h
+++ b/libfrog/zones.h
@@ -6,6 +6,7 @@
 #define __LIBFROG_ZONES_H__
 
 #include <linux/blkzoned.h>
+#include <stdint.h>
 
 struct xfrog_zone_report {
 	struct blk_zone_report	rep;
-- 
2.51.2

