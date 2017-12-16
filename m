Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756981AbdLPNr0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:26 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 11/19] nfsd: convert to new i_version API
Date: Sat, 16 Dec 2017 08:46:48 -0500
Message-Id: <20171216134656.15561-12-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

Mostly just making sure we use the "get" wrappers so we know when
it is being fetched for later use.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfsd/nfsfh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 43f31cf49bae..7dedda5e3ed4 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -259,7 +259,7 @@ static inline u64 nfsd4_change_attribute(struct inode *inode)
 	chattr =  inode->i_ctime.tv_sec;
 	chattr <<= 30;
 	chattr += inode->i_ctime.tv_nsec;
-	chattr += inode->i_version;
+	chattr += inode_query_iversion(inode);
 	return chattr;
 }
 
-- 
2.14.3

