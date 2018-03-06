Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36254 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754035AbeCFXYR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 18:24:17 -0500
Subject: [PATCH 6/5] libxfs-apply: add Signed-off-by:
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <12ef6721-1f1d-9dfa-507f-47e3d8143234@sandeen.net>
Date: Tue, 6 Mar 2018 17:24:16 -0600
MIME-Version: 1.0
In-Reply-To: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Technically when a maintainer moves a patch from another project,
they should add their Signed-off-by: tag.  Pick up SOB info
from git-config, and add an option to override that value if
desired.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index e7d7e0a..2957fa0 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -8,7 +8,7 @@ usage()
 	echo $*
 	echo
 	echo "Usage:"
-	echo "	libxfs-apply [--verbose] --source <repodir> --commit <commit_id>"
+	echo "	libxfs-apply [--verbose] [--sob <name/email>] --source <repodir> --commit <commit_id>"
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
@@ -274,6 +275,20 @@ fixup_header_format()
 			print $0
 		}' > $_hdr.new
 
+	# Remove the last line if it contains only whitespace
+	sed -i '${/^ *$/d;}' $_hdr.new
+
+	# Add Signed-off-by: header if specified
+	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
+		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
+	else	# get it from git config if present
+		SOB_NAME=`git config --get user.name`
+		SOB_EMAIL=`git config --get user.email`
+		if [ ! -z ${SOB_NAME+x} ]; then
+			echo "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" >> $_hdr.new
+		fi
+	fi
+
 	# now output the new patch
 	cat $_hdr.new $_diff
 

