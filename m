Return-Path: <SRS0=TKlC=4E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E4EC2BA83
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 18:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9108B20857
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 18:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AF+eoMex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgBPSRA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Feb 2020 13:17:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57005 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725993AbgBPSRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Feb 2020 13:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581877018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yfIEKrGvNmGLtE9SrDByHM7deEljV6fLtoBjwHGaNuU=;
        b=AF+eoMexSsuEsA1dZ2pRM5xh10qQ+N/A6uSjUNocRpR5vY+WKqYB3uXwAvoJv4sUHd3APt
        PyLBSyA6Gr6SOmj2RRo8s+swrHAlY5ECj+mtoVnBuDDPxTejAvqotbN8eJ8jx5pWPWmimH
        ku91UMtR9lWduCcF6FXc11ooUmPmDjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-Su5h9q2QNGSmDKJ2U7ytpA-1; Sun, 16 Feb 2020 13:16:54 -0500
X-MC-Unique: Su5h9q2QNGSmDKJ2U7ytpA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C04A5F9;
        Sun, 16 Feb 2020 18:16:53 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-51.pek2.redhat.com [10.72.12.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4332C60BE1;
        Sun, 16 Feb 2020 18:16:45 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] generic: test per-type quota softlimit enforcement timeout
Date:   Mon, 17 Feb 2020 02:16:31 +0800
Message-Id: <20200216181631.22560-2-zlang@redhat.com>
In-Reply-To: <20200216181631.22560-1-zlang@redhat.com>
References: <20200216181631.22560-1-zlang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Set different block & inode grace timers for user, group and project
quotas, then test softlimit enforcement timeout, make sure different
grace timers as expected.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This case test passed on ext4, but on XFS (xfs-linux for-next branch with
Eric's patchset: [PATCH 0/4] xfs: enable per-type quota timers and warn l=
imits)
I got below different output:

# diff -u tests/generic/594.out results/generic/594.out.bad              =
                             =20
--- /home/git/xfstests-zlang/tests/generic/594.out      2020-02-16 12:46:=
33.525450453 -0500
+++ /home/git/xfstests-zlang/results//generic/594.out.bad       2020-02-1=
6 12:49:21.297296515 -0500                                               =
                                           =20
@@ -10,6 +10,8 @@
 pwrite: Disk quota exceeded
 --- Test inode quota ---
 Create 2 more files, over the inode softlimit...
+touch: cannot touch 'SCRATCH_MNT/file3': Disk quota exceeded
+touch: cannot touch 'SCRATCH_MNT/file4': Disk quota exceeded
 Try to create one more inode after grace...
 touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
 ### Remove all files
@@ -20,7 +22,7 @@
 Write 225 blocks...
 Rewrite 250 blocks plus 1 byte, over the block softlimit...
 Try to write 1 one more block after grace...
-pwrite: Disk quota exceeded
+pwrite: No space left on device
 --- Test inode quota ---
 Create 2 more files, over the inode softlimit...
 Try to create one more inode after grace...
@@ -33,7 +35,7 @@
 Write 225 blocks...
 Rewrite 250 blocks plus 1 byte, over the block softlimit...
 Try to write 1 one more block after grace...
-pwrite: Disk quota exceeded
+pwrite: No space left on device
 --- Test inode quota ---
 Create 2 more files, over the inode softlimit...
 Try to create one more inode after grace...

That looks weird for me, does anyone know if it's a XFS bug, or how
can I fix this issue for xfs?

Thanks,
Zorro

 common/quota          |   4 +
 tests/generic/594     | 179 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/594.out |  41 ++++++++++
 tests/generic/group   |   1 +
 4 files changed, 225 insertions(+)
 create mode 100755 tests/generic/594
 create mode 100644 tests/generic/594.out

diff --git a/common/quota b/common/quota
index 4e07fef1..6450df34 100644
--- a/common/quota
+++ b/common/quota
@@ -208,6 +208,10 @@ _qmount()
     if [ "$FSTYP" !=3D "xfs" ]; then
         quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
         quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
+        # try to turn on project quota if it's supported
+        if quotaon --help 2>&1 | grep -q '\-\-project'; then
+            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
+        fi
     fi
     chmod ugo+rwx $SCRATCH_MNT
 }
