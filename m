Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026B7C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA10223444
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YtOKieNh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgIRCo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:44:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgIRCK3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 22:10:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2AQWM100544;
        Fri, 18 Sep 2020 02:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RtIQmea5y53ySGgO4dqMNU/opUXSAC/hxLSpwdK3lF0=;
 b=YtOKieNhyJ5lENmbguzuf5vTYy0ZqPD3L6nK9Q127d+lg5aGKOCUyItdy0YgQNs1jgKK
 3b0Nkyl+t4Hae+jQfGjhzOvuA6aeuyiG0qNgAAIhyUTj/CZkm65xGozv6v3G99EpgkrC
 kFpueTrHHT1jnHkOQLjLuay0L/ZBVmW++gnTLmbcd1SqmCzb2Bvws2sVzVsBr5W5pfL3
 xzIVpm+tlRta0qNoSA9GS7X6wEvxqrfNrtKNdYjBdwb1vK70JkWfPK7zXKLZBzmy++jV
 Phv0VxbV6vbW+u3/XmEJnx/pItzz/SA0wbcsCNSbqxlE2rRHjE0Z3ZgJiswHCyI9yS+f dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dx7cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:10:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I25vbh130909;
        Fri, 18 Sep 2020 02:10:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm35x9bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:10:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08I2AOqQ018700;
        Fri, 18 Sep 2020 02:10:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:10:23 +0000
Date:   Thu, 17 Sep 2020 19:10:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 26/24] common: drop HOSTOS
Message-ID: <20200918021022.GK7954@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180019
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We effectively support only Linux these days, so drop most of the
special casing of HOSTOS.  We'll retain the simple check just in case
someone tries to run this on a different operating system.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/config |   50 ++++++++++++++++++++++----------------------------
 common/rc     |   20 ++------------------
 common/xfs    |    2 +-
 3 files changed, 25 insertions(+), 47 deletions(-)

diff --git a/common/config b/common/config
index 1fe1e0e1..3de87ea7 100644
--- a/common/config
+++ b/common/config
@@ -46,7 +46,7 @@ export LC_ALL=C
 PATH=".:$PATH"
 
 export HOST=`hostname -s`
-export HOSTOS=`uname -s`
+test `uname -s` = "Linux" || _fatal "fstests only supports Linux"
 
 export MODULAR=0               # using XFS as a module or not
 export BOOT="/boot"            # install target for kernels
@@ -143,7 +143,7 @@ export PS_ALL_FLAGS="-ef"
 
 export DF_PROG="$(type -P df)"
 [ "$DF_PROG" = "" ] && _fatal "df not found"
-[ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T -P"
+export DF_PROG="$DF_PROG -T -P"	# Linux
 
 export XFS_IO_PROG="$(type -P xfs_io)"
 [ "$XFS_IO_PROG" = "" ] && _fatal "xfs_io not found"
@@ -242,29 +242,25 @@ if [ "$UDEV_SETTLE_PROG" == "" ]; then
 fi
 export UDEV_SETTLE_PROG
 
-case "$HOSTOS" in
-    Linux)
-	export MKFS_XFS_PROG=$(type -P mkfs.xfs)
-	export MKFS_EXT4_PROG=$(type -P mkfs.ext4)
-	export MKFS_UDF_PROG=$(type -P mkudffs)
-	export MKFS_BTRFS_PROG=$(set_mkfs_prog_path_with_opts btrfs)
-	export MKFS_F2FS_PROG=$(set_mkfs_prog_path_with_opts f2fs)
-	export DUMP_F2FS_PROG=$(type -P dump.f2fs)
-	export F2FS_IO_PROG=$(type -P f2fs_io)
-	export BTRFS_UTIL_PROG=$(type -P btrfs)
-	export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
-	export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
-	export BTRFS_TUNE_PROG=$(type -P btrfstune)
-	export XFS_FSR_PROG=$(type -P xfs_fsr)
-	export MKFS_NFS_PROG="false"
-	export MKFS_CIFS_PROG="false"
-	export MKFS_OVERLAY_PROG="false"
-	export MKFS_REISER4_PROG=$(type -P mkfs.reiser4)
-	export E2FSCK_PROG=$(type -P e2fsck)
-	export TUNE2FS_PROG=$(type -P tune2fs)
-	export FSCK_OVERLAY_PROG=$(type -P fsck.overlay)
-        ;;
-esac
+export MKFS_XFS_PROG=$(type -P mkfs.xfs)
+export MKFS_EXT4_PROG=$(type -P mkfs.ext4)
+export MKFS_UDF_PROG=$(type -P mkudffs)
+export MKFS_BTRFS_PROG=$(set_mkfs_prog_path_with_opts btrfs)
+export MKFS_F2FS_PROG=$(set_mkfs_prog_path_with_opts f2fs)
+export DUMP_F2FS_PROG=$(type -P dump.f2fs)
+export F2FS_IO_PROG=$(type -P f2fs_io)
+export BTRFS_UTIL_PROG=$(type -P btrfs)
+export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
+export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
+export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export XFS_FSR_PROG=$(type -P xfs_fsr)
+export MKFS_NFS_PROG="false"
+export MKFS_CIFS_PROG="false"
+export MKFS_OVERLAY_PROG="false"
+export MKFS_REISER4_PROG=$(type -P mkfs.reiser4)
+export E2FSCK_PROG=$(type -P e2fsck)
+export TUNE2FS_PROG=$(type -P tune2fs)
+export FSCK_OVERLAY_PROG=$(type -P fsck.overlay)
 
 # SELinux adds extra xattrs which can mess up our expected output.
 # So, mount with a context, and they won't be created.
