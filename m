Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32928 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdAEBEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:04:40 -0500
Subject: [PATCH 0/7] xfstests: misc reflink test fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:04:36 -0800
Message-ID: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

The following patchset enable the use of xfstests to test reflink
functionality under ocfs2.  The first patch tests the ability to reflink
into and out of inline-data files on ocfs2.  Patches 2-6 fix various
problems with the tests that came up when qualifying ocfs2.

The last patch maliciously corrupts ext4 and xfs filesystems to
exploit nonexistent checking of i_size in order to coerce Linux into
loading a file with negative size.  It then exploits integer overflows
in the VFS writeback code to hard lock the kernel.  Don't run the tests
in this patch ({shared,xfs}/40[01]) unless you have a fixed kernel (4.10)

Comments and questions are, as always, welcome.

--D
