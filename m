Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcIOP34 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 11:29:56 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2 0/3] xfsprogs: xfs_quota foreign fs path handling modifications
Date: Thu, 15 Sep 2016 10:29:43 -0500
Message-Id: <1473953386-10242-1-git-send-email-billodo@redhat.com>
In-Reply-To: <1473866381-28975-1-git-send-email-billodo@redhat.com>
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com


Hello-

This is version 2 of a series that supercedes:
http://www.spinics.net/lists/xfs/msg42220.html -
(xfs_quota foreign fs path handling changes).

The following commits modified xfs_quota for use on foreign
filesystems:
b20b6c2 xfs_quota: certain commands must always be available
29647c8 xfs_quota: add capabilities for use on non-XFS filesystems

Included in those commits were modifications to
fs_initialise_mounts (paths.c), resulting in a reverse
compatibility issue. In particular, xfstest xfs/261 failed,
due to foreign fs paths being picked up from the fs table,
and the xfs_quota print command complaining about not being
able to print the foreign paths.

This series fixes the foreign path print problem, via
modifications to the xfs_quota paths and print operations.

patch 1: populate the fs table with xfs entries first,
maintaining mtab order, followed by foreign fs entries.

patch 2: adjust print and path formatting of xfs and
foreign fs entries, maintaining reverse compatibility.

patch 3: add the case for foreign fs in init_check_command
to cover both states of the -f (foreign_allowed) flag.

------
history:
v2: patch 1: -Improve commit message.
             -Align xfs_fs_count declaration and add it to path.h.
             -Correct src and dest initializations in memmove
              in fs_table_insert (fix valgrind error).
             -Remove unnecessary iterative loop in path_f.
             -Add iterative loop in print_f (break if foreign fs
              encountered and !foreign_allowed).
             -Correct path_f to use xfs_fs_count when !foreign_allowed.

    patch 2: -Simplify formatting logic for print and path.

    patch 3: -no changes.

v1: http://www.spinics.net/lists/xfs/msg42399.html
------

Again, Questions/comments are welcome.

Thanks-
Bill
