Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755982AbdLVMGK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Dec 2017 07:06:10 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v4 02/19] fs: don't take the i_lock in inode_inc_iversion
Date: Fri, 22 Dec 2017 07:05:39 -0500
Message-Id: <20171222120556.7435-3-jlayton@kernel.org>
In-Reply-To: <20171222120556.7435-1-jlayton@kernel.org>
References: <20171222120556.7435-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

From: Jeff Layton <jlayton@redhat.com>

The rationale for taking the i_lock when incrementing this value is
lost in antiquity. The readers of the field don't take it (at least
not universally), so my assumption is that it was only done here to
serialize incrementors.

If that is indeed the case, then we can drop the i_lock from this
codepath and treat it as a atomic64_t for the purposes of
incrementing it. This allows us to use inode_inc_iversion without
any danger of lock inversion.

Note that the read side is not fetched atomically with this change.
The assumption here is that that is not a critical issue since the
i_version is not fully synchronized with anything else anyway.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/iversion.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index bb50d27c71f9..e08c634779df 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -104,12 +104,13 @@ inode_set_iversion_queried(struct inode *inode, const u64 new)
 static inline bool
 inode_maybe_inc_iversion(struct inode *inode, bool force)
 {
-	spin_lock(&inode->i_lock);
-	inode->i_version++;
-	spin_unlock(&inode->i_lock);
+	atomic64_t *ivp = (atomic64_t *)&inode->i_version;
+
+	atomic64_inc(ivp);
 	return true;
 }
 
+
 /**
  * inode_inc_iversion - forcibly increment i_version
  * @inode: inode that needs to be updated
-- 
2.14.3

