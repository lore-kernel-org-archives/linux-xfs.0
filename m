Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F03898049
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:20:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B705A30411F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:20:44 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id Nbh85SnDaW5owv60 (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:20:42 -0800 (PST)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02UHTA6F8PD0@mailout3.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:20:39 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 00/11] xfsprogs misc fixes
Date: Wed, 02 Dec 2015 16:49:16 +0530
Message-id: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
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
Cc: Vivek Trivedi <t.vivek@samsung.com>, a.sahrawat@samsung.com, pankaj.m@samsung.com

minor fixes in xfsprogs, mostly coverity reported fixes.

Vivek Trivedi (11):
  xfsprogs: xfs_io: fix a memory leak in imap_f
  xfsprogs: fix integer overflow in xlog_find_verify_cycle
  xfsprogs: mkfs: fix unintentional integer overflow
  xfsprogs: xfsdb: remove unnessary checks in
    process_leaf_node_dir_v2_free
  xfsprogs: xfs_mdrestore: check bad read count in perform_restore
  xfsprogs: xfs_db: check null derefernce after block_to_bt
  xfsprogs: xfs_fsr: replace sprintf with snprintf to avoid buffer
    overflow
  xfsprogs: xfs_repair: fix possible null dereference in build_ino_tree
  xfsprogs: xfs_repair: fix possible null dereference in
    traverse_int_dir2block
  xfsprogs: fix possible null pointer dereference in
    xfs_iformat_extents
  xfsprogs: xfs_repair: fix possible null pointer dereference in
    mark_standalone_inodes

 db/btblock.c              |    3 +++
 db/check.c                |    2 --
 fsr/xfs_fsr.c             |    4 ++--
 io/imap.c                 |    7 ++++++-
 libxfs/xfs_inode_fork.c   |    4 ++++
 libxlog/xfs_log_recover.c |    2 +-
 mdrestore/xfs_mdrestore.c |    4 ++++
 mkfs/xfs_mkfs.c           |    2 +-
 repair/dir2.c             |    2 +-
 repair/phase5.c           |    2 +-
 repair/phase6.c           |    7 +++++--
 11 files changed, 28 insertions(+), 11 deletions(-)

-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
