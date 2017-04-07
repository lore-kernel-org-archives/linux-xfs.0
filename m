Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21254 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753466AbdDGHtU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 03:49:20 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v377nJHW016198
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 07:49:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v377nJmq023145
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 07:49:19 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v377nHg8026546
        for <linux-xfs@vger.kernel.org>; Fri, 7 Apr 2017 07:49:18 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH 0/1] xfsprogs/db: fix a segfault in the print command
Date: Fri,  7 Apr 2017 15:49:03 +0800
Message-Id: <1491551344-5236-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com


There is a segfault in the xfs_db as below:

mkfs.xfs -f /dev/sda1
xfs_db -r -c "agf 0" -c "addr rmaproot" -c "p" /dev/sda1
Metadata CRC error detected at xfs_rmapbt block 0x0/0x1000
Segmentation fault (core dumped)

---
 db/print.c | 8 ++++++++
 1 file changed, 8 insertions(+)

Thanks
Shan Hai
