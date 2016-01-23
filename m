Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A1B67F51
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:36:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 408D38F804B
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:36:18 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id SAJPfFV2MSVkM7xn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:36:16 -0800 (PST)
Subject: [PATCH 1/2] xfsdocs: document known testing procedures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:36:13 -0800
Message-ID: <20160123003613.2605.14510.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 ++++++++++++
 design/XFS_Filesystem_Structure/testing.asciidoc   |   23 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 ++
 3 files changed, 39 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/testing.asciidoc


diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index ba97809..cc5596d 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -108,4 +108,18 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.14</revnumber>
+		<date>January 2016</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email></email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Document disk format change testing.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/testing.asciidoc b/design/XFS_Filesystem_Structure/testing.asciidoc
new file mode 100644
index 0000000..f1c90bc
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/testing.asciidoc
@@ -0,0 +1,23 @@
+[[Testing]]
+= Testing Filesystem Changes
+
+People put a lot of trust in filesystems to preserve their data in a reliable
+fashion.  To that end, it is very important that users and developers have
+access to a suite of regression tests that can be used to prove correct
+operation of any given filesystem code, or to analyze failures to fix problems
+found in the code.  The XFS regression test suite, +xfstests+, is hosted at
++git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git+.  Most tests apply to
+filesystems in general, but the suite also contains tests for features specific
+to each filesystem.
+
+When fixing bugs, it is important to provide a testcase exposing the bug so
+that the developers can avoid a future re-occurrence of the regression.
+Furthermore, if you're developing a new user-visible feature for XFS, please
+help the rest of the development community to sustain and maintain the whole
+codebase by providing generous test coverage to check its behavior.
+
+When altering, adding, or removing an on-disk data structure, please remember
+to update both the in-kernel structure size checks in +xfs_ondisk.h+ and to
+ensure that your changes are reflected in xfstest xfs/122.  These regression
+tests enable us to detect compiler bugs, alignment problems, and anything
+else that might result in the creation of incompatible filesystem images.
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 53262bf..f580aab 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -52,6 +52,8 @@ include::common_types.asciidoc[]
 
 include::magic.asciidoc[]
 
+include::testing.asciidoc[]
+
 // return titles to normal
 :leveloffset: 0
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
