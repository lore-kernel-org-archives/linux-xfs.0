Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEADE7F96
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:21:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF705304062
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6uU0yQG2KGTTw2P3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:47 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 29/48] richacl: Set the other permissions to the other mask
Date: Fri, 16 Oct 2015 17:18:07 +0200
Message-Id: <1445008706-15115-30-git-send-email-agruenba@redhat.com>
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

Change the acl so that everyone@ is granted the permissions set in the
other mask.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_compat.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 16deeb4..21ee31e 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -462,3 +462,44 @@ richacl_set_owner_permissions(struct richacl_alloc *alloc)
 	}
 	return 0;
 }
+
+/**
+ * richacl_set_other_permissions  -  set the other permissions to the other mask
+ * @alloc:	acl and number of allocated entries
+ * @added:	permissions added for everyone@
+ *
+ * Change the acl so that everyone@ is granted the permissions set in the other
+ * mask.  This leaves at most one efective everyone@ allow entry at the end of
+ * the acl.  If everyone@ end up being granted additional permissions, these
+ * permissions are returned in @added.
+ */
+static int
+richacl_set_other_permissions(struct richacl_alloc *alloc, unsigned int *added)
+{
+	struct richacl *acl = alloc->acl;
+	unsigned int x = RICHACE_POSIX_ALWAYS_ALLOWED;
+	unsigned int other_mask = acl->a_other_mask & ~x;
+	struct richace *ace;
+
+	if (!(other_mask &&
+	      (acl->a_flags & RICHACL_WRITE_THROUGH)))
+		return 0;
+
+	*added = other_mask;
+	ace = acl->a_entries + acl->a_count - 1;
+	if (acl->a_count == 0 ||
+	    !richace_is_everyone(ace) ||
+	    richace_is_inherit_only(ace)) {
+		ace++;
+		if (richacl_insert_entry(alloc, &ace))
+			return -1;
+		ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = RICHACE_SPECIAL_WHO;
+		ace->e_mask = other_mask;
+		ace->e_id.special = RICHACE_EVERYONE_SPECIAL_ID;
+	} else {
+		*added &= ~ace->e_mask;
+		richace_change_mask(alloc, &ace, other_mask);
+	}
+	return 0;
+}
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
