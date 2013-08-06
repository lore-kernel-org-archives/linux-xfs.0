Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82DBF7F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 17:27:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05779AC006
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 15:27:14 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id nsVRDjVf5x2mhrvF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 15:27:13 -0700 (PDT)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 6 Aug 2013 16:27:12 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 4C5531FF001E
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 16:21:46 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r76MRABu340582 for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r76MRAAQ011314
	for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:10 -0600
Received: from chandra-dt.austin.ibm.com (chandra-dt.austin.ibm.com
	[9.41.106.170])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r76MR9TB011257 for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:10 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] Add a new quotactl command to support 3 quota types in XFS
Date: Tue,  6 Aug 2013 17:27:06 -0500
Message-Id: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>

Hello All,

XFS now supports simultaneous use of 3 quota types (user, group,
and project).

In order to support this a new quotactl command is introduced
in this patch series.

Regards,

Chandra
---
Chandra Seetharaman (3):
  quota: Add a new quotactl command Q_XGETQSTATV
  xfs: Add support for the Q_XGETQSTATV
  gfs2: Add support for the Q_XGETQSTATV

 fs/gfs2/quota.c                |   27 +++++++++++++
 fs/quota/quota.c               |   29 ++++++++++++++
 fs/xfs/xfs_qm.h                |    2 +
 fs/xfs/xfs_qm_syscalls.c       |   82 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_quotaops.c          |   13 ++++++
 include/linux/quota.h          |    1 +
 include/uapi/linux/dqblk_xfs.h |   46 ++++++++++++++++++++++
 7 files changed, 200 insertions(+), 0 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
