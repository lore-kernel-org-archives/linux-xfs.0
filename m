Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753041AbdIEThp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 15:37:45 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v85JbZuJ028952
        for <linux-xfs@vger.kernel.org>; Tue, 5 Sep 2017 12:37:44 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2cs5ckn2x3-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2017 12:37:44 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v3 0/3] XFS real-time device tweaks
Date: Tue, 5 Sep 2017 12:37:28 -0700
Message-ID: <20170905193731.909535-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

Patch 1: Same, per v2 cover letter.
Patch 2:
- Style updated per Christoph Hellwig's comment
- Fixed bug: statp->f_bavail = statp->f_bfree
Patch 3: Same, per v2 cover letter.  I'm going to try my hand and
putting this into the allocator itself per suggestions, perhaps
there's some non-obvious way I'm not thinking of which can
reduce the risk that folks hit the non-RT accidentally.

Richard Wareing (3):
  fs/xfs: Add rtdisable option
  fs/xfs: Add real-time device support to statfs
  fs/xfs: Add rtfallocmin mount option

 fs/xfs/xfs_file.c  | 16 ++++++++++++++++
 fs/xfs/xfs_inode.c |  6 ++++--
 fs/xfs/xfs_ioctl.c |  7 +++++--
 fs/xfs/xfs_mount.h |  2 ++
 fs/xfs/xfs_super.c | 33 ++++++++++++++++++++++++++++++++-
 5 files changed, 59 insertions(+), 5 deletions(-)

-- 
2.9.3

