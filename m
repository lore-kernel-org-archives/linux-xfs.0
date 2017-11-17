Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43697 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965178AbdKQTwh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 14:52:37 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C627AC9D
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 19:52:36 +0000 (UTC)
From: jeffm@suse.com
Subject: [PATCH 1/2] xfs_io: stat: fix typo in statfs->f_flags
Date: Fri, 17 Nov 2017 14:54:56 -0500
Message-Id: <20171117195457.16218-1-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

The field name is f_flags.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 io/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/stat.c b/io/stat.c
index 060ff833..6ab10abf 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -199,7 +199,7 @@ statfs_f(
 		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
 		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
 		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
-		printf(_("statfs.f_fflags = 0x%llx\n"), (long long) st.f_flags);
+		printf(_("statfs.f_flags = 0x%llx\n"), (long long) st.f_flags);
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-- 
2.14.2

