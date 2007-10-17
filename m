Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 14:33:24 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HLXGr8018201
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 14:33:18 -0700
Message-ID: <48509.192.168.3.1.1192656820.squirrel@mail.aconex.com>
Date: Thu, 18 Oct 2007 07:33:40 +1000 (EST)
Subject: [Fwd: Bug#446877: attr(1) implies it only works with XFS]
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20071018073340_27115"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: bnaujok@sgi.com
Cc: xfs@oss.sgi.com, agruen@suse.de, rrt@sc3d.org

------=_20071018073340_27115
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi Barry,

Could you merge this docs patch into the oss.sgi.com cvs tree please?

thanks mate.

---------------------------- Original Message ----------------------------
Subject: Bug#446877: attr(1) implies it only works with XFS
From:    "Reuben Thomas" <rrt@sc3d.org>
Date:    Wed, October 17, 2007 10:47 pm
To:      "Nathan Scott" <nscott@aconex.com>
Cc:      446877@bugs.debian.org
--------------------------------------------------------------------------

On Wed, 17 Oct 2007, Nathan Scott wrote:

> All sounds good to me - please send a patch with those changes.

Attached.

To confirm what I've done:

0. I've replaced ".P" by ".PP", in the pages I've edited as according to
groff_man(7), they are aliases for the same command, and I wasted a few
minutes checking what was going on when I found them both. In attr.5, .PP
was already used exclusively, whereas in attr.1 both were.

1. In attr.1, I just moved the text that was already there mentioning
getfattr and setfattr further up the page (and then changed a couple of
words at the start of the next paragraph to avoid ambiguity).

2. In attr.5, I removed the links to filesystem patches, mentioned ext4, JFS
and reiserfs, and, lower down, added details of their attribute support. I
removed implementation details, so that I could for example refer to XFS and
reiserfs in the same paragraph, removed the hope that ext2/3/4's limits
would one day be raised (since the relevant code is still the same in ext4
as it was in ext2!), but also removed the erroneous implication that all
extended attributes must fit on a single disk block in those FSes (in fact,
*each* must fit on a single disk block, so in practice, for small tags of
the sort given in the examples, any of the file systems is fine).

-- 
http://rrt.sc3d.org/ | golf, n.  a good walk spoiled (Twain)
------=_20071018073340_27115
Content-Type: text/x-diff; name="attr-man.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="attr-man.patch"

diff -Nur attr-2.4.39/man/man1/attr.1 attr-2.4.39-rrt/man/man1/attr.1
--- attr-2.4.39/man/man1/attr.1	2007-09-11 03:00:50.000000000 +0100
+++ attr-2.4.39-rrt/man/man1/attr.1	2007-10-17 13:26:49.000000000 +0100
@@ -16,12 +16,6 @@
 .SH OVERVIEW
 Extended attributes implement the ability for a user to attach
 name:value pairs to objects within the XFS filesystem.
-.P
-They could be used to store meta-information about the file.
-For example "character-set=kanji" could tell a document browser to
-use the Kanji character set when displaying that document
-and "thumbnail=..." could provide a reduced resolution overview of a
-high resolution graphic image.
 .PP
 This document describes the
 .I attr
@@ -32,7 +26,13 @@
 and 
 .IR setfattr (1)
 documentation.
-.P
+.PP
+Extended attributes can be used to store meta-information about the file.
+For example "character-set=kanji" could tell a document browser to
+use the Kanji character set when displaying that document
+and "thumbnail=..." could provide a reduced resolution overview of a
+high resolution graphic image.
+.PP
 In the XFS filesystem, the
 .I names
 can be up to 256 bytes in length, terminated by the first 0 byte.
@@ -41,10 +41,10 @@
 The
 .I values
 can be up to 64KB of arbitrary binary data.
-.P
+.PP
 Attributes can be attached to all types of XFS inodes:
 regular files, directories, symbolic links, device nodes, etc.
-.P
+.PP
 XFS uses 2 disjoint attribute name spaces associated with every
 filesystem object.
 They are the
diff -Nur attr-2.4.39/man/man5/attr.5 attr-2.4.39-rrt/man/man5/attr.5
--- attr-2.4.39/man/man5/attr.5	2007-09-11 03:00:50.000000000 +0100
+++ attr-2.4.39-rrt/man/man5/attr.5	2007-10-17 13:35:41.000000000 +0100
@@ -32,12 +32,8 @@
 Space consumed for extended attributes is counted towards the disk quotas
 of the file owner and file group.
 .PP
-Currently, support for extended attributes is implemented on Linux by
-the ext2, ext3 and XFS filesystem patches, which can be downloaded from
-.B http://acl.bestbits.at/
-and
-.B http://oss.sgi.com/projects/xfs/
-respectively.
+Currently, support for extended attributes is implemented on Linux by the
+ext2, ext3, ext4, XFS, JFS and reiserfs filesystems.
 .SH EXTENDED ATTRIBUTE NAMESPACES
 Attribute names are zero-terminated strings.
 The attribute name is always specified in the fully qualified
@@ -106,16 +102,23 @@
 .SH FILESYSTEM DIFFERENCES
 The kernel and the filesystem may place limits on the maximum number
 and size of extended attributes that can be associated with a file.
+Some file systems, such as ext2/3 and reiserfs, require the filesystem
+to be mounted with the
+.B user_xattr
+mount option in order for extended user attributes to be used.
+.PP
+In the current ext2, ext3 and ext4 filesystem implementations, each
+extended attribute must fit on a single filesystem block (1024, 2048
+or 4096 bytes, depending on the block size specified when the
+filesystem was created).
+.PP
+In the XFS and reiserfs filesystem implementations, there is no
+practical limit on the number or size of extended attributes
+associated with a file, and the algorithms used to store extended
+attribute information on disk are scalable.
 .PP
-In the current ext2 and ext3 filesystem implementations, all extended
-attributes must fit on a single filesystem block (1024, 2048 or 4096 bytes,
-depending on the block size specified when the filesystem
-was created). This limit may be removed in a future version.
-.PP
-In the XFS filesystem implementation, there is no practical limit on the
-number of extended attributes associated with a file, and the algorithms
-used to store extended attribute information on disk are scalable (stored
-either inline in the inode, as an extent, or in a B+ tree).
+In the JFS filesystem implementation, names can be up to 255 bytes and
+values up to 65,535 bytes.
 .SH ADDITIONAL NOTES
 Since the filesystems on which extended attributes are stored might also
 be used on architectures with a different byte order and machine word
------=_20071018073340_27115--
