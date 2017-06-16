Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752652AbdFPTgd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 15:36:33 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v5 1/5] ext4: allow ext4 to use $SCRATCH_LOGDEV
Date: Fri, 16 Jun 2017 15:36:15 -0400
Message-Id: <20170616193619.14576-2-jlayton@redhat.com>
In-Reply-To: <20170616193619.14576-1-jlayton@redhat.com>
References: <20170616193619.14576-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

The writeback error handling test requires that you put the journal on a
separate device. This allows us to use dmerror to simulate data
writeback failure, without affecting the journal.

xfs already has infrastructure for this (a'la $SCRATCH_LOGDEV), so wire
up the ext4 code so that it can do the same thing when _scratch_mkfs is
called.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index ff1b75c9cd25..57001b47a8b7 100644
--- a/common/rc
+++ b/common/rc
@@ -679,6 +679,9 @@ _scratch_mkfs_ext4()
 	local tmp=`mktemp`
 	local mkfs_status
 
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	    $mkfs_cmd -O journal_dev $MKFS_OPTIONS $SCRATCH_LOGDEV && \
+	    mkfs_cmd="$mkfs_cmd -J device=$SCRATCH_LOGDEV"
 
 	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
-- 
2.13.0

