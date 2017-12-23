Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757165AbdLWBOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1C7j6079460
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:04 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN175IJ026747
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:05 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN1751G009048
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:05 GMT
Subject: [PATCH v3 00/20] xfs: more and better verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:07:03 -0800
Message-ID: <151399122361.23543.15718507168231759645.stgit@magnolia>
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
to the verifiers that we've been talking about for the past six months
or so into a single patch series!

The first and third patches replace some macros with the more robust
helpers introduced in 4.15.

The second patch refactors the long format btree block header verifier
into a single helper function.

The fourth patch de-macros the dir block verifiers to make them less
shouty.

Next, we change verifier functions to return the approximate instruction
pointer of the faulting test so that we can report more precise fault
information to dmesg/tracepoints.

Patches 8-14 create verifiers for all the inline format fork formats,
and create a helper function for _iget that can dispatch inline
verification.  The ability to supply custom verifier functions will be
used by xfs_repair to deal with corrupt inodes.

The next two patches enable us to (re)check the structure of incore
metadata buffers to try to detect memory corruption, then adapts the
online scrubber to use this.

The two patches after that separate the disk quota buffer verifiers into
separate check and repair routines and restructure the verifier to
follow the structure of the other verifiers.

The final two patches in this series clean up 'void *' instruction
pointer use and enlarge the bad buffer hex dumps to 128 bytes since v5
headers are actually that large.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.15-rc4 + the online scrub xref series.  xfsprogs[2] and xfstests[3]
can be found in their usual places.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
