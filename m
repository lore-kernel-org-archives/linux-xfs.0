Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF6EB7F37
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 08:53:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92E0B304032
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 06:53:01 -0700 (PDT)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
	[209.85.215.45]) by cuda.sgi.com with ESMTP id 0lA8yAIMFedr9JGu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Oct 2015 06:52:56 -0700 (PDT)
Received: by lfbn126 with SMTP id n126so49855563lfb.2
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 06:52:54 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Oct 2015 15:52:54 +0200
Message-ID: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
Subject: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: xfs@oss.sgi.com

Hello,

The usual way of manipulating a file's POSIX ACL is through the
system.posix_acl_{access,default} xattrs. Setting
system.posix_acl_access also sets the permission bits in the file
mode. The acls are cached in inode->i_acl and inode->i_default_acl.

On XFS, POSIX ACLs are also exposed as trusted.SGI_ACL_{FILE,DEFAULT}
xattrs in a different value format. However, setting these xattrs does
not update inode->i_{,default_}acl, and setting trusted.SGI_ACL_FILE
does not update the file mode; things can get out of sync:

  $ touch f
  $ setfacl -m u:agruenba:rw f
  $ ls -l f
  -rw-rw-r--+ 1 root root 0 Oct 23 15:04 f
  $ getfattr -m- -d f
  # file: f
  security.selinux="unconfined_u:object_r:user_tmp_t:s0"
  system.posix_acl_access=0sAgAAAAEABgD/////AgAGAOgDAAAEAAQA/////xAABgD/////IAAEAP////8=
  trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==

  $ chmod 0 f
  $ setfattr -n trusted.SGI_ACL_FILE -v
0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
f
  $ ls -l f
  ----------+ 1 root root 0 Oct 23 15:04 /var/tmp/f
  $ getfacl f
  # file: f
  # owner: root
  # group: root
  user::---
  user:agruenba:rw-        #effective:---
  group::r--            #effective:---
  mask::---
  other::---
  $ getfattr -m- -d f
  # file: f
  security.selinux="unconfined_u:object_r:user_tmp_t:s0"
  system.posix_acl_access=0sAgAAAAEAAAD/////AgAGAOgDAAAEAAQA/////xAAAAD/////IAAAAP////8=
  trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==

Here, the file mode and the reported value of system.posix_acl_access
are both wrong; trusted.SGI_ACL_FILE corresponds to what's stored on
disk.

Access to trusted.* attributes is limited to users capable of
CAP_SYS_ADMIN so ordinary users cannot cause this kind of damage, but
this still deserves fixing.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
