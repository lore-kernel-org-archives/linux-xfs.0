Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 604D37F6D
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 03:28:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 39EC48F8037
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 01:28:38 -0800 (PST)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 1ar0mRpDcyLBM9ri for
	<xfs@oss.sgi.com>; Thu, 28 Feb 2013 01:28:36 -0800 (PST)
Date: Thu, 28 Feb 2013 04:28:35 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <2103242337.7001373.1362043715738.JavaMail.root@redhat.com>
In-Reply-To: <130819766.6999797.1362043338279.JavaMail.root@redhat.com>
Subject: possible fsync02() xfs slowness regression on power7
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Steve Best <sbest@redhat.com>

This LTP test starting to fail using the latest upstream kernel on one of the power7
systems here, http://tinyurl.com/bngwouj

# ./fsync02
fsync02     1  TFAIL  :  fsync took too long: 252.000000 seconds; max_block: 214

When it is working, the test is almost returned immediately. The bisecting so far
indicated that one or a few of the following could be culprits.

# git log --pretty=oneline 498f7f505dc79934c878c7667840c50c64f232fc..b199c8a4ba11879df87daad496ceee41fdc6aa82
b199c8a4ba11879df87daad496ceee41fdc6aa82 xfs: Pull EFI/EFD handling out from under the AIL lock
9c5f8414efd5eeed9f498d4170337a3eb126341f xfs: fix EFI transaction cancellation.
821eb21d97a8b686649c08b7284d0b9f34d0e138 xfs: connect up buffer reclaim priority hooks
430cbeb86fdcbbdabea7d4aa65307de8de425350 xfs: add a lru to the XFS buffer cache
ff57ab21995a8636cfc72efeebb09cc6034d756f xfs: convert xfsbud shrinker to a per-buftarg shrinker.
1a427ab0c1b205d1bda8da0b77ea9d295ac23c57 xfs: convert pag_ici_lock to a spin lock
1a3e8f3da09c7082d25b512a0ffe569391e4c09a xfs: convert inode cache lookups to use RCU locking
d95b7aaf9ab6738bef1ebcc52ab66563085e44ac xfs: rcu free inodes
6e857567dbbfe14dd6cc3f7414671b047b1ff5c7 xfs: don't truncate prealloc from frequently accessed inodes
055388a3188f56676c21e92962fc366ac8b5cb72 xfs: dynamic speculative EOF preallocation
622d81494fa32343a4b97b607619656c7a4a6d1a xfs: use KM_NOFS for allocations during attribute list operations
dcfcf20512cb517ac18b9433b676183fa1257911 xfs: provide a inode iolock lockdep class
489a150f6454e2cd93d9e0ee6d7c5a361844f62a xfs: factor duplicate code in xfs_alloc_ag_vextent_near into a helper
9f9baab38dacd11fe6095a1e59f3783a305f7020 xfs: clean up xfs_alloc_ag_vextent_exact
ecff71e677c6d469f525dcf31ada709d5858307c xfs: simplify xfs_map_at_offset
aeea1b1f81800e362a3aca86d769d02e137a8fa7 xfs: refactor xfs_vm_writepage
2fa24f92530edaf86c3b5f662464e0d2e3b3e517 xfs: remove the all_bh flag from xfs_convert_page
ed1e7b7e484dfb64168755613d499f32a97409bd xfs: remove xfs_probe_cluster
8ff2957d581582890693affc09920108a67cb05d xfs: simplify xfs_map_blocks
a206c817c864583c44e2f418db8e6c7a000fbc38 xfs: kill xfs_iomap

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
