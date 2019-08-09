Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHIVlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:41:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYWfI092777
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:41:20 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u8hasj9gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:41:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcQrc110154
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u90t815dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcY60002297
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:34 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 0/1] Add delayed attributes test
Date: Fri,  9 Aug 2019 14:38:28 -0700
Message-Id: <20190809213829.383-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a quick test to excersize the delayed attribute
error inject and log replay.

Allison Collins (1):
  xfstests: Add Delayed Attribute test

 tests/xfs/512     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  18 ++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 121 insertions(+)
 create mode 100644 tests/xfs/512
 create mode 100644 tests/xfs/512.out

-- 
2.7.4
