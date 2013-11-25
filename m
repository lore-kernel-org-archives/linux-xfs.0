Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B32EB7F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:32:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F43AAC002
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 03:32:44 -0800 (PST)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id cSgW1nTCjffVrFr3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 03:32:43 -0800 (PST)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Mon, 25 Nov 2013 04:32:42 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com
	(b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id D748C19D8045
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:32:34 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08026.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id rAP9Upwa19792008
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 10:30:52 +0100
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP
	id rAPBWdkk024499
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:32:40 -0700
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [RFC PATCH 0/4] xfs: add O_TMPFILE support
Date: Mon, 25 Nov 2013 19:32:30 +0800
Message-Id: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

HI, folks

The patchset is trying to add O_TMPFILE support to xfs. To make sure
that it is going ahead in the right direction, although it is only one
code draft, and hasn't strictly been tested, it is still post out ASAP.

For more information, please refer to Dave Chinner's RFD links:
  1.) http://oss.sgi.com/archives/xfs/2013-08/msg00339.html
  2.) http://oss.sgi.com/archives/xfs/2013-08/msg00336.html
  3.) http://oss.sgi.com/archives/xfs/2013-08/msg00341.html

Any comments are appreciated, thanks.

Zhi Yong Wu (4):
  xfs: adjust the interface of xfs_qm_vop_dqalloc()
  xfs: add xfs_create_tmpfile() for O_TMPFILE support
  xfs: add a new method xfs_vn_tmpfile()
  xfs: allow linkat() on O_TMPFILE files

 fs/xfs/xfs_inode.c       |  154 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h       |    2 +
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iops.c        |   24 +++++++-
 fs/xfs/xfs_qm.c          |   50 +++++++++------
 fs/xfs/xfs_quota.h       |    6 +-
 fs/xfs/xfs_shared.h      |    4 +-
 fs/xfs/xfs_symlink.c     |    2 +-
 fs/xfs/xfs_trans_resv.c  |   48 ++++++++++++++
 fs/xfs/xfs_trans_resv.h  |    4 +
 fs/xfs/xfs_trans_space.h |    2 +
 11 files changed, 270 insertions(+), 28 deletions(-)

-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
