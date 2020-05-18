Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A387C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 20:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15323207F9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 20:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="egp3LHbq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgERUAS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 16:00:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37981 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727938AbgERUAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 16:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589832015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=BtU+U/LfupdBhFjEMxUATfaI3CkvipSgCx5PjBpML/s=;
        b=egp3LHbqX2upnFYtbz66TwRiY54TYQOPYrNTLGUC73DDJJ9DH29Btc6E1z5NkRjUIEQHbn
        FcTps3+wVF/JbaEWPwXzAUbMMhLGoNXBdIzSmX+3UytTwTrL/Hl7iz3IgN39iGLeZbquOl
        TzGuKRMHBLJCQZ8lofndwKRRzznLdE0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-6Y_N6Z3UM9Oa8dXIh0J45g-1; Mon, 18 May 2020 16:00:13 -0400
X-MC-Unique: 6Y_N6Z3UM9Oa8dXIh0J45g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5121005510;
        Mon, 18 May 2020 20:00:12 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9E657526B;
        Mon, 18 May 2020 20:00:11 +0000 (UTC)
Subject: [PATCH 2/4] generic: test per-type quota softlimit enforcement
 timeout
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7102e1e3-bee6-7aa2-dce6-c0e7e0ce2983@redhat.com>
Date:   Mon, 18 May 2020 15:00:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zorro Lang <zlang@redhat.com>

Set different block & inode grace timers for user, group and project
quotas, then test softlimit enforcement timeout, make sure different
grace timers as expected.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 common/quota          |   4 +
 tests/generic/902     | 187 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/902.out |  41 +++++++++
 tests/generic/group   |   1 +
 4 files changed, 233 insertions(+)
 create mode 100755 tests/generic/902
 create mode 100644 tests/generic/902.out

diff --git a/common/quota b/common/quota
index 240e0bbc..1437d5f7 100644
--- a/common/quota
+++ b/common/quota
@@ -217,6 +217,10 @@ _qmount()
     if [ "$FSTYP" != "xfs" ]; then
         quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
         quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
+        # try to turn on project quota if it's supported
+        if quotaon --help 2>&1 | grep -q '\-\-project'; then
+            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
+        fi
     fi
     chmod ugo+rwx $SCRATCH_MNT
 }
diff --git a/tests/generic/902 b/tests/generic/902
new file mode 100755
index 00000000..03b4dcb3
--- /dev/null
+++ b/tests/generic/902
@@ -0,0 +1,187 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 902
+#
+# Test per-type(user, group and project) filesystem quota timers, make sure
+# enforcement
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
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
+	PROJECT_CHANGED=1
+}
+
+restore_project()
+{
+	if [ "$PROJECT_CHANGED" = "1" ];then
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
+	local dir=$1
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
+	local type=$1
+	local dir=$2
+	local bgrace=$3
+	local igrace=$4
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
+	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' \
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
+_require_setquota_project
+_require_quota
+_require_user
+_require_group
+
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "usrquota,grpquota,prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
+rm -rf $SCRATCH_MNT/t
+mkdir $SCRATCH_MNT/t
+$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
+require_project
+
+echo "### Set up different grace timers to each type of quota"
+UBGRACE=12
+UIGRACE=10
+GBGRACE=4
+GIGRACE=2
+PBGRACE=8
+PIGRACE=6
+
+setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
+echo; echo "### Test user quota softlimit and grace time"
+test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
+# Reset the user quota space & inode limits, avoid it affect later test
+setquota -u $qa_user 0 0 0 0 $SCRATCH_MNT
+
+setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
+echo; echo "### Test group quota softlimit and grace time"
+test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
+# Reset the group quota space & inode limits, avoid it affect later test
+setquota -g $qa_user 0 0 0 0 $SCRATCH_MNT
+
+setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
+echo; echo "### Test project quota softlimit and grace time"
+test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
+# Reset the project quota space & inode limits
+setquota -P $qa_user 0 0 0 0 $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/902.out b/tests/generic/902.out
new file mode 100644
index 00000000..6e15eaeb
--- /dev/null
+++ b/tests/generic/902.out
@@ -0,0 +1,41 @@
+QA output created by 902
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
index 50c340a6..66e71a70 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -601,3 +601,4 @@
 596 auto quick
 900 auto quick perms
 901 auto quick perms
+902 auto quick quota
-- 
2.17.0


