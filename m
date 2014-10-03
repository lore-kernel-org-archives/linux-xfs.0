Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 483867F47
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 16:50:22 -0500 (CDT)
Date: Fri, 3 Oct 2014 16:50:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 01/16] lib: add unicode character database files
Message-ID: <20141003215021.GZ1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Olaf Weber <olaf@sgi.com>

Add files from the Unicode Character Database, version 7.0.0, to the source.
A helper program that generates a trie used for normalization from these
files is part of a separate commit.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
[v2: Removed large unicode files prior to posting.  Get them as below. -bpm]
[v3: Moved files to ucd8norm directory. -bpm]
[v4: Moved to lib/ucd. -bpm]

cd lib/ucd
wget http://www.unicode.org/Public/7.0.0/ucd/CaseFolding.txt
wget http://www.unicode.org/Public/7.0.0/ucd/DerivedAge.txt
wget http://www.unicode.org/Public/7.0.0/ucd/extracted/DerivedCombiningClass.txt
wget http://www.unicode.org/Public/7.0.0/ucd/DerivedCoreProperties.txt
wget http://www.unicode.org/Public/7.0.0/ucd/NormalizationCorrections.txt
wget http://www.unicode.org/Public/7.0.0/ucd/NormalizationTest.txt
wget http://www.unicode.org/Public/7.0.0/ucd/UnicodeData.txt
for e in *.txt
do
	base=`basename $e .txt`
	mv $e $base-7.0.0.txt
done
---
 lib/ucd/README | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 lib/ucd/README

diff --git a/lib/ucd/README b/lib/ucd/README
new file mode 100644
index 0000000..d713e66
--- /dev/null
+++ b/lib/ucd/README
@@ -0,0 +1,33 @@
+The files in this directory are part of the Unicode Character Database
+for version 7.0.0 of the Unicode standard.
+
+The full set of files can be found here:
+
+  http://www.unicode.org/Public/7.0.0/ucd/
+
+The latest released version of the UCD can be found here:
+
+  http://www.unicode.org/Public/UCD/latest/
+
+The files in this directory are identical, except that they have been
+renamed with a suffix indicating the unicode version.
+
+Individual source links:
+
+  http://www.unicode.org/Public/7.0.0/ucd/CaseFolding.txt
+  http://www.unicode.org/Public/7.0.0/ucd/DerivedAge.txt
+  http://www.unicode.org/Public/7.0.0/ucd/extracted/DerivedCombiningClass.txt
+  http://www.unicode.org/Public/7.0.0/ucd/DerivedCoreProperties.txt
+  http://www.unicode.org/Public/7.0.0/ucd/NormalizationCorrections.txt
+  http://www.unicode.org/Public/7.0.0/ucd/NormalizationTest.txt
+  http://www.unicode.org/Public/7.0.0/ucd/UnicodeData.txt
+
+md5sums
+
+  9a92b2bfe56c6719def926bab524fefd  CaseFolding-7.0.0.txt
+  07b8b1027eb824cf0835314e94f23d2e  DerivedAge-7.0.0.txt
+  90c3340b16821e2f2153acdbe6fc6180  DerivedCombiningClass-7.0.0.txt
+  c41c0601f808116f623de47110ed4f93  DerivedCoreProperties-7.0.0.txt
+  522720ddfc150d8e63a2518634829bce  NormalizationCorrections-7.0.0.txt
+  1f35175eba4a2ad795db489f789ae352  NormalizationTest-7.0.0.txt
+  c8355655731d75e6a3de8c20d7e601ba  UnicodeData-7.0.0.txt
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
