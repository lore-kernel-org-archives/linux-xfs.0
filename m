Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUP2E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Jun 2019 11:28:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 613C5356F2
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 15:28:04 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E790E5D772
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 15:28:03 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: don't search for libxfs.h in system headers
Message-ID: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
Date: Fri, 21 Jun 2019 10:28:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

And now for something completely different: a noncontroversial,
trivially reviewable #include change!

(right?)

diff --git a/repair/rmap.c b/repair/rmap.c
index 47828a06..019df71c 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include <libxfs.h>
+#include "libxfs.h"
 #include "btree.h"
 #include "err_protos.h"
 #include "libxlog.h"
diff --git a/repair/slab.c b/repair/slab.c
index ba5c2327..d5947a5a 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include <libxfs.h>
+#include "libxfs.h"
 #include "slab.h"
 
 #undef SLAB_DEBUG
