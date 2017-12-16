Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756814AbdLPNrF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:05 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 02/19] fs: don't take the i_lock in inode_inc_iversion
Date: Sat, 16 Dec 2017 08:46:39 -0500
Message-Id: <20171216134656.15561-3-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

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
 include/linux/fs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

I'm not dead-set on this patch, but I was a little leery of adding
the i_lock into all of the places that do inode->i_version++ today,
even as an interim step. We can probably drop this patch if it's too
ugly to live...

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5001e77342fd..c234fac4bb77 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2136,9 +2136,9 @@ inode_set_iversion_queried(struct inode *inode, const u64 new)
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
 
-- 
2.14.3