@@ -753,9 +749,7 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 
 	# Autodetect fs type based on what's on $TEST_DEV unless it's been set
 	# externally
-	if [ -z "$FSTYP" ] && \
-	   [ "$HOSTOS" == "Linux" -o "$OSTYPE" == "linux-gnu" ] && \
-	   [ ! -z "$TEST_DEV" ]; then
+	if [ -z "$FSTYP" ] && [ ! -z "$TEST_DEV" ]; then
 		FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
 	fi
 	FSTYP=${FSTYP:=xfs}
diff --git a/common/rc b/common/rc
index bbafc73d..3adeeefe 100644
--- a/common/rc
+++ b/common/rc
@@ -49,19 +49,13 @@ _math()
 
 dd()
 {
-   if [ "$HOSTOS" == "Linux" ]
-   then	
 	command dd --help 2>&1 | grep noxfer >/dev/null
-	
 	if [ "$?" -eq 0 ]
 	    then
 		command dd status=noxfer $@
 	    else
 		command dd $@
-    	fi
-   else
-	command dd $@
-   fi
+	fi
 }
 
 # Prints the md5 checksum of a given file
@@ -992,7 +986,7 @@ _scratch_mkfs_sized()
 
     local blocks=`expr $fssize / $blocksize`
 
-    if [ "$HOSTOS" == "Linux" -a -b "$SCRATCH_DEV" ]; then
+    if [ -b "$SCRATCH_DEV" ]; then
 	local devsize=`blockdev --getsize64 $SCRATCH_DEV`
 	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
     fi
@@ -1764,11 +1758,6 @@ _require_logdev()
 #
 _require_loop()
 {
-    if [ "$HOSTOS" != "Linux" ]
-    then
-	_notrun "This test requires linux for loopback device support"
-    fi
-
     modprobe loop >/dev/null 2>&1
     if grep loop /proc/devices >/dev/null 2>&1
     then
@@ -1782,11 +1771,6 @@ _require_loop()
 #
 _require_ext2()
 {
-    if [ "$HOSTOS" != "Linux" ]
-    then
-	_notrun "This test requires linux for ext2 filesystem support"
-    fi
-
     modprobe ext2 >/dev/null 2>&1
     if grep ext2 /proc/filesystems >/dev/null 2>&1
     then
diff --git a/common/xfs b/common/xfs
index 8a3fd30c..0f4b8521 100644
--- a/common/xfs
+++ b/common/xfs
@@ -481,7 +481,7 @@ _check_xfs_filesystem()
 
 	$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
 		| tee $tmp.logprint | grep -q "<CLEAN>"
-	if [ $? -ne 0 -a "$HOSTOS" = "Linux" ]; then
+	if [ $? -ne 0 ]; then
 		_log_err "_check_xfs_filesystem: filesystem on $device has dirty log"
 		echo "*** xfs_logprint -t output ***"	>>$seqres.full
 		cat $tmp.logprint			>>$seqres.full
