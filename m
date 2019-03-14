Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfCNVFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:05:00 -0400
Subject: [PATCH 11/36] xfs_scrub_all.timer: activate after most of the
 system is up
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:57 -0700
Message-ID: <155259749738.31886.13894651790702916465.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We really don't want the xfs_scrub_all timer triggering while the system
is booting up because not all the mounts will have finished, networking
might not be up for reporting, and slowing down bootup annoys people.
Therefore, delay the xfs_scrub_all service's activation until after the
system has started all the big pieces it's going to start.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub_all.service.in |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 66f82fc7..b1b80da4 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -2,6 +2,7 @@
 Description=Online XFS Metadata Check for All Filesystems
 ConditionACPower=true
 Documentation=man:xfs_scrub_all(8)
+After=paths.target multi-user.target network.target network-online.target systemd-networkd.service NetworkManager.service connman.service
 
 [Service]
 Type=oneshot
