Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B4147F6B
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5509AC002
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:05:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EWuuyRTXl893WXbD for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 10:05:49 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s42H5nZ6005067
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s42H5noS026670
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/5] xfstests: fixes for the free inode btree
Date: Fri,  2 May 2014 13:13:57 -0400
Message-Id: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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

This series is a few xfstests fixes and addons for the finobt. Patch 1
fixes xfs/030 to work correctly on finobt-enabled filesystems. Patches 2
and 3 add support for finobt-oriented tests via require functions and
repair filter updates. Patch 4 adds a new test for targeted repair of
finobt filesystems. Patch 5 adds a stress test that creates/modifies a
sparsely allocated set of inodes to effectively exercise the finobt in
conjunction with an fsstress workload.

xfs/010 runs very quickly. xfs/013 runs for 5-10 minutes on my smallish
VM running against a single spindle, so I've been back and forth on
whether it should be part of the auto group. Thoughts, reviews, flames
appreciated...

Brian

Brian Foster (5):
  xfs/030: filter out extra repair noise for finobt enabled fs'
  xfstests: add _require_xfs_[mkfs_]finobt() checks for finobt tests
  xfstests: filter agno/ino repair output for finobt
  xfs/010: test repair for finobt corruption
  xfs/013: stress the free inode btree

 common/rc         |  18 +++++++
 common/repair     |   2 +
 tests/xfs/010     | 133 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/010.out |  57 ++++++++++++++++++++
 tests/xfs/013     | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/013.out |   7 +++
 tests/xfs/030     |   3 +-
 tests/xfs/group   |   2 +
 8 files changed, 376 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/010
 create mode 100644 tests/xfs/010.out
 create mode 100755 tests/xfs/013
 create mode 100644 tests/xfs/013.out

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
