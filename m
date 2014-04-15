Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 846087F59
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 11:18:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17B84AC003
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iSIyo8Gi67Wc7pPM for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:29 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3FGIS01002009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3FGISXA022750
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/4] xfs: tmpfile fixes
Date: Tue, 15 Apr 2014 12:18:22 -0400
Message-Id: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here's a v3 series for the patches previously posted here:

http://oss.sgi.com/archives/xfs/2014-04/msg00181.html

Patches 1 and 2 are just a split-up of the v1 patch:

http://oss.sgi.com/archives/xfs/2014-04/msg00149.html

Note the v1 patch has a reviewed-by, so feel free to drop 1 and 2 here
in favor of that version. Patches 3 and 4 are a couple cleanups in the
xfs_create() path.

Setting the default ACL is dropped until it is determined how that
should be handled for tmpfile(). This means the xfs_iops.c refactor bits
have been dropped as well.

Brian

v3:
- Split up the deadlock fix and inode security initialization into
  separate patches. [hch]
- Dropped the default ACL and associated refactor bits for now. [hch]
- Split the xfs_create() tres and xfs_create_tmpfile() cleanups into
  separate patches. [hch]
v2:
- Added a generic create helper to inherit the security/acl init. code
  in the tmpfile path.
- Added patch 2 to fold xfs_create_tmpfile() into xfs_create().

Brian Foster (4):
  xfs: fix tmpfile/selinux ilock deadlock
  xfs: initialize inode security on tmpfile creation
  xfs: replace on-stack xfs_trans_res with pointer in xfs_create()
  xfs: fold xfs_create_tmpfile() into xfs_create()

 fs/xfs/xfs_inode.c | 193 +++++++++++++----------------------------------------
 fs/xfs/xfs_inode.h |   2 -
 fs/xfs/xfs_iops.c  |  20 +++++-
 fs/xfs/xfs_trace.h |   7 +-
 4 files changed, 69 insertions(+), 153 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
