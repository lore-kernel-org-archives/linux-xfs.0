Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752779AbdIBWmB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 18:42:01 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v82MfMQC021548
        for <linux-xfs@vger.kernel.org>; Sat, 2 Sep 2017 15:42:00 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2cqrp71bpe-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 02 Sep 2017 15:42:00 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v2 0/3] XFS real-time device tweaks
Date: Sat, 2 Sep 2017 15:41:42 -0700
Message-ID: <20170902224145.1291030-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, darrick.wong@oracle.com

Taking another run at this based on all the feedback (much appreciated). 

- Replaced rtdefault with rtdisable, this yields similar operational
benefits when combined with the existing mkfs time setting of the inheritance
flag on the root directory.  Allows temporary disabling of real-time allocation
without having to walk entire FS to remove flags (which could be time consuming).
I still don't think it's super obvious to an admin the real-time flag was put
there at mkfs time (vs. rtdefault being in mount flags), but this gets me
half of what I'm after.
- rtstatfs flag is removed, instead per Dave's suggestion we look for the
inheritance flag on the directory inode, if so we fill the statfs struct
with the real-time block info, otherwise data block info.  Open to making
this behavior a flag if folks are worried it might be a jarring change
to folks used to the old behavior (i.e. data device info no matter what).
- rtfallocmin no changes, need to think more about this.  Still a pretty big
fan of this option for reasons already stated; at least until a more elegant
solution such as preferred AGs (we'd need a tunable size for the "preferred"
AG, since our SSD partitions are a fraction of the size of a normal AG) can 
be implemented.  The only other idea I have is to make a new ioctl e.g. 
"norealtime", which causes the RT bits to stay cleared regardless of 
inheritance bits on the containing directory.  This would allowing the 
"steering" of files to the data device (e.g. SSD); this is probably a safer 
design than defaulting to SSD and steering to the HDD via the realtime ioctl.  

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

