Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57944 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965598AbeF0U3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 16:29:20 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 103B829DAD
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jun 2018 20:29:20 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200311] New: xfsprogs fails to install when user group has
 space
Date: Wed, 27 Jun 2018 20:29:17 +0000
Message-ID: <bug-200311-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200311

            Bug ID: 200311
           Summary: xfsprogs fails to install when user group has space
           Product: File System
           Version: 2.5
    Kernel Version: 4.14.37
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: luizluca@gmail.com
        Regression: No

While compiling xfsprogs-4.11.0, install failed because my group has a space
("domain users")

Installing libxfs-install
/usr/bin/gmake --no-print-directory Q= -C libxfs install
i486-openwrt-linux-musl-gcc -MM -Os -pipe -march=pentium4 -fno-caller-saves
-fno-plt -fhonour-copts -Wno-error=unused-but-set-variable
-Wno-error=unused-result
-iremap/home/REDETRESC/luizluca/prog-local/openwrt/18.06/build_dir/target-i386_pentium4_musl/xfsprogs-4.11.0:xfsprogs-4.11.0
-Wformat -Werror=format-security -fstack-protector -D_FORTIFY_SOURCE=1
-Wl,-z,now -Wl,-z,relro
-I/home/REDETRESC/luizluca/prog-local/openwrt/18.06/staging_dir/target-i386_pentium4_musl/usr/include
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE 
-D_FILE_OFFSET_BITS=64 -I. -g -O2  -DVERSION=\"4.11.0\"
-DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include
-I../libxfs -Wall  cache.c crc32.c defer_item.c init.c kmem.c list_sort.c
logitem.c radix-tree.c rdwr.c trans.c util.c xfs_ag_resv.c xfs_alloc.c
xfs_alloc_btree.c xfs_attr.c xfs_attr_leaf.c xfs_attr_remote.c xfs_bit.c
xfs_bmap.c xfs_bmap_btree.c xfs_btree.c xfs_da_btree.c xfs_da_format.c
xfs_defer.c xfs_dir2.c xfs_dir2_block.c xfs_dir2_data.c xfs_dir2_leaf.c
xfs_dir2_node.c xfs_dir2_sf.c xfs_dquot_buf.c xfs_ialloc.c xfs_inode_buf.c
xfs_inode_fork.c xfs_ialloc_btree.c xfs_log_rlimit.c xfs_refcount.c
xfs_refcount_btree.c xfs_rmap.c xfs_rmap_btree.c xfs_rtbitmap.c xfs_sb.c
xfs_symlink_remote.c xfs_trans_resv.c linux.c |
/home/REDETRESC/luizluca/prog-local/openwrt/18.06/staging_dir/host/bin/sed -e
's,^\([^:]*\)\.o,\1.lo,' > .ltdep
rm -f .ltdep
../install-sh -o luizluca -g domain users -m 755 -d /usr/include/xfs
cp: cannot stat 'users': No such file or directory
gmake[5]: *** [Makefile:145: install] Error 1
make[4]: *** [Makefile:127: libxfs-install] Error 2

The fix is quite simple:

include/buildmacros:
-INSTALL        = $(TOPDIR)/install-sh -o $(PKG_USER) -g $(PKG_GROUP)
+INSTALL        = $(TOPDIR)/install-sh -o $(PKG_USER) -g "$(PKG_GROUP)"

install-sh:
-while getopts "Dcm:d:S:o:g:T:" c $*
+while getopts "Dcm:d:S:o:g:T:" c "$@"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.