Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41304 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbeCUDk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:40:58 -0400
Subject: [PATCH 12/14] xfs_scrub: disable private /tmp for scrub service
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:40:54 -0700
Message-ID: <152160365430.8288.18072489901853791592.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't make /tmp private when invoking xfs_scrub as a service, because
/tmp might contain or itself be an xfs filesystem mountpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub@.service.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index c14f813..9e6206a 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -9,7 +9,7 @@ WorkingDirectory=%I
 PrivateNetwork=true
 ProtectSystem=full
 ProtectHome=read-only
-PrivateTmp=yes
+PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
 User=nobody

