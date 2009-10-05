Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n95L3A8g239365 for <xfs@oss.sgi.com>; Mon, 5 Oct 2009 16:03:10 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A727117395A0
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2009 14:04:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 86sUiUltBmaKZkEx for
	<xfs@oss.sgi.com>; Mon, 05 Oct 2009 14:04:34 -0700 (PDT)
Message-ID: <4ACA5EB0.4010707@sandeen.net>
Date: Mon, 05 Oct 2009 16:01:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: stack bloat after stackprotector changes
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
To: xfs mailing list <xfs@oss.sgi.com>
Cc: Tejun Heo <tj@kernel.org>

It seems that after:

commit 5d707e9c8ef2a3596ed5c975c6ff05cec890c2b4
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Feb 9 22:17:39 2009 +0900

    stackprotector: update make rules

xfs stack usage jumped up a fair bit;

before:
376 xfs_bmapi
328 xfs_bulkstat
296 _xfs_trans_commit
264 xfs_iomap_write_delay
248 xlog_do_recovery_pass
248 xfs_symlink
248 xfs_file_ioctl
232 xfs_bunmapi
224 xfs_trans_unreserve_and_mod_sb
216 xfs_file_compat_ioctl
216 xfs_cluster_write
216 xfs_bmap_del_extent
200 xfs_probe_cluster
200 xfs_page_state_convert
200 xfs_iomap_write_direct
200 xfs_getbmap
...

after:

408 xfs_bmapi
344 xfs_bulkstat
312 _xfs_trans_commit
312 xfs_file_ioctl
296 xfs_file_compat_ioctl
280 xfs_iomap_write_delay
264 xlog_do_recovery_pass
264 xfs_symlink
264 xfs_bunmapi
248 xfs_bmap_del_extent
248 xfs_bmap_add_extent_delay_real
240 xfs_trans_unreserve_and_mod_sb
232 xfs_iomap_write_direct
232 xfs_cluster_write
216 xfs_probe_cluster
216 xfs_bmap_extents_to_btree
...

Not a lot in each case but could be significant as it accumulates.

I'm not familiar w/ the gcc stack protector feature; would this be an
expected result?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
