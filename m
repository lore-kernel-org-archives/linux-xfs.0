Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F238929E97
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:23:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DDD338F8040
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:23:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uYu5mlIoRTGLCS64 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:23:18 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 49/51] nfs: Distinguish missing users and groups from
	nobody
Date: Tue,  3 Nov 2015 16:17:25 +0100
Message-Id: <1446563847-14005-50-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

User and group names are mapped to IDs using the kernel keyring infrastructure.
When a name does not exist, it is mapped to the nobody user or group; there is
no way to tell the difference from the mapping result.

In ACLs, we need to make that distinction.  For that, use the new "xuid" and
"xgid" maps: they behave like the old "uid" and "gid" maps except that the IDs
of existing users and groups are prefixed by a "+" sign.

When the "xuid" or "xgid" maps are not supported, nfs falls back to the "uid"
and "gid" maps.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/nfs/nfs4idmap.c        | 57 ++++++++++++++++++++++++++++++++++++++---------
 fs/nfs/nfs4xdr.c          |  6 +++--
 include/linux/nfs_fs_sb.h |  1 +
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index 2e49022..34dd404 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -100,10 +100,12 @@ static bool nfs_fattr_map_owner_name(struct nfs_server *server, struct nfs_fattr
 {
 	struct nfs4_string *owner = fattr->owner_name;
 	kuid_t uid;
+	int ret;
 
 	if (!(fattr->valid & NFS_ATTR_FATTR_OWNER_NAME))
 		return false;
-	if (nfs_map_name_to_uid(server, owner->data, owner->len, &uid) == 0) {
+	ret = nfs_map_name_to_uid(server, owner->data, owner->len, &uid);
+	if (ret == 0 || ret == -ENOENT) {
 		fattr->uid = uid;
 		fattr->valid |= NFS_ATTR_FATTR_OWNER;
 	}
@@ -114,10 +116,12 @@ static bool nfs_fattr_map_group_name(struct nfs_server *server, struct nfs_fattr
 {
 	struct nfs4_string *group = fattr->group_name;
 	kgid_t gid;
+	int ret;
 
 	if (!(fattr->valid & NFS_ATTR_FATTR_GROUP_NAME))
 		return false;
-	if (nfs_map_group_to_gid(server, group->data, group->len, &gid) == 0) {
+	ret = nfs_map_group_to_gid(server, group->data, group->len, &gid);
+	if (ret == 0 || ret == -ENOENT) {
 		fattr->gid = gid;
 		fattr->valid |= NFS_ATTR_FATTR_GROUP;
 	}
@@ -351,20 +355,23 @@ static ssize_t nfs_idmap_lookup_name(__u32 id, const char *type, char *buf,
 }
 
 /* Name -> ID */
+/* Returns -ENOENT for unknown names (with @id set to the nobody id). */
 static int nfs_idmap_lookup_id(const char *name, size_t namelen, const char *type,
 			       __u32 *id, struct idmap *idmap)
 {
-	char id_str[NFS_UINT_MAXLEN];
+	char id_str[NFS_UINT_MAXLEN + 1];
 	long id_long;
 	ssize_t data_size;
 	int ret = 0;
 
-	data_size = nfs_idmap_get_key(name, namelen, type, id_str, NFS_UINT_MAXLEN, idmap);
+	data_size = nfs_idmap_get_key(name, namelen, type, id_str, sizeof(id_str), idmap);
 	if (data_size <= 0) {
 		ret = -EINVAL;
 	} else {
 		ret = kstrtol(id_str, 10, &id_long);
 		*id = (__u32)id_long;
+		if (!ret && *id_str != '+')
+			ret = -ENOENT;
 	}
 	return ret;
 }
@@ -719,9 +726,24 @@ int nfs_map_name_to_uid(const struct nfs_server *server, const char *name, size_
 	__u32 id = -1;
 	int ret = 0;
 
-	if (!nfs_map_string_to_numeric(name, namelen, &id))
-		ret = nfs_idmap_lookup_id(name, namelen, "uid", &id, idmap);
-	if (ret == 0) {
+	if (!nfs_map_string_to_numeric(name, namelen, &id)) {
+		struct nfs_client *client = server->nfs_client;
+		const char *type;
+
+		for(;;) {
+			type = "xuid";
+			if (test_bit(NFS_CS_NOXUID, &client->cl_flags))
+				type = "uid";
+
+			ret = nfs_idmap_lookup_id(name, namelen, type, &id, idmap);
+			if (ret != -EINVAL || test_bit(NFS_CS_NOXUID, &client->cl_flags))
+				break;
+			printk(KERN_NOTICE "NFS: Falling back from nfsidmap "
+			       "xuid/xgid to uid/gid\n");
+			set_bit(NFS_CS_NOXUID, &client->cl_flags);
+		}
+	}
+	if (ret == 0 || ret == -ENOENT) {
 		*uid = make_kuid(&init_user_ns, id);
 		if (!uid_valid(*uid))
 			ret = -ERANGE;
@@ -736,9 +758,24 @@ int nfs_map_group_to_gid(const struct nfs_server *server, const char *name, size
 	__u32 id = -1;
 	int ret = 0;
 
-	if (!nfs_map_string_to_numeric(name, namelen, &id))
-		ret = nfs_idmap_lookup_id(name, namelen, "gid", &id, idmap);
-	if (ret == 0) {
+	if (!nfs_map_string_to_numeric(name, namelen, &id)) {
+		struct nfs_client *client = server->nfs_client;
+		const char *type;
+
+		for(;;) {
+			type = "xgid";
+			if (test_bit(NFS_CS_NOXUID, &client->cl_flags))
+				type = "gid";
+
+			ret = nfs_idmap_lookup_id(name, namelen, type, &id, idmap);
+			if (ret != -EINVAL || test_bit(NFS_CS_NOXUID, &client->cl_flags))
+				break;
+			printk(KERN_NOTICE "NFS: Falling back from nfsidmap "
+			       "xuid/xgid to uid/gid\n");
+			set_bit(NFS_CS_NOXUID, &client->cl_flags);
+		}
+	}
+	if (ret == 0 || ret == -ENOENT) {
 		*gid = make_kgid(&init_user_ns, id);
 		if (!gid_valid(*gid))
 			ret = -ERANGE;
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index eefed15..adeb894 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3875,7 +3875,8 @@ static int decode_attr_owner(struct xdr_stream *xdr, uint32_t *bitmap,
 				ret = NFS_ATTR_FATTR_OWNER_NAME;
 			}
 		} else if (len < XDR_MAX_NETOBJ) {
-			if (nfs_map_name_to_uid(server, (char *)p, len, uid) == 0)
+			ret = nfs_map_name_to_uid(server, (char *)p, len, uid);
+			if (ret == 0 || ret == -ENOENT)
 				ret = NFS_ATTR_FATTR_OWNER;
 			else
 				dprintk("%s: nfs_map_name_to_uid failed!\n",
@@ -3918,7 +3919,8 @@ static int decode_attr_group(struct xdr_stream *xdr, uint32_t *bitmap,
 				ret = NFS_ATTR_FATTR_GROUP_NAME;
 			}
 		} else if (len < XDR_MAX_NETOBJ) {
-			if (nfs_map_group_to_gid(server, (char *)p, len, gid) == 0)
+			ret = nfs_map_group_to_gid(server, (char *)p, len, gid);
+			if (ret == 0 || ret == -ENOENT)
 				ret = NFS_ATTR_FATTR_GROUP;
 			else
 				dprintk("%s: nfs_map_group_to_gid failed!\n",
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 570a7df..c7d42b7 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -36,6 +36,7 @@ struct nfs_client {
 #define NFS_CS_RENEWD		3		/* - renewd started */
 #define NFS_CS_STOP_RENEW	4		/* no more state to renew */
 #define NFS_CS_CHECK_LEASE_TIME	5		/* need to check lease time */
+#define NFS_CS_NOXUID		6		/* don't use idmap xuid / xgid */
 	unsigned long		cl_flags;	/* behavior switches */
 #define NFS_CS_NORESVPORT	0		/* - use ephemeral src port */
 #define NFS_CS_DISCRTRY		1		/* - disconnect on RPC retry */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
