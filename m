Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48578 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753375AbdHQXbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:31:33 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7HNVWaw026797
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:31:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNVVEJ006322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:31:31 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNVVsJ007738
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:31:31 GMT
Subject: [RFC 00/12] xfs: more and better verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 17 Aug 2017 16:31:29 -0700
Message-ID: <150301268960.5851.2513223883233763065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Hi all,

This RFC combines all the random little fixes and improvements to the
verifiers that we've been talking about for the past month or so into a
single patch series!

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