diff --git a/tests/generic/594 b/tests/generic/594
new file mode 100755
index 00000000..9a33ab8b
--- /dev/null
+++ b/tests/generic/594
@@ -0,0 +1,179 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 594
+#
+# Test per-type(user, group and project) filesystem quota timers, make s=
ure
+# enforcement
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	restore_project
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+require_project()
+{
+	rm -f $tmp.projects $tmp.projid
+	if [ -f /etc/projects ];then
+		cat /etc/projects > $tmp.projects
+	fi
+	if [ -f /etc/projid ];then
+		cat /etc/projid > $tmp.projid
+	fi
+
+	cat >/etc/projects <<EOF
+100:$SCRATCH_MNT/t
+EOF
+	cat >/etc/projid <<EOF
+$qa_user:100
+EOF
+	PROJECT_CHANGED=3D1
+}
+
+restore_project()
+{
+	if [ "$PROJECT_CHANGED" =3D "1" ];then
+		rm -f /etc/projects /etc/projid
+		if [ -f $tmp.projects ];then
+			cat $tmp.projects > /etc/projects
+		fi
+		if [ -f $tmp.projid ];then
+			cat $tmp.projid > /etc/projid
+		fi
+	fi
+}
+
+init_files()
+{
+	local dir=3D$1
+
+	echo "### Initialize files, and their mode and ownership"
+	touch $dir/file{1,2} 2>/dev/null
+	chown $qa_user $dir/file{1,2} 2>/dev/null
+	chgrp $qa_user $dir/file{1,2} 2>/dev/null
+	chmod 777 $dir 2>/dev/null
+}
+
+cleanup_files()
+{
+	echo "### Remove all files"
+	rm -f ${1}/file{1,2,3,4,5,6}
+}
+
+test_grace()
+{
+	local type=3D$1
+	local dir=3D$2
+	local bgrace=3D$3
+	local igrace=3D$4
+
+	init_files $dir
+	echo "--- Test block quota ---"
+	# Firstly fit below block soft limit
+	echo "Write 225 blocks..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((225 * $BLOCK_SIZE))' \
+		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
+		_filter_xfs_io_error | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	# Secondly overcome block soft limit
+	echo "Rewrite 250 blocks plus 1 byte, over the block softlimit..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE + 1))' \
+		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
+		_filter_xfs_io_error | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	# Reset grace time here, make below grace time test more accurate
+	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
+	# Now sleep enough grace time and check that softlimit got enforced
+	sleep $((bgrace + 1))
+	echo "Try to write 1 one more block after grace..."
+	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' =
\
+		$dir/file2" 2>&1 >>$seqres.full | _filter_xfs_io_error | \
+		tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	echo "--- Test inode quota ---"
+	# And now the softlimit test for inodes
+	# First reset space limits so that we don't have problems with
+	# space reservations on XFS
+	setquota -$type $qa_user 0 0 3 100 $SCRATCH_MNT
+	echo "Create 2 more files, over the inode softlimit..."
+	su $qa_user -c "touch $dir/file3 $dir/file4" 2>&1 >>$seqres.full | \
+		_filter_scratch | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
+	# Reset grace time here, make below grace time test more accurate
+	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
+	# Wait and check grace time enforcement
+	sleep $((igrace+1))
+	echo "Try to create one more inode after grace..."
+	su $qa_user -c "touch $dir/file5" 2>&1 >>$seqres.full |
+		_filter_scratch | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
+	cleanup_files $dir
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_quota
+_require_user
+_require_group
+
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "usrquota,grpquota,prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+BLOCK_SIZE=3D$(_get_file_block_size $SCRATCH_MNT)
+rm -rf $SCRATCH_MNT/t
+mkdir $SCRATCH_MNT/t
+$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
+require_project
+
+echo "### Set up different grace timers to each type of quota"
+UBGRACE=3D12
+UIGRACE=3D10
+GBGRACE=3D4
+GIGRACE=3D2
+PBGRACE=3D8
+PIGRACE=3D6
+
+setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
+setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
+setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
+
+echo; echo "### Test user quota softlimit and grace time"
+test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
+echo; echo "### Test group quota softlimit and grace time"
+test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
+echo; echo "### Test project quota softlimit and grace time"
+test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/generic/594.out b/tests/generic/594.out
new file mode 100644
index 00000000..f48948d4
--- /dev/null
+++ b/tests/generic/594.out
@@ -0,0 +1,41 @@
+QA output created by 594
+### Set up different grace timers to each type of quota
+
+### Test user quota softlimit and grace time
+### Initialize files, and their mode and ownership
+--- Test block quota ---
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte, over the block softlimit...
+Try to write 1 one more block after grace...
+pwrite: Disk quota exceeded
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
+### Remove all files
+
+### Test group quota softlimit and grace time
+### Initialize files, and their mode and ownership
+--- Test block quota ---
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte, over the block softlimit...
+Try to write 1 one more block after grace...
+pwrite: Disk quota exceeded
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
+### Remove all files
+
+### Test project quota softlimit and grace time
+### Initialize files, and their mode and ownership
+--- Test block quota ---
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte, over the block softlimit...
+Try to write 1 one more block after grace...
+pwrite: Disk quota exceeded
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/t/file5': Disk quota exceeded
+### Remove all files
diff --git a/tests/generic/group b/tests/generic/group
index 637ae325..fc7ae4cd 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -596,3 +596,4 @@
 591 auto quick rw pipe splice
 592 auto quick encrypt
 593 auto quick quota
+594 auto quick quota
--=20
2.20.1

