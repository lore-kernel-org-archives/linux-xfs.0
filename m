Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE9F07F37
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 05:10:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AEBA48F808E
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 03:10:09 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id bhd5Bfe5vtk0YNuk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Aug 2013 03:10:08 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Wed, 7 Aug 2013 06:10:07 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id ECF956E803C
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 06:10:00 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r77AA5ch31457528
	for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 06:10:05 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r77AA5cO001881 for <xfs@oss.sgi.com>; Wed, 7 Aug 2013 07:10:05 -0300
From: zwu.kernel@gmail.com
Subject: [PATCH 00/12] xfs: a chunk of comment fixes
Date: Wed,  7 Aug 2013 18:10:57 +0800
Message-Id: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
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

  Submit a chunk of xfs commnt fixes.

Zhi Yong Wu (12):
  xfs: fix the comment of xfs_check_sizes()
  xfs: fix the comment of xfs_buf_free()
  xfs: fix the comment of xfs_btree_lookup()
  xfs: fix the comment of xfs_mod_incore_sb_unlocked()
  xfs: fix the comment of xlog_write_setup_copy()
  xfs: remove one blank line in xfs_btree_make_block_unfull()
  xfs: fix the comment of xfs_iroot_realloc()
  xfs: fix the comment of xfs_btree_get_iroot()
  xfs: remove two unused macro definitions in xfs_linux.h
  xfs: fix the comment of xlog_recover_buffer_pass2()
  xfs: fix the comment of xlog_find_head()
  xfs: rename bio_add_buffer() to xfs_bio_add_buffer()

 fs/xfs/xfs_aops.c        | 4 ++--
 fs/xfs/xfs_btree.c       | 5 ++---
 fs/xfs/xfs_buf.c         | 2 +-
 fs/xfs/xfs_inode.c       | 2 +-
 fs/xfs/xfs_linux.h       | 2 --
 fs/xfs/xfs_log.c         | 2 +-
 fs/xfs/xfs_log_recover.c | 4 ++--
 fs/xfs/xfs_mount.c       | 4 ++--
 8 files changed, 11 insertions(+), 14 deletions(-)

-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
