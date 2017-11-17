Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29710 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdKQUN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:13:29 -0500
Subject: [PATCH 00/12] xfsprogs-4.15: common library for misc. routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:13:25 -0800
Message-ID: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This patch series refactors miscellaneous data structures and runtime
support code out of libxfs and libxcmd into a new library to contain all
of the funny random other gunk ("libfrog") that doesn't fit anywhere
else.  Initially, libfrog will contain routines for bit manipulation,
device topology, threaded workqueues, an avl tree, and file path
detection.  Existing programs are modified to pull from libfrog; the
future xfs_scrub program will also take advantage of it.

This whole mess sits atop the libxfs-4.15-sync branch; see the
djwong-devel branch in my repo[1] for something pullable.

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
