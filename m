Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbeAEDjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 22:39:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w053aTI9106690
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:24 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2fa0bqr4fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jan 2018 03:39:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w053dM7e028944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:23 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w053dMa1016653
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:22 GMT
Subject: [PATCH 0/3] xfs: refactors for xfsprogs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Jan 2018 19:39:21 -0800
Message-ID: <151512356118.14363.7797314285394643799.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a short patch series of libxfs refactors mostly done for the
benefit of debugging purposes and fixing things in xfsprogs:

The first patch reports transaction reservation data via tracepoints;
eventually xfs_db will grow a similar command so that one can compare
transaction reservations to debug "log minimum size checks fail on
freshly mkfs'd fs" problems.

Patches 2 & 3 move the xfs_fsop_geometry generator function into
libsxfs so that xfsprogs can have common functions to generate the
geometry from a superblock and print the geometry.  Eventually I'll
teach xfs_db, mkfs, and xfs_spaceman to query fs geometry (either
directly or via ioctl) and then pretty print the same information.

--D
