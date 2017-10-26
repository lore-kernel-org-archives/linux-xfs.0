Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751483AbdJZWu4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 18:50:56 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC] xfs_repair: clear file / directory attribute on symlinks
Date: Thu, 26 Oct 2017 15:50:53 -0700
Message-Id: <20171026225053.10263-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>, Laurent Bonnaud <Laurent.Bonnaud@inpg.fr>, Tso Ted <tytso@mit.edu>, Nikolay Borisov <nborisov@suse.com>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

symlinks with the attribute append set cannot be removed as they are
treated as if a file was set with the immutable flag set. Standard
tools however cannot remove *any* attribute flag:

	chattr -a symlink
	chattr: Operation not supported while reading flags on b

Furthermore one cannot list attributes on symlinks using lsattr either:

	# touch a
	# ln -s a b
	# lsattr b
	lsattr: Operation not supported While reading flags on b

This means that if you end up with an append attribute on a symlink
you need special tools to try to remove it. This begs the question of
whether or not XFS should also disallow attributes on symlinks.

I can trace the lsattr change back down to commit 023d111e92195
("chattr.1.in: Document the compression attribute flags E, X, and ...")
on e2fsprogs since August 2002. That commit just refers to the fact
that attributes were only allowed after that commit for directories
and regular files due to Debian bug 152029 [0]. This bug was filed since
lsattr used to enable attributes even on special files and lsattr would
segfault when used against them since when used against some old DRM
buggy driver the ioctl seem to have worked bug crashed lsattr. The bug
report doesn't list any specific reasoning for not allowing attributes
on symlinks though.

Although in XFS you could end up in a situation where attributes
are set on a symlink this is ather hard to do, likewie for clearing
them.

Its unclear if XFS purposely supports attributes on symlinks or
if this was unintentional.

The ways in which you can end up to setting / unsetting / getting attributes
on symlinks on XFS are:

	a) corruption
	b) xfsctl()
	c) xfs_db [1] [2] - only when umounted

POSIX doesn't seem to actually have a position on this.

These are not extended attributes, however xattr(7) does have
a little nugget worth considering regarding this, and for which
it was decided to at least not support extended attributes on
symlinks or special files:

	The file permissions of symbolic links are not used in
        access checks. These differences would allow users to consume
	filesystem resources in a way not controllable by disk quotas
	for group or world writable special files and directories.

	For this reason, extended user attributes are allowed only for
	regular files and directories.

For these reasons, and since corruption is the only current valid
case where these seem to have popped up -- apply the same logic on
XFS, otherwise we'd be going against the e2fsprogs chattr convention
set since August 2002, and which folks likely are used to.

This fixes filesystems which have these attributes set where clearly
they were set by corruption.

[0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=152029
[1] xfs_db -x -c 'inode inode-number' -c 'write core.append 1' /dev/device
[2] xfs_db -x -c 'inode inode-number' -c 'write core.append 0' /dev/device

Cc: "Laurent Bonnaud" <Laurent.Bonnaud@inpg.fr>
Cc: Tso Ted <tytso@mit.edu>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Flex Liu <fliu@suse.com>
Cc: Jake Norris <jake.norris@suse.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---

Otherwise if we *do* wish to support some of these we should
document the semantics. Otherwise this seems just odd and users
can end up with unexpected situations not being able to easily
clear this type of corruption.

The append attribute is particularly annoying given you can't
remove these symlinks at all, and the first thing naturally a
user could do is try 'lsattr' or 'chattr'. Obviously this won't
help and the user will just get frustrated.

 repair/dinode.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index 15ba8cc22b39..03e93a6e17c0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2482,6 +2482,41 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 						FS_XFLAG_EXTSIZE);
 			}
 		}
+		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC |
+			     XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND |
+			     XFS_DIFLAG_SYNC | XFS_DIFLAG_NOATIME |
+			     XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT |
+			     XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS |
+			     XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT |
+			     XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM |
+			     XFS_DIFLAG2_DAX | XFS_DIFLAG2_COWEXTSIZE)) {
+			/* chattr cannot clear append on symlink */
+			if (di_mode && S_ISLNK(di_mode) &&
+			    !S_ISREG(di_mode) && !S_ISDIR(di_mode)) {
+				if (!uncertain) {
+					do_warn(
+	_("file or directory attributes set on symlink inode %" PRIu64 "\n"),
+						lino);
+				}
+				flags &= ~(XFS_DIFLAG_REALTIME |
+					   XFS_DIFLAG_PREALLOC |
+					   XFS_DIFLAG_IMMUTABLE |
+					   XFS_DIFLAG_APPEND |
+					   XFS_DIFLAG_SYNC |
+					   XFS_DIFLAG_NOATIME |
+					   XFS_DIFLAG_NODUMP |
+					   XFS_DIFLAG_RTINHERIT |
+					   XFS_DIFLAG_PROJINHERIT |
+					   XFS_DIFLAG_NOSYMLINKS |
+					   XFS_DIFLAG_EXTSIZE |
+					   XFS_DIFLAG_EXTSZINHERIT |
+					   XFS_DIFLAG_NODEFRAG |
+					   XFS_DIFLAG_FILESTREAM |
+					   XFS_DIFLAG2_DAX |
+					   XFS_DIFLAG2_COWEXTSIZE);
+			}
+		}
+
 		if (!verify_mode && flags != be16_to_cpu(dino->di_flags)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags.\n"));
-- 
2.14.2

