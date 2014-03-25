Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BFE57F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 18:38:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC056AC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:38:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id acsfCDhz5QVWVwQZ for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:38:29 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PNcTDw007581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 19:38:29 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/5] xfstests: Remount file system if MOUNT_OPTIONS changed
Date: Wed, 26 Mar 2014 00:38:10 +0100
Message-Id: <1395790691-21161-4-git-send-email-lczerner@redhat.com>
In-Reply-To: <1395790691-21161-1-git-send-email-lczerner@redhat.com>
References: <1395790691-21161-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

When MOUNT_OPTIONS change we should remount TEST_DEV to put the changes
in effect. This will allow us to have different MOUNT_OPTIONS in sections
in configuration file.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 README.config-sections | 8 ++++++++
 check                  | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/README.config-sections b/README.config-sections
index 4d60272..2849fd5 100644
--- a/README.config-sections
+++ b/README.config-sections
@@ -36,6 +36,14 @@ For every section xfstests will run with specified options and will produce
 separate results in the '$RESULT_BASE/$section_name' directory.
 
 
+Different mount options
+-----------------------
+
+Specifying different mount options in difference config sections is allowed.
+When MOUNT_OPTIONS differs in the following section TEST_DEV will be remounted
+with new MOUNT_OPTIONS automatically before running the test.
+
+
 Multiple file systems
 ---------------------
 
diff --git a/check b/check
index a5a6184..b3937b3 100755
--- a/check
+++ b/check
@@ -394,6 +394,7 @@ fi
 
 for section in $HOST_OPTIONS_SECTIONS; do
 	OLD_FSTYP=$FSTYP
+	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
 	get_next_config $section
 
 	mkdir -p $RESULT_BASE
@@ -422,6 +423,13 @@ for section in $HOST_OPTIONS_SECTIONS; do
 			exit 1
 		fi
 		_prepare_test_list
+	elif [ "$OLD_MOUNT_OPTIONS" != "$MOUNT_OPTIONS" ]; then
+		umount $TEST_DEV 2> /dev/null
+		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
+		if [ $? -ne 1 ]; then
+			echo $out
+			exit 1
+		fi
 	fi
 
 	init_rc
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
