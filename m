Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754261AbdEIQNC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 12:13:02 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v2 3/3] btrfs: allow it to use $SCRATCH_LOGDEV
Date: Tue,  9 May 2017 12:12:45 -0400
Message-Id: <20170509161245.29908-4-jlayton@redhat.com>
In-Reply-To: <20170509161245.29908-1-jlayton@redhat.com>
References: <20170509161245.29908-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, fstests@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

With btrfs, we can't really put the log on a separate device. What we
can do however is mirror the metadata across two devices and put the
data on a single device. When we turn on dmerror then the metadata can
fall back to using the other mirror while the data errors out.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 8b815d9c8c33..2084c1f24f30 100644
--- a/common/rc
+++ b/common/rc
@@ -829,6 +829,8 @@ _scratch_mkfs()
 		;;
 	btrfs)
 		mkfs_cmd="$MKFS_BTRFS_PROG"
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			mkfs_cmd="$mkfs_cmd -d single -m raid1 $SCRATCH_LOGDEV"
 		mkfs_filter="cat"
 		;;
 	ext2|ext3)
-- 
2.9.3

