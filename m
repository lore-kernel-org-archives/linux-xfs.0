Return-Path: <SRS0=tkuD=5U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3470CC2BA16
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Apr 2020 08:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BE320737
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Apr 2020 08:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgDDIti (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Apr 2020 04:49:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgDDIti (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Apr 2020 04:49:38 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0348Wvou055431;
        Sat, 4 Apr 2020 04:49:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306nhr9krq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 04:49:33 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0348gLH0072617;
        Sat, 4 Apr 2020 04:49:33 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306nhr9kre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 04:49:33 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0348jks5028749;
        Sat, 4 Apr 2020 08:49:32 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 306hv5hnre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 08:49:32 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0348nVcG44892470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 4 Apr 2020 08:49:31 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7101CBE051;
        Sat,  4 Apr 2020 08:49:31 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 510D7BE04F;
        Sat,  4 Apr 2020 08:49:29 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.87.225])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat,  4 Apr 2020 08:49:28 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 0/2] Extend xattr extent counter to 32-bits
Date:   Sat,  4 Apr 2020 14:22:27 +0530
Message-Id: <20200404085229.2034-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-04_05:2020-04-03,2020-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1034 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004040080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
which
1. Creates 1,000,000 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to create 400,000 new 255-byte sized xattrs
causes the following message to be printed on the console,

XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173

This indicates that we overflowed the 16-bits wide xattr extent counter.

I have been informed that there are instances where a single file has > 100
million hardlinks. With parent pointers being stored in xattr, we will
overflow the 16-bits wide xattr extent counter when large number of
hardlinks are created.

This patchset also includes the previously posted "Fix log reservation
calculation for xattr insert operation" patch as a bug fix. It now
replaces the xattr set "mount" and "runtime" reservations with just
one static reservation. Hence we don't need the funcationality to
calculate maximum sized 'xattr set' reservation separately anymore.

The patches can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
32bit-anextents-v0.

Chandan Rajendra (2):
  xfsprogs: Fix log reservation calculation for xattr insert operation
  xfsprogs: Extend attr extent counter to 32-bits

 db/bmap.c                |  4 +--
 db/btdump.c              |  2 +-
 db/check.c               |  3 +-
 db/field.c               |  2 --
 db/field.h               |  1 -
 db/frag.c                |  6 ++--
 db/inode.c               | 10 ++++---
 db/metadump.c            |  4 +--
 libxfs/xfs_attr.c        |  6 +---
 libxfs/xfs_format.h      | 32 +++++++++++++++------
 libxfs/xfs_inode_buf.c   | 28 +++++++++++++------
 libxfs/xfs_inode_fork.c  |  3 +-
 libxfs/xfs_log_format.h  |  5 ++--
 libxfs/xfs_log_rlimit.c  | 29 -------------------
 libxfs/xfs_trans_resv.c  | 60 ++++++++++++++++++----------------------
 libxfs/xfs_trans_resv.h  |  5 +---
 libxfs/xfs_trans_space.h |  8 +++++-
 libxfs/xfs_types.h       |  4 +--
 logprint/log_misc.c      |  9 +++++-
 logprint/log_print_all.c |  9 +++++-
 mkfs/xfs_mkfs.c          |  1 +
 repair/attr_repair.c     |  2 +-
 repair/dinode.c          | 29 +++++++++++--------
 23 files changed, 140 insertions(+), 122 deletions(-)

-- 
2.19.1

