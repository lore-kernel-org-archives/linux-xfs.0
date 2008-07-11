Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 09:47:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6AGlIsW026122
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 09:47:18 -0700
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E5892D7DEB
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 09:48:23 -0700 (PDT)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.153]) by cuda.sgi.com with ESMTP id hqSLy4qTdDejaNBs for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 09:48:23 -0700 (PDT)
Received: by yx-out-1718.google.com with SMTP id 36so895715yxh.32
        for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 09:48:21 -0700 (PDT)
Date: Thu, 10 Jul 2008 17:53:40 -0700
From: Brandon Philips <brandon@ifup.org>
Subject: [PATCH] acl: Fix WALK_TREE_RECURSIVE for the WALK_TREE_DEREFERENCE
	case
Message-ID: <20080711005340.GA30185@potty.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Gruenbacher <agruen@suse.de>, tes@sgi.com
Cc: xfs@oss.sgi.com

NOTE: Sending to xfs@oss.sgi.com instead of acl-devel since it doesn't
seem active anymore.

getfacl.c calls walk_tree() with WALK_TREE_DEREFERENCE.  This causes a
stat() of symlinks which in turn causes S_ISDIR(st.st_mode) to be true
on symlinks.

This causes getfacl -P to return the contents of symlinks...

e.g.

$ mkdir -p test/sub
$ mkdir test/link
$ touch test/link/file
$ ln -s `pwd`/test/link test/sub/link
$ getfacl -P -R test/sub


# file: test/sub
# owner: philips
# group: users
user::rwx
group::r-x
other::r-x

# file: test/sub/link/file
# owner: philips
# group: users
user::rw-
group::r--
other::r--

After the fix:

$ getfacl -R -P test/sub/
# file: test/sub/
# owner: philips
# group: users
user::rwx
group::r-x
other::r-x


Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 libmisc/walk_tree.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: acl-2.2.47/libmisc/walk_tree.c
===================================================================
--- acl-2.2.47.orig/libmisc/walk_tree.c
+++ acl-2.2.47/libmisc/walk_tree.c
@@ -93,8 +93,15 @@ static int walk_tree_rec(const char *pat
 		have_dir_stat = 1;
 	}
 	err = func(path, &st, flags, arg);
+
+	/*
+	 * Recurse if WALK_TREE_RECURSIVE and the path is:
+	 * 	a dir not from a symlink
+	 * 	a link and follow_symlinks
+	 */
 	if ((flags & WALK_TREE_RECURSIVE) &&
-	    (S_ISDIR(st.st_mode) || (S_ISLNK(st.st_mode) && follow_symlinks))) {
+	    (!(flags & WALK_TREE_SYMLINK) && S_ISDIR(st.st_mode)) ||
+	    ((flags & WALK_TREE_SYMLINK) && follow_symlinks)) {
 		struct dirent *entry;
 
 		/*
