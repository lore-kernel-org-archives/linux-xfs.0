Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbeDKBxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 21:53:20 -0400
Date: Tue, 10 Apr 2018 18:53:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 12/14] xfs_scrub: disable private /tmp for scrub service
Message-ID: <20180411015309.GW7500@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160365430.8288.18072489901853791592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152160365430.8288.18072489901853791592.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't make /tmp private when invoking xfs_scrub as a service, because
/tmp might contain or itself be an xfs filesystem mountpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add a comment explaining why we turned it off
---
 scrub/xfs_scrub@.service.in |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index c14f813..56acea6 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -9,7 +9,8 @@ WorkingDirectory=%I
 PrivateNetwork=true
 ProtectSystem=full
 ProtectHome=read-only
-PrivateTmp=yes
+# Disable private /tmp just in case %i is a path under /tmp.
+PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
 User=nobody
