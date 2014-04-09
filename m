Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9210D806A
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:21:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59292304043
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 12:21:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3uKZdNUiPnHu69lG for
	<xfs@oss.sgi.com>; Wed, 09 Apr 2014 12:21:54 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s39JLrYI026327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 15:21:53 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s39JLqsN019896
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 15:21:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/2] xfs: tmpfile fixes for inode security/acl
Date: Wed,  9 Apr 2014 15:21:49 -0400
Message-Id: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
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

Here's a v2 of the tmpfile and selinux deadlock patch. Since we also
probably want to create the default acl, I created a generic helper out
of xfs_vn_mknod().

Once I got that far, I noticed xfs_create_tmpfile() looked quite similar
to xfs_create(). Patch 2 folds the former into the latter and eliminates
the duplicate code. Patch 2 is optional with regard to addressing the
selinux issue. Lightly tested... thoughts, reviews, flames appreciated.

Brian

v2:
- Added a generic create helper to inherit the security/acl init. code
  in the tmpfile path.
- Added patch 2 to fold xfs_create_tmpfile() into xfs_create().

Brian Foster (2):
  xfs: fix tmpfile/selinux deadlock and initialize security/acl
  xfs: fold xfs_create_tmpfile() into xfs_create()

 fs/xfs/xfs_inode.c | 184 ++++++++++++++---------------------------------------
 fs/xfs/xfs_inode.h |   2 +-
 fs/xfs/xfs_iops.c  |  43 +++++++++----
 fs/xfs/xfs_trace.h |   7 +-
 4 files changed, 81 insertions(+), 155 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
