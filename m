Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdGCI2g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jul 2017 04:28:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11AB4C0587FF
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2017 08:28:36 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (unknown [10.43.17.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8817087BB9
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2017 08:28:35 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_io: Print filesystem statfs flags in 'statfs' command
Date: Mon,  3 Jul 2017 10:28:30 +0200
Message-Id: <20170703082830.22967-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sometimes printing the flags from the statfs structure is useful, so,
make statfs command print them.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/stat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io/stat.c b/io/stat.c
index 783eb2e..060ff83 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -199,6 +199,7 @@ statfs_f(
 		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
 		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
 		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
+		printf(_("statfs.f_fflags = 0x%llx\n"), (long long) st.f_flags);
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-- 
2.9.4

