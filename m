Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLBmGlq035165 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 05:48:16 -0600
Message-ID: <4B2F6171.4090108@gmail.com>
Date: Mon, 21 Dec 2009 19:52:17 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
MIME-Version: 1.0
Subject: [PATCHv2 01/12]posix_acl: Add the check items
Reply-To: qingshenlwy@gmail.com
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
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, joel.becker@oracle.com, cjb@laptop.org, jmorris@namei.org, serue@us.ibm.com, hch@lst.de, akpm@linux-foundation.org, adilger@sun.com, jack@suse.cz, tytso@mit.edu, dwmw2@infradead.org, swhiteho@redhat.com, bfields@fieldses.org, neilb@suse.de, ffilzlnx@us.ibm.com, bharrosh@panasas.com, mfasheh@suse.com, tiger.yang@oracle.com, jeffm@suse.com, aelder@sgi.com, sandeen@sandeen.net, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, strongzgy@gmail.com, onlyflyer@gmail.com

Add the acl validation check-items
to fix the null pointer error and PTR_ERR error.

Thanks for Matthew Wilcox's sguuestion.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Frank Filz <ffilzlnx@us.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Tiger Yang <tiger.yang@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com
Cc: reiserfs-devel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com
Cc: linux-nfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
Cc: linux-mtd@lists.infradead.org

--
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..d4bacb9 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -76,6 +76,12 @@ posix_acl_valid(const struct posix_acl *acl)
unsigned int id = 0; /* keep gcc happy */
int needs_mask = 0;

+ if (!acl)
+ return -EINVAL;
+
+ if (IS_ERR(acl))
+ return PTR_ERR(acl);
+
FOREACH_ACL_ENTRY(pa, acl, pe) {
if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
return -EINVAL;

-- 
Best Regards,
Liuwenyi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
