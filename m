Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 139AB7F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 07:28:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02734304066
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 05:28:04 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id rzHW8lLea6PIbKly (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 05:27:53 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] fs: Fix WARN_ON in inode_set_mask()
Date: Thu,  4 Dec 2014 14:27:36 +0100
Message-Id: <1417699659-14284-3-git-send-email-jack@suse.cz>
In-Reply-To: <1417699659-14284-1-git-send-email-jack@suse.cz>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

WARN_ON in inode_set_mask() warns if we don't clear all bits we are
setting instead of reverse - warning when caller requests setting and
clearing of the same bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index fcc0886c5824..3490389dc813 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1923,7 +1923,7 @@ void inode_set_flags(struct inode *inode, unsigned int flags,
 {
 	unsigned int old_flags, new_flags;
 
-	WARN_ON_ONCE(flags & ~mask);
+	WARN_ON_ONCE(flags & mask);
 	do {
 		old_flags = ACCESS_ONCE(inode->i_flags);
 		new_flags = (old_flags & ~mask) | flags;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
