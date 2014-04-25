Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 613537F3F
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 14:42:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDC77AC007
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:42:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GeNCsE0UXprlfyZv for
	<xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:42:22 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3PJgMW4015148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 15:42:22 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3PJgLv8007209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 15:42:22 -0400
Message-ID: <535ABA9D.2060305@redhat.com>
Date: Fri, 25 Apr 2014 14:42:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH, RFC] xfs: add heuristic to flush on rename
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Add a heuristic to flush data to a file which looks like it's
going through a tmpfile/rename dance, but not fsynced.

I had a report of a system with many 0-length files after
package updates; as it turns out, the user had basically
done 'yum update' and punched the power button when it was
done.

Granted, the admin should not do this.  Granted, the package
manager should ensure persistence of files it updated.

Ext4, however, added a heuristic like this for just this case;
someone who writes file.tmp, then renames over file, but
never issues an fsync.

Now, this does smack of O_PONIES, but I would hope that it's
fairly benign.  If someone already synced the tmpfile, it's
a no-op.

And it's not THAT far off our "flush on close if the file was
truncated" heuristic.

Comments?  Flames?  Testing anyone would like to see?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ef1ca01..5c95ef5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -371,6 +371,19 @@ xfs_vn_rename(
 	xfs_dentry_to_name(&oname, odentry, 0);
 	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
 
+	/*
+	 * If we are renaming a just-written file over an existing
+	 * file, be pedantic and flush it out if it looks like somebody
+	 * is doing a tmpfile dance, and didn't fsync.  Best effort;
+	 * ignore errors.
+	 */
+	if (new_inode) {
+		xfs_inode_t *ip = XFS_I(odentry->d_inode);
+
+		if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
+			filemap_flush(new_inode->i_mapping);
+	}
+
 	return -xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			   XFS_I(ndir), &nname, new_inode ?
 						XFS_I(new_inode) : NULL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
