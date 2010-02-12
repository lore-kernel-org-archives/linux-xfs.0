Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKxiQo027814 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:59:45 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002122100.o1CL0xn8026166@stout.americas.sgi.com>
Date: Fri, 12 Feb 2010 15:00:59 -0600
Subject: [PATCH] xfsdump: digitally sign release tags
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Arrange for the commit marking a new release to include a
"Signed-off-by" line, and have the corresponding tag include
a digital signature.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 release.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/release.sh
===================================================================
--- a/release.sh
+++ b/release.sh
@@ -13,10 +13,10 @@ sed -e "s/${version}.*/${version} (${dat
 	mv doc/CHANGES.tmp doc/CHANGES
 
 echo "Commiting CHANGES update to git"
-git-commit -a -m "${version} release"
+git commit -s -a -m "${version} release"
 
 echo "Tagging git repository"
-git-tag v${version}
+git tag -s -a -m "${version} release" v${version}
 
 echo "Creating source tarball"
 make dist

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
