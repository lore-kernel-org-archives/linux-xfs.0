Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49346 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbeFJFMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:12:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A5Bfjk009402
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:12:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jg4dkt28w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:12:47 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5CkWa008324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:12:46 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5Ckoh014574
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:12:46 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 0/1] Parent pointers test v1
Date: Sat,  9 Jun 2018 22:10:38 -0700
Message-Id: <1528607439-11186-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the first revision of a new xfstest to exercise the parent
pointer code. The test cover basic parent pointer operations,
including link, unlink, rename, overwrite, hardlinks and
error inject.

As always, comments and feedback are appreciated.  Thank you!

Allison Henderson (1):
  xfstests: Add parent pointer test

 tests/xfs/448     |  423 +++++++++++++++++++++
 tests/xfs/448.out | 1096 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 1520 insertions(+)
 create mode 100755 tests/xfs/448
 create mode 100644 tests/xfs/448.out

-- 
2.7.4

