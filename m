Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933217AbdCaRbo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:31:44 -0400
Subject: [PATCH 3/8] statx: remove incorrect part of vfs_statx() comment
From: David Howells <dhowells@redhat.com>
Date: Fri, 31 Mar 2017 18:31:40 +0100
Message-ID: <149098150062.28108.13564580307876562192.stgit@warthog.procyon.org.uk>
In-Reply-To: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Eric Biggers <ebiggers@google.com>

request_mask and query_flags are function arguments, not passed in
struct kstat.  So remove the part of the comment which claims otherwise.
This was apparently left over from an earlier version of the statx
patch.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

 fs/stat.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index df484a60846d..b792dd201c31 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -159,9 +159,6 @@ EXPORT_SYMBOL(vfs_statx_fd);
  * Additionally, the use of AT_SYMLINK_NOFOLLOW in flags will prevent a symlink
  * at the given name from being referenced.
  *
- * The caller must have preset stat->request_mask as for vfs_getattr().  The
- * flags are also used to load up stat->query_flags.
- *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
 int vfs_statx(int dfd, const char __user *filename, int flags,

