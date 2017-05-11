Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756046AbdEKTfo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 15:35:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C68B461BA6
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 19:35:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F6DD5C885
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 19:35:43 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: new libxfs-apply option for Signed-off-by: tag
Message-ID: <09b8530a-6b35-bc05-130e-6dfd35889f2b@redhat.com>
Date: Thu, 11 May 2017 14:35:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Technically when a maintainer moves a patch from another project,
they should add their Signed-off-by: tag.  Add an option to
libxfs-apply to make that easy when cross-porting libxfs
patches.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index e7d7e0a..b594ccb 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -8,7 +8,7 @@ usage()
 	echo $*
 	echo
 	echo "Usage:"
-	echo "	libxfs-apply [--verbose] --source <repodir> --commit <commit_id>"
+	echo "	libxfs-apply [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
 	echo "	libxfs-apply --patch <patchfile>"
 	echo
 	echo "libxfs-apply should be run in the destination git repository."
@@ -73,6 +73,7 @@ while [ $# -gt 0 ]; do
 	--source)	REPO=$2 ; shift ;;
 	--patch)	PATCH=$2; shift ;;
 	--commit)	COMMIT_ID=$2 ; shift ;;
+	--sob)		SIGNED_OFF_BY=$2 ; shift ;;
 	--verbose)	VERBOSE=true ;;
 	*)		usage ;;
 	esac
@@ -274,6 +275,14 @@ fixup_header_format()
 			print $0
 		}' > $_hdr.new
 
+	# Remove the last line if it contains only whitespace
+	sed -i '${/^ *$/d;}' $_hdr.new
+
+	# Add Signed-off-by: header if specified
+	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
+		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
+	fi
+
 	# now output the new patch
 	cat $_hdr.new $_diff
 

