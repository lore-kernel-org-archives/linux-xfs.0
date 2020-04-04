Return-Path: <SRS0=tkuD=5U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FC7C2BA16
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Apr 2020 08:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A529C21556
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Apr 2020 08:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgDDItN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Apr 2020 04:49:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDDItM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Apr 2020 04:49:12 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0348XmtA165742;
        Sat, 4 Apr 2020 04:49:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 306pua06ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 04:49:08 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0348jXFx188305;
        Sat, 4 Apr 2020 04:49:07 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 306pua06uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 04:49:07 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0348jkrp028749;
        Sat, 4 Apr 2020 08:49:06 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 306hv5hnq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 08:49:06 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0348n5An25035140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 4 Apr 2020 08:49:05 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF5B212405B;
        Sat,  4 Apr 2020 08:49:05 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 828DA124053;
        Sat,  4 Apr 2020 08:49:03 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.87.225])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  4 Apr 2020 08:49:03 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 0/2] Extend xattr extent counter to 32-bits
Date:   Sat,  4 Apr 2020 14:22:01 +0530
Message-Id: <20200404085203.1908-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-04_04:2020-04-03,2020-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004040075
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
https://github.com/chandanr/linux.git at branch 32bit-anextents-v0.


Chandan Rajendra (2):
  xfs: Fix log reservation calculation for xattr insert operation
  xfs: Extend xattr extent counter to 32-bits

 fs/xfs/libxfs/xfs_attr.c        |  6 +---
 fs/xfs/libxfs/xfs_format.h      | 28 ++++++++++++-----
 fs/xfs/libxfs/xfs_inode_buf.c   | 27 ++++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c  |  3 +-
 fs/xfs/libxfs/xfs_log_format.h  |  5 +--
 fs/xfs/libxfs/xfs_log_rlimit.c  | 29 ------------------
 fs/xfs/libxfs/xfs_trans_resv.c  | 54 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_trans_resv.h  |  5 +--
 fs/xfs/libxfs/xfs_trans_space.h |  8 ++++-
 fs/xfs/libxfs/xfs_types.h       |  4 +--
 fs/xfs/scrub/inode.c            |  7 +++--
 fs/xfs/xfs_inode_item.c         |  3 +-
 fs/xfs/xfs_log_recover.c        | 13 ++++++--
 13 files changed, 96 insertions(+), 96 deletions(-)

-- 
2.19.1

