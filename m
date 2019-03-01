Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41858 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOA01122688
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:21 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qtupetehx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRKrL031573
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:20 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRKrN020823
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:20 GMT
Subject: [PATCH 05/23] xfs_scrub_all.timer: activate after most of the
 system is up
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:19 -0800
Message-ID: <155148283951.16677.2915351969398022552.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
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
