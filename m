Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A05C7FC5
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:21:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B2A7304053
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id za65dVWbsJhCGC3P (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:41 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 28/48] richacl: Set the owner permissions to the owner mask
Date: Fri, 16 Oct 2015 17:18:06 +0200
Message-Id: <1445008706-15115-29-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

In the write-through case, change the acl so that owner@ is granted the
permissions set in the owner mask (to match what the permission check
algorithm grants the owner).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_compat.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 7d007d7..16deeb4 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -416,3 +416,49 @@ richacl_propagate_everyone(struct richacl_alloc *alloc)
 	}
 	return 0;
 }
+
+/**
+ * richacl_set_owner_permissions  -  set the owner permissions to the owner mask
+ *
+ * In the write-through case, change the acl so that owner@ is granted the
+ * permissions set in the owner mask (to match what the permission check
+ * algorithm grants the owner).  This leaves at most one efective owner@ allow
+ * entry at the beginning of the acl.
+ */
+static int
+richacl_set_owner_permissions(struct richacl_alloc *alloc)
+{
+	unsigned int x = RICHACE_POSIX_ALWAYS_ALLOWED;
+	unsigned int owner_mask = alloc->acl->a_owner_mask & ~x;
+	unsigned int denied = 0;
+	struct richace *ace;
+
+	if (!((alloc->acl->a_flags & RICHACL_WRITE_THROUGH)))
+		return 0;
+
+	richacl_for_each_entry(ace, alloc->acl) {
+		if (richace_is_owner(ace)) {
+			if (richace_is_allow(ace) && !(owner_mask & denied)) {
+				richace_change_mask(alloc, &ace, owner_mask);
+				owner_mask = 0;
+			} else
+				richace_change_mask(alloc, &ace, 0);
+		} else {
+			if (richace_is_deny(ace))
+				denied |= ace->e_mask;
+		}
+	}
+
+	if (owner_mask & (denied |
+			  ~alloc->acl->a_other_mask |
+			  ~alloc->acl->a_group_mask)) {
+		ace = alloc->acl->a_entries;
+		if (richacl_insert_entry(alloc, &ace))
+			return -1;
+		ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = RICHACE_SPECIAL_WHO;
+		ace->e_mask = owner_mask;
+		ace->e_id.special = RICHACE_OWNER_SPECIAL_ID;
+	}
+	return 0;
+}
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
