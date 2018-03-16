Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56835 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbeCPFVv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Mar 2018 01:21:51 -0400
From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 2/2] xfs_scrub: add missing paths header
Date: Fri, 16 Mar 2018 07:21:36 +0200
Message-Id: <27747dcbfbde8a767b1a873716fce1d3aaf17c2f.1521177696.git.baruch@tkos.co.il>
In-Reply-To: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>

Fix the following build failure with musl libc:

xfs_scrub.c: In function ‘main’:
xfs_scrub.c:670:11: error: ‘_PATH_MOUNTED’ undeclared (first use in this function)
    mtab = _PATH_MOUNTED;
           ^~~~~~~~~~~~~

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 scrub/xfs_scrub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index ab26e6335948..eedbe34ec7b3 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -21,6 +21,7 @@
 #include <pthread.h>
 #include <stdbool.h>
 #include <stdlib.h>
+#include <paths.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
-- 
2.16.2

