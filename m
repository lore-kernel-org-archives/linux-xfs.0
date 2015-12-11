Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 601DC7F3F
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 05:10:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D89D1AC003
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:10:34 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id gAVuF8J5gM9he3v2 (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2015 03:10:29 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NZ6017C3XPFIZA0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Fri, 11 Dec 2015 20:10:27 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 0/4] xfsprogs misc fixes
Date: Fri, 11 Dec 2015 16:38:59 +0530
Message-id: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
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

Changes since v1:
 * to fix integer overflow warnings, change variable type instead
   of doing typecast

Vivek Trivedi (4):
  xfsprogs: xfs_io: fix a memory leak in imap_f
  xfsprogs: fix integer overflow in xlog_find_verify_cycle
  xfsprogs: mkfs: fix unintentional integer overflow
  xfsprogs: xfsdb: remove unnessary checks in
    process_leaf_node_dir_v2_free

 db/check.c                |    2 --
 io/imap.c                 |    7 ++++++-
 libxlog/xfs_log_recover.c |    2 +-
 mkfs/xfs_mkfs.c           |    2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
