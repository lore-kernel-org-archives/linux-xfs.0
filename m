Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NArRll259290 for <xfs@oss.sgi.com>; Mon, 23 May 2011 05:53:28 -0500
Received: from chipmunk.wormnet.eu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4690C1621A6E
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 03:53:25 -0700 (PDT)
Received: from chipmunk.wormnet.eu (chipmunk.wormnet.eu [195.195.131.226]) by
	cuda.sgi.com with ESMTP id ZGBqJFTSlToRvQei for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 03:53:25 -0700 (PDT)
Resent-Message-ID: <20110523105324.GY28383@chipmunk>
Resent-To: xfs@oss.sgi.com
Date: Sat, 7 May 2011 00:04:38 +0100
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: SIGSEGV with 'cp -a'
Message-ID: <20110506230438.GV25017@chipmunk>
References: <20110506220035.GU25017@chipmunk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <20110506220035.GU25017@chipmunk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bfields@citi.umich.edu
Cc: linux-xfs@oss.sgi.com


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I *think* it all boils down to XFS[1] being bad and it should be 
returning ENOATTR rather than EINVAL for unknown xattr names; according 
to the getxattr() manpage.

The previous patch just plasters over the problem (as we should never be 
getting to acl_ptn4_acl_trans() on an XFS filesystem).  The result is 
that you see the ACL's on a NFSv4 mount, but local filesystems they are 
invisible.

The attached patch fixes things (hopefully) properly.

Cheers

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=fs/xfs/xfs_attr.c#l87

* Alexander Clouter <alex@digriz.org.uk> [2011-05-06 23:00:35+0100]:
>
> Unsure if you are interested, as it really looks like your nfs4 libacl 
> patches[1] are no longer being maintained, but after moving my Debian 
> installation from lenny to squeeze I got segfaults when copying files:
> ----
> Program received signal SIGSEGV, Segmentation fault.
> acl_ptn4_acl_trans (pacl=0x8062f8c, acl=0x0, type=32768, is_dir=1,
>     nfs_domain=0xbffff108 "elar.soas.ac.uk") at acl_ptn4_acl_trans.c:109
> 109             purge_aces(acl, type);
> (gdb) where
> #0  acl_ptn4_acl_trans (pacl=0x8062f8c, acl=0x0, type=32768, is_dir=1,
>     nfs_domain=0xbffff108 "elar.soas.ac.uk") at acl_ptn4_acl_trans.c:109
> #1  0xb7fac969 in acl_set_file (path_p=0x8062d20 "moo/private", 
> type=32768, acl=0x8062f8c)
>     at acl_set_file.c:114
> [snipped]
> ----
> 
> Seems to come about as getxattr("system.nfs4_acl") on an XFS filesystem 
> pops back with (iirc) EINVAL which trickles into libacl as NULL in acl 
> when being passed to purge_aces().
> 
> Obvious fix is to drop in a quick check for NULL, as done in the 
> attached patch.  Would be great if you could could commit this to your 
> dusty git tree, spit out a new patch and tell us all to "get with the 
> program and use richacls" ;)
> 
> Having 'native' ACLs with NFSv4 has helped me no end, so my thanks to 
> you (and any other contributors).
> 
> Cheers
> 
> [1] http://www.citi.umich.edu/projects/nfsv4/linux/
> [2] I'm using the Debian acl/libacl 2.2.49-4 package with 
> 	acl-2.2.42-CITI_NFS4_ALL-2.diff applied

-- 
Alexander Clouter
.sigmonster says: problem drinker, n.:
                  	A man who never buys.

--ieNMXl1Fr3cevapt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nfs4-acl-oops-fix.patch"

