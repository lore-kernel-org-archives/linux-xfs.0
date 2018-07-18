Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbeGSATf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 20:19:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6INdAPo148449
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2k9yjgkndp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:19 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6INdIaW030663
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:19 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6INdIBg032224
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:18 GMT
Subject: [PATCH 0/3] xfs-4.19: fix bogus summary counters on mount
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 16:39:17 -0700
Message-ID: <153195715716.16758.18150859087945516040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series enhances XFS' ability to detect and recover from obviously
incorrect summary counts.  Some of this is in response to recent bug
reports about xfs allowing mounts with obviously incorrect counts,
though the last two patches are intended to integrate with future online
fsck features.

The first patch detects obviously bad summary counters at mount time,
forces a recomputation of the counters after log recovery (if any)
completes, and fails the mount if the counts are still obviously bad.
The second and third patches deal with forcing a recalculation at the
next mount if the counts are found to be slightly incorrect, which is a
situation that will be detected by the fscounter online fsck in a
subsequent patch series.

This series sits on top of the cleanups I sent earlier today.

Comments and questions are, as always, welcome.

--D
