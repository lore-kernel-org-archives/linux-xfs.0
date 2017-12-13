Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:58:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNlWfN024891
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:17 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2eudq605f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:17 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwGix004015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:16 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwFkR011608
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:16 GMT
Subject: [PATCH 00/13] xfs: more and better verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:58:13 -0800
Message-ID: <151320949282.30654.14805160700975182459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This patch series combines all the random little fixes and improvements
to the verifiers that we've been talking about for the past month or so
into a single patch series!

We start by refactoring the long format btree block header verifier into
a single helper functionn and de-macroing dir block verifiers to make
them less shouty.  Next, we change verifier functions to return the
approximate instruction pointer of the faulting test so that we can
report more precise fault information to dmesg/tracepoints.  Then, we
move on to creating verifiers for all the inline format fork formats,
and create a helper function for _iget that can dispatch inline
verification.  The ability to supply custom verifier functions will be
used by xfs_repair to deal with corrupt inodes.  The last patch enables
us to (re)check the structure of incore metadata buffers to try to
detect memory corruption.

--D
