Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08294Ks024436 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:09:04 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56D3217B961E
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:09:02 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.180]) by cuda.sgi.com with ESMTP id
	QMetl03KuG2sxPYH for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:09:02 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id j5so4886607wah.4
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:09:02 -0800 (PST)
Message-Id: <20090108015418.899764003@ifup.org>
Date: Wed, 07 Jan 2009 17:53:58 -0800
From: brandon@ifup.org
Subject: [patch 3/5] [PATCH] acl: move root tests to their own folder
References: <20090108015355.613058570@ifup.org>
Content-Disposition: inline;
	filename=acl-move-root-tests-to-their-own-folder.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: tes@sgi.com
Cc: Brandon Philips <bphilips@suse.de>, xfs@oss.sgi.com

Since these tests require root perms to run move them into a seperate
folder so they don't run by default.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 test/permissions.test      |  279 ---------------------------------------------
 test/root/permissions.test |  279 +++++++++++++++++++++++++++++++++++++++++++++
 test/root/setfacl.test     |  144 +++++++++++++++++++++++
 test/setfacl.test          |  144 -----------------------
 4 files changed, 423 insertions(+), 423 deletions(-)

Index: acl-2.2.47/test/permissions.test
===================================================================
--- acl-2.2.47.orig/test/permissions.test
+++ /dev/null
@@ -1,279 +0,0 @@
-This script tests if file permissions are properly checked with and
-without ACLs. The script must be run as root to allow switching users.
-The following users are required. They must be a member in the groups
-listed in parentheses.
-
-	bin (bin)
-	daemon (bin, daemon)
-
-
-Cry immediately if we are not running as root.
-
-	$ id -u
-	> 0
-
-
-First, set up a temporary directory and create a regular file with
-defined permissions.
-
-	$ mkdir d
-	$ cd d
-	$ umask 027
-	$ touch f
-	$ ls -l f | awk -- '{ print $1, $3, $4 }'
-	> -rw-r----- root root
-
-
-Make sure root has access to the file.  Verify that user daemon does not
-have access to the file owned by root.
-
-	$ echo root > f
-
-	$ su daemon
-	$ echo daemon >> f
-	> f: Permission denied
-
-	$ su
-
-
-Now, change the ownership of the file to bin:bin and verify that this
-gives user bin write access.
-
-	$ chown bin:bin f
-	$ ls -l f | awk -- '{ print $1, $3, $4 }'
-	> -rw-r----- bin bin
-	$ su bin
-	$ echo bin >> f
-
-
-User daemon is a member in the owning group, which has only read access.
-Verify this.
-
-	$ su daemon
-	$ cat f
-	> root
-	> bin
-
-	$ echo daemon >> f
-	> f: Permission denied
-
-
-Now, add an ACL entry for user daemon that grants him rw- access. File
-owners and users capable of CAP_FOWNER are allowed to change ACLs.
-
-	$ su bin
-	$ setfacl -m u:daemon:rw f
-	$ getfacl --omit-header f
-	> user::rw-
-	> user:daemon:rw-
-	> group::r--
-	> mask::rw-
-	> other::---
-	>
-
-
-Verify that the additional ACL entry grants user daemon write access.
-
-	$ su daemon
-	$ echo daemon >> f
-	$ cat f
-	> root
-	> bin
-	> daemon
-
-
-Remove write access from the group class permission bits, and
-verify that this masks daemon's write permission.
-
-	$ su bin
-	$ chmod g-w f
-	$ getfacl --omit-header f
-	> user::rw-
-	> user:daemon:rw-	#effective:r--
-	> group::r--
-	> mask::r--
-	> other::---
-	>
-
-	$ su daemon
-	$ echo daemon >> f
-	> f: Permission denied
-
-
-Add an entry for group daemon with rw- access, and change the
-permissions for user daemon to r--. Also change the others permissions t
-rw-. The user entry should take precedence, so daemon should be denied
-access.
-
-	$ su bin
-	$ setfacl -m u:daemon:r,g:daemon:rw-,o::rw- f
-
-	$ su daemon
-	$ echo daemon >> f
-	> f: Permission denied
-
-
-Remove the entry for user daemon. The group daemon permissions should
-now give user daemon rw- access.
-
-	$ su bin
-	$ setfacl -x u:daemon f
-
-	$ su daemon
-	$ echo daemon2 >> f
-	$ cat f
-	> root
-	> bin
-	> daemon
-	> daemon2
-
-
-Set the group daemon permissions to r-- and verify that after than, user
-daemon does not have write access anymore.
-
-	$ su bin
-	$ setfacl -m g:daemon:r f
-
-	$ su daemon
-	$ echo daemon3 >> f
-	> f: Permission denied
-
-
-Now, remove the group daemon entry. Because user daemon is a member in
-the owning group, he should still have no write access.
-
-	$ su bin
-	$ setfacl -x g:daemon f
-
-	$ su daemon
-	$ echo daemon4 >> f
-	> f: Permission denied
-
-
-Change the owning group. The other permissions should now grant user
-daemon write access.
-
-	$ su
-	$ chgrp root f
-
-	$ su daemon
-	$ echo daemon5 >> f
-	$ cat f
-	> root
-	> bin
-	> daemon
-	> daemon2
-	> daemon5
-
-
-Verify that permissions in separate matching ACL entries do not
-accumulate.
-
-	$ su
-	$ setfacl -m g:bin:r,g:daemon:w f
-
-	$ su daemon
-	$ : < f	 # open for reading
-	$ : > f  # open for writing
-	$ : <> f  # open for read-write
-	> f: Permission denied
-
-
-Test if directories can have ACLs.  We assume that only one access check
-algorithm is used for all file types the file system, so these tests
-only need to verify that ACL permissions make a difference.
-
-	$ su
-	$ mkdir -m 750 e
-	$ touch e/h
-
-	$ su bin
-	$ shopt -s nullglob ; echo e/*
-	>
-
-	$ echo i > e/i
-	> e/i: Permission denied
-
-	$ su
-	$ setfacl -m u:bin:rx e
-
-	$ su bin
-	$ echo e/*
-	> e/h
-	$ echo i > e/i
-	> e/i: Permission denied
-
-	$ su
-	$ setfacl -m u:bin:rwx e
-
-	$ su bin
-	$ echo i > e/i
-
-
-Test if symlinks are properly followed.
-
-	$ su
-	$ touch g
-	$ ln -s g l
-	$ setfacl -m u:bin:rw l
-	$ ls -l g | awk -- '{ print $1, $3, $4 }'
-	> -rw-rw----+ root root
-
-
-Test if ACLs are effective for block and character special files, fifos,
-sockets. This is done by creating special files locally. The devices do
-not need to exist: The access check is earlier in the code path than the
-test if the device exists.
-
-
-	$ mknod -m 0660 hdt b 91 64	# /dev/hdt
-	$ mknod -m 0660 null c 1 3	# /dev/null
-	$ mkfifo -m 0660 fifo
-
-	$ su bin
-	$ : < hdt
-	> hdt: Permission denied
-	$ : < null
-	> null: Permission denied
-	$ : < fifo
-	> fifo: Permission denied
-
-	$ su
-	$ setfacl -m u:bin:rw hdt null fifo
-
-	$ su bin
-	$ : < hdt
-	> hdt: No such device or address
-	$ : < null
-	$ ( echo blah > fifo & ) ; cat fifo
-	> blah
-
-
-Test if CAP_FOWNER is properly honored for directories. This addresses a
-specific bug in XFS 1.2, which does not grant root access to files in
-directories if the file has an ACL and only CAP_FOWNER would grant them.
-
-	$ su
-	$ mkdir -m 600 x
-	$ chown daemon:daemon x
-	$ echo j > x/j
-	$ ls -l x/j | awk -- '{ print $1, $3, $4 }'
-	> -rw-r----- root root
-
-	$ setfacl -m u:daemon:r x
-
-	$ ls -l x/j | awk -- '{ print $1, $3, $4 }'
-	> -rw-r----- root root
-	(With the bug this gives: `ls: x/j: Permission denied'.)
-
-	$ echo k > x/k
-	(With the bug this gives: `x/k: Permission denied'.)
-
-	$ chmod 750 x
-
-
-Clean up.
-
-	$ su
-	$ cd ..
-	$ rm -rf d
Index: acl-2.2.47/test/setfacl.test
===================================================================
--- acl-2.2.47.orig/test/setfacl.test
+++ /dev/null
@@ -1,144 +0,0 @@
-Setfacl utility tests. Run these tests on a filesystem with ACL support.
- 
- 	$ mkdir d
-	$ chown bin:bin d
-	$ cd d
-
-	$ su bin
-	$ sg bin
-	$ umask 027
-	$ touch g
-	$ ls -dl g | awk '{print $1}'
-	> -rw-r-----
-	
-	$ setfacl -m m:- g
-	$ ls -dl g | awk '{print $1}'
-	> -rw-------+
-	
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rw-
-	> group::r--	#effective:---
-	> mask::---
-	> other::---
-	> 
-	
-	$ setfacl -x m g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rw-
-	> group::r--
-	> other::---
-	> 
-	
-	$ setfacl -m u:daemon:rw g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rw-
-	> user:daemon:rw-
-	> group::r--
-	> mask::rw-
-	> other::---
-	> 
-	
-	$ setfacl -m u::rwx,g::r-x,o:- g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rwx
-	> user:daemon:rw-
-	> group::r-x
-	> mask::rwx
-	> other::---
-	> 
-	
-	$ setfacl -m u::rwx,g::r-x,o:-,m:- g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rwx
-	> user:daemon:rw-	#effective:---
-	> group::r-x	#effective:---
-	> mask::---
-	> other::---
-	> 
-	
-	$ setfacl -m u::rwx,g::r-x,o:-,u:root:-,m:- g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rwx
-	> user:root:---
-	> user:daemon:rw-	#effective:---
-	> group::r-x	#effective:---
-	> mask::---
-	> other::---
-	> 
-	
-	$ setfacl -m u::rwx,g::r-x,o:-,u:root:-,m:- g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rwx
-	> user:root:---
-	> user:daemon:rw-	#effective:---
-	> group::r-x	#effective:---
-	> mask::---
-	> other::---
-	> 
-	
-	$ setfacl -m u::rwx,g::r-x,o:-,u:root:- g
-	$ getfacl g
-	> # file: g
-	> # owner: bin
-	> # group: bin
-	> user::rwx
-	> user:root:---
-	> user:daemon:rw-
-	> group::r-x
-	> mask::rwx
-	> other::---
-	> 
-	
-	$ setfacl --test -x u: g
-	> setfacl: g: Malformed access ACL `user:root:---,user:daemon:rw-,group::r-x,mask::rwx,other::---': Missing or wrong entry at entry 1
-	
-	$ setfacl --test -x u:x
-	> setfacl: Option -x: Invalid argument near character 3
-	
-	$ setfacl -m d:u:root:rwx g
-	> setfacl: g: Only directories can have default ACLs
-	
-	$ setfacl -x m g
-	> setfacl: g: Malformed access ACL `user::rwx,user:root:---,user:daemon:rw-,group::r-x,other::---': Missing or wrong entry at entry 5
-	 setfacl --test -m d:u:daemon:rwx setfacl
-	 setfacl --test -n -m d:u:daemon:rwx setfacl
-	
-Check if the mask is properly recalculated
- 
-	$ mkdir d
-	$ setfacl --test -m u::rwx,u:bin:rwx,g::r-x,o::--- d
-	> d: u::rwx,u:bin:rwx,g::r-x,m::rwx,o::---,*
-	
-	$ setfacl --test -m u::rwx,u:bin:rwx,g::r-x,m::---,o::--- d
-	> d: u::rwx,u:bin:rwx,g::r-x,m::---,o::---,*
-	
-	$ setfacl --test -d -m u::rwx,u:bin:rwx,g::r-x,o::--- d
-	> d: *,d:u::rwx,d:u:bin:rwx,d:g::r-x,d:m::rwx,d:o::---
-	
-	$ setfacl --test -d -m u::rwx,u:bin:rwx,g::r-x,m::---,o::--- d
-	> d: *,d:u::rwx,d:u:bin:rwx,d:g::r-x,d:m::---,d:o::---
-	
-	$ su
-	$ cd ..
-	$ rm -r d
Index: acl-2.2.47/test/root/permissions.test
===================================================================
--- /dev/null
+++ acl-2.2.47/test/root/permissions.test
@@ -0,0 +1,279 @@
+This script tests if file permissions are properly checked with and
+without ACLs. The script must be run as root to allow switching users.
+The following users are required. They must be a member in the groups
+listed in parentheses.
+
+	bin (bin)
+	daemon (bin, daemon)
+
+
+Cry immediately if we are not running as root.
+
+	$ id -u
+	> 0
+
+
+First, set up a temporary directory and create a regular file with
+defined permissions.
+
+	$ mkdir d
+	$ cd d
+	$ umask 027
+	$ touch f
+	$ ls -l f | awk -- '{ print $1, $3, $4 }'
+	> -rw-r----- root root
+
+
+Make sure root has access to the file.  Verify that user daemon does not
+have access to the file owned by root.
+
+	$ echo root > f
+
+	$ su daemon
+	$ echo daemon >> f
+	| f: Permission denied$
+
+	$ su
+
+
+Now, change the ownership of the file to bin:bin and verify that this
+gives user bin write access.
+
+	$ chown bin:bin f
+	$ ls -l f | awk -- '{ print $1, $3, $4 }'
+	> -rw-r----- bin bin
+	$ su bin
+	$ echo bin >> f
+
+
+User daemon is a member in the owning group, which has only read access.
+Verify this.
+
+	$ su daemon
+	$ cat f
+	> root
+	> bin
+
+	$ echo daemon >> f
+	| f: Permission denied$
+
+
+Now, add an ACL entry for user daemon that grants him rw- access. File
+owners and users capable of CAP_FOWNER are allowed to change ACLs.
+
+	$ su bin
+	$ setfacl -m u:daemon:rw f
+	$ getfacl --omit-header f
+	> user::rw-
+	> user:daemon:rw-
+	> group::r--
+	> mask::rw-
+	> other::---
+	>
+
+
+Verify that the additional ACL entry grants user daemon write access.
+
+	$ su daemon
+	$ echo daemon >> f
+	$ cat f
+	> root
+	> bin
+	> daemon
+
+
+Remove write access from the group class permission bits, and
+verify that this masks daemon's write permission.
+
+	$ su bin
+	$ chmod g-w f
+	$ getfacl --omit-header f
+	> user::rw-
+	> user:daemon:rw-	#effective:r--
+	> group::r--
+	> mask::r--
+	> other::---
+	>
+
+	$ su daemon
+	$ echo daemon >> f
+	| f: Permission denied$
+
+
+Add an entry for group daemon with rw- access, and change the
+permissions for user daemon to r--. Also change the others permissions t
+rw-. The user entry should take precedence, so daemon should be denied
+access.
+
+	$ su bin
+	$ setfacl -m u:daemon:r,g:daemon:rw-,o::rw- f
+
+	$ su daemon
+	$ echo daemon >> f
+	| f: Permission denied$
+
+
+Remove the entry for user daemon. The group daemon permissions should
+now give user daemon rw- access.
+
+	$ su bin
+	$ setfacl -x u:daemon f
+
+	$ su daemon
+	$ echo daemon2 >> f
+	$ cat f
+	> root
+	> bin
+	> daemon
+	> daemon2
+
+
+Set the group daemon permissions to r-- and verify that after than, user
+daemon does not have write access anymore.
+
+	$ su bin
+	$ setfacl -m g:daemon:r f
+
+	$ su daemon
+	$ echo daemon3 >> f
+	| f: Permission denied$
+
+
+Now, remove the group daemon entry. Because user daemon is a member in
+the owning group, he should still have no write access.
+
+	$ su bin
+	$ setfacl -x g:daemon f
+
+	$ su daemon
+	$ echo daemon4 >> f
+	| f: Permission denied$
+
+
+Change the owning group. The other permissions should now grant user
+daemon write access.
+
+	$ su
+	$ chgrp root f
+
+	$ su daemon
+	$ echo daemon5 >> f
+	$ cat f
+	> root
+	> bin
+	> daemon
+	> daemon2
+	> daemon5
+
+
+Verify that permissions in separate matching ACL entries do not
+accumulate.
+
+	$ su
+	$ setfacl -m g:bin:r,g:daemon:w f
+
+	$ su daemon
+	$ : < f	 # open for reading
+	$ : > f  # open for writing
+	$ : <> f  # open for read-write
+	| f: Permission denied$
+
+
+Test if directories can have ACLs.  We assume that only one access check
+algorithm is used for all file types the file system, so these tests
+only need to verify that ACL permissions make a difference.
+
+	$ su
+	$ mkdir -m 750 e
+	$ touch e/h
+
+	$ su bin
+	$ shopt -s nullglob ; echo e/*
+	>
+
+	$ echo i > e/i
+	| e/i: Permission denied$
+
+	$ su
+	$ setfacl -m u:bin:rx e
+
+	$ su bin
+	$ echo e/*
+	> e/h
+	$ echo i > e/i
+	| e/i: Permission denied$
+
+	$ su
+	$ setfacl -m u:bin:rwx e
+
+	$ su bin
+	$ echo i > e/i
+
+
+Test if symlinks are properly followed.
+
+	$ su
+	$ touch g
+	$ ln -s g l
+	$ setfacl -m u:bin:rw l
+	$ ls -l g | awk -- '{ print $1, $3, $4 }'
+	> -rw-rw----+ root root
+
+
+Test if ACLs are effective for block and character special files, fifos,
+sockets. This is done by creating special files locally. The devices do
+not need to exist: The access check is earlier in the code path than the
+test if the device exists.
+
+
+	$ mknod -m 0660 hdt b 91 64	# /dev/hdt
+	$ mknod -m 0660 null c 1 3	# /dev/null
+	$ mkfifo -m 0660 fifo
+
+	$ su bin
+	$ : < hdt
+	| hdt: Permission denied$
+	$ : < null
+	| null: Permission denied$
+	$ : < fifo
+	| fifo: Permission denied$
+
+	$ su
+	$ setfacl -m u:bin:rw hdt null fifo
+
+	$ su bin
+	$ : < hdt
+	| hdt: No such device or address$
+	$ : < null
+	$ ( echo blah > fifo & ) ; cat fifo
+	> blah
+
+
+Test if CAP_FOWNER is properly honored for directories. This addresses a
+specific bug in XFS 1.2, which does not grant root access to files in
+directories if the file has an ACL and only CAP_FOWNER would grant them.
+
+	$ su
+	$ mkdir -m 600 x
+	$ chown daemon:daemon x
+	$ echo j > x/j
+	$ ls -l x/j | awk -- '{ print $1, $3, $4 }'
+	> -rw-r----- root root
+
+	$ setfacl -m u:daemon:r x
+
+	$ ls -l x/j | awk -- '{ print $1, $3, $4 }'
+	> -rw-r----- root root
+	(With the bug this gives: `ls: x/j: Permission denied'.)
+
+	$ echo k > x/k
+	(With the bug this gives: `x/k: Permission denied'.)
+
+	$ chmod 750 x
+
+
+Clean up.
+
+	$ su
+	$ cd ..
+	$ rm -rf d
Index: acl-2.2.47/test/root/setfacl.test
===================================================================
--- /dev/null
+++ acl-2.2.47/test/root/setfacl.test
@@ -0,0 +1,144 @@
+Setfacl utility tests. Run these tests on a filesystem with ACL support.
+
+ 	$ mkdir d
+	$ chown bin:bin d
+	$ cd d
+
+	$ su bin
+	$ sg bin
+	$ umask 027
+	$ touch g
+	$ ls -dl g | awk '{print $1}'
+	> -rw-r-----
+
+	$ setfacl -m m:- g
+	$ ls -dl g | awk '{print $1}'
+	> -rw-------+
+
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rw-
+	> group::r--	#effective:---
+	> mask::---
+	> other::---
+	>
+
+	$ setfacl -x m g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rw-
+	> group::r--
+	> other::---
+	>
+
+	$ setfacl -m u:daemon:rw g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rw-
+	> user:daemon:rw-
+	> group::r--
+	> mask::rw-
+	> other::---
+	>
+
+	$ setfacl -m u::rwx,g::r-x,o:- g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rwx
+	> user:daemon:rw-
+	> group::r-x
+	> mask::rwx
+	> other::---
+	>
+
+	$ setfacl -m u::rwx,g::r-x,o:-,m:- g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rwx
+	> user:daemon:rw-	#effective:---
+	> group::r-x	#effective:---
+	> mask::---
+	> other::---
+	>
+
+	$ setfacl -m u::rwx,g::r-x,o:-,u:root:-,m:- g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rwx
+	> user:root:---
+	> user:daemon:rw-	#effective:---
+	> group::r-x	#effective:---
+	> mask::---
+	> other::---
+	>
+
+	$ setfacl -m u::rwx,g::r-x,o:-,u:root:-,m:- g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rwx
+	> user:root:---
+	> user:daemon:rw-	#effective:---
+	> group::r-x	#effective:---
+	> mask::---
+	> other::---
+	>
+
+	$ setfacl -m u::rwx,g::r-x,o:-,u:root:- g
+	$ getfacl g
+	> # file: g
+	> # owner: bin
+	> # group: bin
+	> user::rwx
+	> user:root:---
+	> user:daemon:rw-
+	> group::r-x
+	> mask::rwx
+	> other::---
+	>
+
+	$ setfacl --test -x u: g
+	> setfacl: g: Malformed access ACL `user:root:---,user:daemon:rw-,group::r-x,mask::rwx,other::---': Missing or wrong entry at entry 1
+
+	$ setfacl --test -x u:x
+	> setfacl: Option -x: Invalid argument near character 3
+
+	$ setfacl -m d:u:root:rwx g
+	> setfacl: g: Only directories can have default ACLs
+
+	$ setfacl -x m g
+	> setfacl: g: Malformed access ACL `user::rwx,user:root:---,user:daemon:rw-,group::r-x,other::---': Missing or wrong entry at entry 5
+	 setfacl --test -m d:u:daemon:rwx setfacl
+	 setfacl --test -n -m d:u:daemon:rwx setfacl
+
+Check if the mask is properly recalculated
+
+	$ mkdir d
+	$ setfacl --test -m u::rwx,u:bin:rwx,g::r-x,o::--- d
+	> d: u::rwx,u:bin:rwx,g::r-x,m::rwx,o::---,*
+
+	$ setfacl --test -m u::rwx,u:bin:rwx,g::r-x,m::---,o::--- d
+	> d: u::rwx,u:bin:rwx,g::r-x,m::---,o::---,*
+
+	$ setfacl --test -d -m u::rwx,u:bin:rwx,g::r-x,o::--- d
+	> d: *,d:u::rwx,d:u:bin:rwx,d:g::r-x,d:m::rwx,d:o::---
+
+	$ setfacl --test -d -m u::rwx,u:bin:rwx,g::r-x,m::---,o::--- d
+	> d: *,d:u::rwx,d:u:bin:rwx,d:g::r-x,d:m::---,d:o::---
+
+	$ su
+	$ cd ..
+	$ rm -r d

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
