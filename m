Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752228AbdFLMXi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:38 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v6 12/20] fs: add a new fstype flag to indicate how writeback errors are tracked
Date: Mon, 12 Jun 2017 08:23:06 -0400
Message-Id: <20170612122316.13244-15-jlayton@redhat.com>
In-Reply-To: <20170612122316.13244-1-jlayton@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

Now that we have new infrastructure for handling writeback errors using
errseq_t, we need to convert the existing code to use it. We could
attempt to retrofit the old interfaces on top of the new, but there is
a conceptual disconnect here in the case of internal callers that
invoke filemap_fdatawait and the like.

When reporting writeback errors, we will always report errors that have
occurred since a particular point in time. With the old writeback error
reporting, the time we used was "since it was last tested/cleared" which
is entirely arbitrary and potentially racy. Now, we can report the
latest error that has occurred since an arbitrary point in time
(represented as a sampled errseq_t value).

This means that we need to touch each filesystem that calls
filemap_check_errors in some fashion and ensure that we establish sane
"since" values for those callers. But...some code is shared between
filesystems and needs to be able to handle both error tracking schemes.

Add a new FS_WB_ERRSEQ flag to the fstype. Later patches will set and
key off of that to decide what behavior should be used.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6cd87887430b..17ba6284ab14 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2023,6 +2023,7 @@ struct file_system_type {
 #define FS_BINARY_MOUNTDATA	2
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
+#define FS_WB_ERRSEQ		16	/* errseq_t writeback err tracking */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
-- 
2.13.0

