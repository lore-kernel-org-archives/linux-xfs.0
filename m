Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756315AbdDFBpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 21:45:08 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v361j7Op026491
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 6 Apr 2017 01:45:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v361j6Li020205
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 6 Apr 2017 01:45:07 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v361j6hl030316
        for <linux-xfs@vger.kernel.org>; Thu, 6 Apr 2017 01:45:06 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [RFC PATCH 0/1] xfsprogs/db: add a command for dumping the btree blocks
Date: Thu,  6 Apr 2017 09:44:42 +0800
Message-Id: <1491443083-18600-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


This patch adds a command named "treedump" to the xfs_db to dump the
blocks of the btree in batch, below is an example usage:

sudo xfs_db -r -c "agf 0" -c "treedump -b" /dev/sda1

The patch calls the "print" command from code to dump the contents
of the blocks instead of reinventing the wheel for printing.

db/Makefile   |   4 +-
 db/command.c  |   1 +
 db/treedump.c | 306 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/treedump.h |  20 ++++
 4 files changed, 329 insertions(+), 2 deletions(-)
 create mode 100644 db/treedump.c
 create mode 100644 db/treedump.h


Thanks
Shan Hai
