Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFCBA7F55
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51CE3AC003
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id x2zJN7chmaDENTiw for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/8] xfsprogs: misc small fixes
Date: Sat, 26 Jan 2013 16:40:24 -0600
Message-Id: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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

A handful of fixes from looking over a Coverity scan.

The strncpy fixes (1/8, 5/8) might not be too critical,
but I think they can't hurt.

The libxfs xfs_alloc_arg initialization (2/8) might clash with Dave's
libxfs syncup, it can be dropped if it makes things difficult.
Fixes a real bug though.

Tested by a quick run through xfstests -g auto

Thanks,
-Eric

[PATCH 1/8] libhandle: Guard against string overflow in path_to_fspath()
[PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
[PATCH 3/8] libxfs: fix setup_cursor array allocation
[PATCH 4/8] xfs_repair: Fix free of uninit ptr in xfs_acl_valid() error path
[PATCH 5/8] xfs_fsr: guard against path string overflows
[PATCH 6/8] xfs_fsr: check strdup results properly in initallfs()
[PATCH 7/8] xfs_fsr: fix attribute no_change_count logic
[PATCH 8/8] xfs_fsr: remove extraneous close() in fsrallfs()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
