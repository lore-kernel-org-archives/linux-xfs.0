Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7CAq0J215430 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 06:10:53 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dpAiK6ZlkGpTiMif (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 04:13:17 -0800 (PST)
Message-ID: <50C1DD4E.80909@oracle.com>
Date: Fri, 07 Dec 2012 20:13:02 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 0/4] xfs: Kill the hardcode number 128 for transactions space
	reservation
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

We have a hard code number of "128" for almost all sorts of transactions space reservations.
This number is used to reserve the space for the struct xfs_buf_log_format that gets written
into the log for every buffer as well as a little bit of extra space because there also needs
a log opheader, i.e. struct xlog_op_header.

This idea is totally inspired by Dave's comments at: 
http://oss.sgi.com/archives/xfs/2012-12/msg00009.html
I'll add Signed-off-by for Dave once the patches are qualified to be accept for his credit.

The patches replace the magic number with a new function xfs_buf_log_overhead(), which is
introduced to examine the extra buf log space more flexible than hard coding it.

Maybe it's better to tweak it up in a macro to make the code style in xfs_trans.c looks a bit neat?
#define XFS_BUF_LOG_OVERHEAD (xfs_buf_log_overhead())

To make sure there is no regression with those changes, I have run dozens of xfs test cases, they
are works to me.

[PATCH 1/4] Add a new function xfs_buf_log_overhead() to replace the hard-code number of 128
[PATCH 2/4] Make xfs_fs_log_dummy() aware of this change
[PATCH 3/4] Make super block unit change related transactions aware of this change
[PATCH 4/4] Make disk quota related transactions aware of this change

---
 fs/xfs/xfs_dquot.c       |    6 ++-
 fs/xfs/xfs_fsops.c       |    5 +-
 fs/xfs/xfs_mount.c       |   15 +++---
 fs/xfs/xfs_qm.c          |    6 +--
 fs/xfs/xfs_qm_syscalls.c |   20 ++++----
 fs/xfs/xfs_trans.c       |  113 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_trans.h       |    4 +-
 7 files changed, 106 insertions(+), 63 deletions(-)


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
