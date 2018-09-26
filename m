Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbeIZQmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:42:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QASbPJ040705
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mnvtur9uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:16 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAUFFX025734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:15 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAUFpU002280
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:15 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 0/1] Parent pointers test v2
Date: Wed, 26 Sep 2018 03:28:04 -0700
Message-Id: <1537957685-10753-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the 2nd revision of a new xfstest group to exercise the parent
pointer code. These tests cover basic parent pointer operations,
including link, unlink, rename, overwrite, hardlinks and error inject.

Points of intrest since v1:
I've split the test into 3 different tests.  The first runs through
simple link, unlink, rename, and overwrite operations.  The next
test exercises handling multiple parent points with hardlinks, and
the last test exercises the error inject and recovery.  These
tests use the new flags in the xfsprogs set which helped to drop
the run time from a minute down to a few seconds.  I've also
factored out some of the common code into a new common/parent
file. 

As always, comments and feedback are appreciated.  Thank you!

Allison

Allison Henderson (1):
  xfstests: Add parent pointer test

 common/parent     |  196 +++++++++++
 common/rc         |    3 +
 tests/xfs/491     |  156 +++++++++
 tests/xfs/491.out |   70 ++++
 tests/xfs/492     |  134 +++++++
 tests/xfs/492.out | 1009 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/493     |  143 ++++++++
 tests/xfs/493.out |   27 ++
 tests/xfs/group   |    4 +
 9 files changed, 1742 insertions(+)
 create mode 100644 common/parent
 create mode 100755 tests/xfs/491
 create mode 100644 tests/xfs/491.out
 create mode 100755 tests/xfs/492
 create mode 100644 tests/xfs/492.out
 create mode 100755 tests/xfs/493
 create mode 100644 tests/xfs/493.out

-- 
2.7.4
