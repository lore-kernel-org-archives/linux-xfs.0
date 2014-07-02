Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C85F87F66
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 09:52:22 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DFB4AC001
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:52:19 -0700 (PDT)
Received: from eagdhcp-232-174.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-174.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s62EqELX005621
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2014 09:52:14 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-174.americas.sgi.com)
Message-Id: <20140702143206.438456679@sgi.com>
Date: Wed, 02 Jul 2014 09:32:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/5] Misc controversial patches
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

Here is a repost of these patches.

Patch one and two deal with EFIs getting stuck on the AIL and hanging
unmount. First deals with log recovery the other xfs_bmap_finish and
log write errors:

	xfs-fix-efi-in-log-recovery-error.patch
	xfs-fix-efi-on-filesystem-errors.patch

Patch three and four deal with resource leaks in failed log recoveries.
The first is a rewrite of Dave's rewrite of my patch with ideas from
Christoph. The second is taking care of leaked inode pointers:

	xfs-fix-log-recovery-leaks.patch
	xfs-reclaim-inodes-on-recovery-fail.patch 

Lastly is the CIL sequence error. The setting of ctx->commit_lsn
in xlog_cil_init_post_recovery allows smaller cil push sequences finish
out of order:

	xfs-fix-cil-push-seq-after-recovery.patch

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
