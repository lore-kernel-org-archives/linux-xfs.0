Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47956 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbeLST3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 14:29:42 -0500
Subject: [PATCH 2/8] xfs_scrub_all.timer: activate after most of the system
 is up
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 19 Dec 2018 11:29:37 -0800
Message-ID: <154524777696.28646.14668160393059175404.stgit@magnolia>
In-Reply-To: <154524776457.28646.3004453037075812416.stgit@magnolia>
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
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
