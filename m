Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161105AbeCATNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:13:02 -0500
Subject: [PATCH 00/16] xfsprogs: misc fixes, geometry refactoring
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:12:55 -0800
Message-ID: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

Hi all,

Here's a bunch of patches for xfsprogs 4.16!

The first six patches fix compiler warnings, crasher bugs, and tweak
various things in xfs_scrub per early user and maintainer feedback.
Patch 7 creates a new xfs_db command to print transaction reservation
calculations so that they can be compared to the kernel's calculations.
Patch 8 enables repair to bypass inode fork verifiers when it's trying
to libxfs_iget an inode to reconnect it to lost+found, which should fix
some of the bug reports about repair failing to finish.  Patch 9 enables
LTO, which substantially reduces final executable sizes because we can
remove unnecessary code.

The seven patches at the end refactor geometry reporting in xfsprogs.
First we hoist the fsgeometry generation function to libxfs, then add
some libfrog functions to print fsgeometry structures.  Next we add a
command to xfs_db to print the geometry information of the loaded
filesystem.  Finally, we move online geometry reporting from growfs to
spaceman and refactor xfs_info to call spaceman or db depending on the
passed in command line argument.

This probably won't eat your data, and the branch[2] should apply
against for-next.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
