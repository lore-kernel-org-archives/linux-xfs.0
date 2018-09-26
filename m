Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45600 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbeI0Bt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 21:49:56 -0400
Subject: [PATCH 10/24] docs: add XFS testing chapter to the DS&A book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Sep 2018 12:35:23 -0700
Message-ID: <153799052363.31202.5829452689470249518.stgit@magnolia>
In-Reply-To: <153799045443.31202.17537455000771265705.stgit@magnolia>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/filesystems/xfs/ondisk/overview.rst |    1 +
 Documentation/filesystems/xfs/ondisk/testing.rst  |   25 +++++++++++++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/filesystems/xfs/ondisk/testing.rst


diff --git a/Documentation/filesystems/xfs/ondisk/overview.rst b/Documentation/filesystems/xfs/ondisk/overview.rst
index d2021fb68276..96c85da0a9c6 100644
--- a/Documentation/filesystems/xfs/ondisk/overview.rst
+++ b/Documentation/filesystems/xfs/ondisk/overview.rst
@@ -49,3 +49,4 @@ latency.
 .. include:: reconstruction.rst
 .. include:: common_types.rst
 .. include:: magic.rst
+.. include:: testing.rst
diff --git a/Documentation/filesystems/xfs/ondisk/testing.rst b/Documentation/filesystems/xfs/ondisk/testing.rst
new file mode 100644
index 000000000000..558c72a87843
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/testing.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
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
