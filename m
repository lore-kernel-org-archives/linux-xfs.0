Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F1AD7F8D
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 22:39:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BA0C304048
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 20:39:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5oOePk0W1nDKoeGY for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 20:39:45 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2A62D60D2E83
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 22:39:45 -0500 (CDT)
Message-ID: <55960400.4060106@sandeen.net>
Date: Thu, 02 Jul 2015 22:39:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: simplify patch naming in libxfs-commit
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
To: xfs-oss <xfs@oss.sgi.com>

Git already knows how to create a patch name from a commit,
no need to re-invent it with cats walking on keyboards,
entering obfuscated sed contests.  ;)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Untested, TBH - at least as part of the script.

The git command works on its own, given a commit id.

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 4a8c8a6..09e8f40 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -223,26 +223,6 @@ apply_patch()
 	rm -f $_new_patch
 }
 
-# name a guilt patch. Code is lifted from guilt import-commit.
-name_patch()
-{
-	s=`git log --no-decorate --pretty=oneline -1 $1 | cut -c 42-`
-
-	# Try to convert the first line of the commit message to a
-	# valid patch name.
-	fname=`printf %s "$s" |  \
-			sed -e "s/&/and/g" -e "s/[ :]/_/g" -e "s,[/\\],-,g" \
-			    -e "s/['\\[{}]//g" -e 's/]//g' -e 's/\*/-/g' \
-			    -e 's/\?/-/g' -e 's/\.\.\.*/./g' -e 's/^\.//' \
-			    -e 's/\.patch$//' -e 's/\.$//' | tr A-Z a-z`
-
-	# Try harder to make it a legal commit name by
-	# removing all but a few safe characters.
-	fname=`echo $fname|tr -d -c _a-zA-Z0-9---/\\n`
-
-	echo $fname
-}
-
 # single patch is easy.
 if [ -z "$COMMIT_ID" ]; then
 	apply_patch $PATCH
@@ -274,7 +254,7 @@ for commit in $commit_list; do
 	# switch to source repo and pull commit into a patch file
 	pushd $REPO > /dev/null
 	git show $commit > $PATCH || usage "Bad source commit ID!"
-	patch_name=`name_patch $commit`
+	patch_name=`git log --format=format:"%f.patch" -1 $commit`
 	popd > /dev/null
 
 	apply_patch $PATCH $patch_name $commit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