diff -u -r acl-2.2.49.orig/debian/changelog acl-2.2.49/debian/changelog
--- acl-2.2.49.orig/debian/changelog	2010-09-21 06:02:04.000000000 +0100
+++ acl-2.2.49/debian/changelog	2011-05-06 23:39:24.817562608 +0100
@@ -1,3 +1,21 @@
+acl (2.2.49-4.nfsv4-3) unstable; urgency=low
+
+  * Handle that XFS comes back with EINVAL for xattr ops
+
+ -- Alexander Clouter <alex@digriz.org.uk>  Fri,  6 May 2011 23:36:00 +0100
+
+acl (2.2.49-4.nfsv4-2) unstable; urgency=low
+
+  * Fix a nfsv4->posix mapping problem that gave groups spurious bits
+
+ -- J. Bruce Fields <bfields@ying8.citi.umich.edu>  Mon,  5 Nov 2007 18:49:20 -0500
+
+acl (2.2.49-4.nfsv4-1) unstable; urgency=low
+
+  * Add support for NFSv4 ACLs
+
+ -- J. Bruce Fields <bfields@fieldses.org>  Fri, 02 Sep 2006 00:22:07 -0400
+
 acl (2.2.49-4) unstable; urgency=low
 
   * Migrate to having binaries in sbindir (closes: #590240)
diff -u -r acl-2.2.49.orig/libacl/acl_extended_file.c acl-2.2.49/libacl/acl_extended_file.c
--- acl-2.2.49.orig/libacl/acl_extended_file.c	2011-05-07 00:02:33.093234423 +0100
+++ acl-2.2.49/libacl/acl_extended_file.c	2011-05-06 23:42:05.213231868 +0100
@@ -40,7 +40,7 @@
 	 * NFS4 stuff that's going on.  We need a cleaner separation. */
 #ifdef USE_NFSV4_TRANS
 	retval = getxattr(path_p, ACL_NFS4_XATTR, NULL, 0);
-	if (retval < 0 && errno != ENOATTR && errno != EOPNOTSUPP)
+	if (retval < 0 && errno != ENOATTR && errno != EOPNOTSUPP && errno != EINVAL)
 		return -1;
 	if (retval >= 0) {
 		struct nfs4_acl *nfsacl;
diff -u -r acl-2.2.49.orig/libacl/acl_get_fd.c acl-2.2.49/libacl/acl_get_fd.c
--- acl-2.2.49.orig/libacl/acl_get_fd.c	2011-05-07 00:02:33.093234423 +0100
+++ acl-2.2.49/libacl/acl_get_fd.c	2011-05-06 23:40:45.269231919 +0100
@@ -51,7 +51,7 @@
 
 #ifdef USE_NFSV4_TRANS
 	retval = fgetxattr(fd, ACL_NFS4_XATTR, ext_acl_p, size_guess);
-	if(retval == -1 && (errno == ENOATTR || errno == EOPNOTSUPP)) {
+	if(retval == -1 && (errno == ENOATTR || errno == EOPNOTSUPP || errno == EINVAL)) {
 		nfsv4acls = ACL_NFS4_NOT_USED;
 		retval = fgetxattr(fd, name, ext_acl_p, size_guess);
 	} else {
diff -u -r acl-2.2.49.orig/libacl/acl_get_file.c acl-2.2.49/libacl/acl_get_file.c
--- acl-2.2.49.orig/libacl/acl_get_file.c	2011-05-07 00:02:33.093234423 +0100
+++ acl-2.2.49/libacl/acl_get_file.c	2011-05-06 23:41:19.225231870 +0100
@@ -63,7 +63,7 @@
 		return NULL;
 #ifdef USE_NFSV4_TRANS
 	retval = getxattr(path_p, ACL_NFS4_XATTR, ext_acl_p, size_guess);
-	if((retval == -1) && (errno == ENOATTR || errno == EOPNOTSUPP)) {
+	if((retval == -1) && (errno == ENOATTR || errno == EOPNOTSUPP || errno == EINVAL)) {
 		nfsv4acls = ACL_NFS4_NOT_USED;
 		retval = getxattr(path_p, name, ext_acl_p, size_guess);
 	} else {
diff -u -r acl-2.2.49.orig/libacl/acl_set_fd.c acl-2.2.49/libacl/acl_set_fd.c
--- acl-2.2.49.orig/libacl/acl_set_fd.c	2011-05-07 00:02:33.097233581 +0100
+++ acl-2.2.49/libacl/acl_set_fd.c	2011-05-06 23:41:32.273232819 +0100
@@ -53,7 +53,7 @@
 #ifdef USE_NFSV4_TRANS
 	retval = fgetxattr(fd, ACL_NFS4_XATTR, NULL, 0);
 
-	if(retval == -1 && (errno == ENOATTR || errno == EOPNOTSUPP)) {
+	if(retval == -1 && (errno == ENOATTR || errno == EOPNOTSUPP || errno == EINVAL)) {
 		ext_acl_p = __acl_to_xattr(acl_obj_p, &size);
 	} else {
 		char domain[NFS4_MAX_DOMAIN_LEN];
diff -u -r acl-2.2.49.orig/libacl/acl_set_file.c acl-2.2.49/libacl/acl_set_file.c
--- acl-2.2.49.orig/libacl/acl_set_file.c	2011-05-07 00:02:33.101232756 +0100
+++ acl-2.2.49/libacl/acl_set_file.c	2011-05-06 23:41:50.745232926 +0100
@@ -100,7 +100,7 @@
 		return -1;
 	}
 	nacl = get_nfs4_acl(path_p, is_dir);
-	if (nacl == NULL && (errno == ENOATTR || errno == EOPNOTSUPP))
+	if (nacl == NULL && (errno == ENOATTR || errno == EOPNOTSUPP || errno == EINVAL))
 		ext_acl_p = __acl_to_xattr(acl_obj_p, &size);
 	else {
 		char domain[NFS4_MAX_DOMAIN_LEN];

--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--ieNMXl1Fr3cevapt--
