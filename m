Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABDBA7F76
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:58:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90B118F8039
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:58:30 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id pIHCBaZaEtlH65Ns (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:58:28 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] check: add support for an external file containing tests
	to exclude
Date: Wed, 16 Apr 2014 00:58:22 -0400
Message-Id: <1397624302-9577-1-git-send-email-tytso@mit.edu>
In-Reply-To: <20140416001530.GU15995@dastard>
References: <20140416001530.GU15995@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>

Currently the -X option is intended to specify a set of expunging
files which are stored in each test/* subdirectory.  As described in
the commit description for 0b1e8abd4, in order to exclude the test
generic/280, the -X option is used as follows:

    $ cat tests/generic/3.0-stable-avoid
    280
    $ sudo ./check -X 3.0-stable-avoid generic/280

However, it is sometimes useful to store the set of expunged tests in
a single file, outside of tests/* subdirectories.  This commit enables
the following:

    $ cat /root/conf/data_journal.exclude
    generic/068
    ext4/301
    $ sudo ./check -E /root/conf/data_journal.exclude -g auto

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 check | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/check b/check
index e7ace63..b1eaed2 100755
--- a/check
+++ b/check
@@ -81,6 +81,7 @@ testlist options
     -g group[,group...]	include tests from these groups
     -x group[,group...]	exclude tests from these groups
     -X file		exclude individual tests
+    -E external_file	exclude individual tests
     [testlist]		include tests matching names in testlist
 '
 	    exit 0
@@ -222,6 +223,11 @@ while [ $# -gt 0 ]; do
 			done
 		done
 		;;
+	-E)	xfile=$2; shift ;
+		if [ -f $xfile ]; then
+			cat "$xfile" >> $tmp.xlist
+	        fi
+		;;
 	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
 	-l)	diff="diff" ;;
 	-udiff)	diff="$diff -u" ;;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
