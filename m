Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeJDLKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 07:10:42 -0400
Subject: [PATCH 08/22] docs: add XFS testing chapter to the DS&A book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Oct 2018 21:19:14 -0700
Message-ID: <153862675482.26427.4160924036723844450.stgit@magnolia>
In-Reply-To: <153862669110.26427.16504658853992750743.stgit@magnolia>
References: <153862669110.26427.16504658853992750743.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../filesystems/xfs-data-structures/overview.rst   |    1 +
 .../filesystems/xfs-data-structures/testing.rst    |   25 ++++++++++++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/filesystems/xfs-data-structures/testing.rst


diff --git a/Documentation/filesystems/xfs-data-structures/overview.rst b/Documentation/filesystems/xfs-data-structures/overview.rst
index 23eb71d65c93..d6711dc653d8 100644
--- a/Documentation/filesystems/xfs-data-structures/overview.rst
+++ b/Documentation/filesystems/xfs-data-structures/overview.rst
@@ -49,3 +49,4 @@ latency.
 .. include:: reconstruction.rst
 .. include:: common_types.rst
 .. include:: magic.rst
+.. include:: testing.rst
diff --git a/Documentation/filesystems/xfs-data-structures/testing.rst b/Documentation/filesystems/xfs-data-structures/testing.rst
new file mode 100644
index 000000000000..3d3386854408
--- /dev/null
+++ b/Documentation/filesystems/xfs-data-structures/testing.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: CC-BY-SA-4.0
+
+Testing Filesystem Changes
+--------------------------
+
+People put a lot of trust in filesystems to preserve their data in a reliable
+fashion. To that end, it is very important that users and developers have
+access to a suite of regression tests that can be used to prove correct
+operation of any given filesystem code, or to analyze failures to fix problems
+found in the code. The XFS regression test suite, xfstests, is hosted at
+``git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git``. Most tests apply to
+filesystems in general, but the suite also contains tests for features
+specific to each filesystem.
+
+When fixing bugs, it is important to provide a testcase exposing the bug so
+that the developers can avoid a future re-occurrence of the regression.
+Furthermore, if you’re developing a new user-visible feature for XFS, please
+help the rest of the development community to sustain and maintain the whole
+codebase by providing generous test coverage to check its behavior.
+
+When altering, adding, or removing an on-disk data structure, please remember
+to update both the in-kernel structure size checks in xfs\_ondisk.h and to
+ensure that your changes are reflected in xfstest xfs/122. These regression
+tests enable us to detect compiler bugs, alignment problems, and anything else
+that might result in the creation of incompatible filesystem images.
