Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbeCZT4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 15:56:16 -0400
Date: Mon, 26 Mar 2018 12:56:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/4] xfs_spaceman: remove incorrect linux/fs.h include
Message-ID: <20180326195611.GW4818@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152151529988.18312.2660325658864402943.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the direct linux/fs.h include from spaceman because all xfs
utilities should include xfs.h so that we can wrap missing kernel header
declarations properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/trim.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/spaceman/trim.c b/spaceman/trim.c
index 6df9e6a..c1efb52 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -17,7 +17,6 @@
  */
 
 #include "libxfs.h"
-#include <linux/fs.h>
 #include "command.h"
 #include "init.h"
 #include "path.h"
