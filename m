Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145801.ryupq4xogid66fom@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42011 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751053AbdBWItx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 03:49:53 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1N6KAlZ101048
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2017 01:22:13 -0500
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28sdf5wt85-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2017 01:22:13 -0500
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 23 Feb 2017 16:22:10 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id A397C3578056
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2017 17:22:08 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1N6M01W17563704
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2017 17:22:08 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1N6LaL3029683
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2017 17:21:36 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Clarification on inode alignment
Date: Thu, 23 Feb 2017 11:51:12 +0530
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1735943.rpnT4cuqyx@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dchinner@redhat.com
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "Darrick J . Wong" <darrick.wong@oracle.com>

Hi Dave,

Last week, during a discussion on #xfs you stated that,

"inode alignment is necessary to avoid needing to do an inobt lookup to find
the location of the inode every time we map an inode to disk".

Also, The following statement appears at
http://xfs.org/index.php/Improving_inode_Caching,

"The main problem we have is that XFS uses inode chunk size and alignment to
optimise inode number to disk location conversion. That is, the conversion
becomes a single set of shifts and masks instead of an AGI btree lookup. This
optimisation substantially reduces the CPU and I/O overhead of inode lookups,
but it does limit our flexibility. If we break the alignment restriction,
every lookup has to go back to a btree search. Hence we really want to avoid
breaking chunk alignment and size rules."

For the 4k block size scenario, I noticed that we have inode alignment of 4
blocks. I did go through macros such as XFS_INO_TO_AGNO(),
XFS_INO_TO_AGBNO() and XFS_INO_TO_OFFSET() which deal with extracting the
components from an inode number.

However I still don't understand how non-aligned inode clusters (64 inodes in
a single cluster) would break the inode number to disk location
arithmetic calculations. Could you please explain it?

-- 
chandan

