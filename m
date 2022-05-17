Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDD6C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 15:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244137AbiEQP5j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 11:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbiEQP5i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 11:57:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238ED2CDED;
        Tue, 17 May 2022 08:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D453FB81AA1;
        Tue, 17 May 2022 15:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D553C34116;
        Tue, 17 May 2022 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652803054;
        bh=E5nyiW2mNqvckS4RMMe/3Bus6B5xdTzrVecmNyB3Ds4=;
        h=From:To:Cc:Subject:Date:From;
        b=cjY0aghgCdjJZ5gbSDXeCeMWY1wnQFtfdU3NZjxdFQdaUU9uQxuAGOktig51fMU0X
         Z0TXgBWpNiC73MW1OEB/lRxFc9jMuv3mvrVz6TrYud2P+RmS6CAwD310g2w6NQaPl9
         eTNbdQ79T+nqQOPQLsOOCG9g+pWfdlG6PNnWYglO1UMC1UGOhxFOaxwrvToxdso1bc
         q5q/PUYTlQ0whsB08OzzjBQVxTuM4wQzv7rvNDFnKuJAmvzxUJC3Vd+tFvQzUroBlR
         ypA3NNirHrMxY7J1tz6fXuzHTihV1lHmjdE4AM4NdCmYJ3RgB3iM0Ej51O83DCuBnq
         cwGd1e1tvGjcg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH v4 1/2] generic: soft quota limits testing within grace time
Date:   Tue, 17 May 2022 23:57:30 +0800
Message-Id: <20220517155730.327564-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After soft limits are exceeded, within the grace time, fs quota
should allow more space allocation before exceeding hard limits,
even if allocating many small files.

This case can cover bc37e4fb5cac (xfs: revert "xfs: actually bump
warning counts when we send warnings"). And will help to expose
later behavior changes on this side.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

As the [PATCH 2/2] has been reviewed, so only send the 1st patch.
V4 did below changes according to [1]:
1) Add new local function filter_quota.
2) Don't filter out quota error output.

Thanks,
Zorro

[1]
https://lore.kernel.org/fstests/20220512190647.GC27174@magnolia/

 common/quota          |  48 +++++++++++++++++++
 tests/generic/999     | 107 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  34 ++++++++++++++
 3 files changed, 189 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/common/quota b/common/quota
index 7fa1a61a..67698f74 100644
--- a/common/quota
+++ b/common/quota
@@ -351,5 +351,53 @@ _qsetup()
 	echo "Using type=$type id=$id" >> $seqres.full
 }
 
+# Help to create project quota on directory, works for xfs and other fs.
+# Usage: _create_project_quota <dirname> <projid> [name]
+# Although the [name] is optional, better to specify it if need a fixed name.
+_create_project_quota()
+{
+	local prjdir=$1
+	local id=$2
+	local name=$3
+
+	if [ -z "$name" ];then
+		name=`echo $projdir | tr \/ \_`
+	fi
+
+	rm -rf $prjdir
+	mkdir $prjdir
+	chmod ugo+rwx $prjdir
+
+	if [ -f /etc/projects -a ! -f $tmp.projects.bk ];then
+		cat /etc/projects > $tmp.projects.bk
+		echo >/etc/projects
+	fi
+	if [ -f /etc/projid -a ! -f $tmp.projid.bk ];then
+		cat /etc/projid > $tmp.projid.bk
+		echo >/etc/projid
+	fi
+
+	cat >>/etc/projects <<EOF
+$id:$prjdir
+EOF
+	cat >>/etc/projid <<EOF
+$name:$id
+EOF
+	$XFS_IO_PROG -r -c "chproj $id" -c "chattr +P" $prjdir
+}
+
+# If you've called _create_project_quota, then use this function in _cleanup
+_restore_project_quota()
+{
+	if [ -f $tmp.projects.bk ];then
+		cat $tmp.projects.bk > /etc/projects && \
+			rm -f $tmp.projects.bk
+	fi
+	if [ -f $tmp.projid.bk ];then
+		cat $tmp.projid.bk > /etc/projid && \
+			rm -f $tmp.projid.bk
+	fi
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..690a289f
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,107 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Make sure filesystem quota works well, after soft limits are exceeded. The
+# fs quota should allow more space allocation before exceeding hard limits
+# and with in grace time.
+#
+# But different with other similar testing, this case tries to write many small
+# files, to cover bc37e4fb5cac (xfs: revert "xfs: actually bump warning counts
+# when we send warnings"). If there's a behavior change some day, this case
+# might help to detect that too.
+#
+. ./common/preamble
+_begin_fstest auto quota
+
+# Override the default cleanup function.
+_cleanup()
+{
+	_restore_project_quota
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/quota
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_require_quota
+_require_user
+_require_group
+
+# Make sure the kernel supports project quota
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+filter_quota()
+{
+	# Different filesystems might returns EDQUOT or ENOSPC if project
+	# quota is exceeded
+	if [ "$1" = "P" ];then
+		sed -e "s/.*: \(.*\)/Error: \1/g" \
+		    -e "s,Disk quota exceeded,EDQUOT|ENOSPC,g" \
+		    -e "s,No space left on device,EDQUOT|ENOSPC,g"
+	else
+		sed -e "s/.*: \(.*\)/Error: \1/g"
+	fi
+}
+
+exercise()
+{
+	local type=$1
+	local file=$SCRATCH_MNT/testfile
+
+	echo "= Test type=$type quota =" >>$seqres.full
+	_scratch_unmount
+	_scratch_mkfs >>$seqres.full 2>&1
+	if [ "$type" = "P" ];then
+		_scratch_enable_pquota
+	fi
+	_qmount
+	if [ "$type" = "P" ];then
+		_create_project_quota $SCRATCH_MNT/t 100 $qa_user
+		file=$SCRATCH_MNT/t/testfile
+	fi
+
+	setquota -${type} $qa_user 1M 200M 0 0 $SCRATCH_MNT
+	setquota -${type} -t 86400 86400 $SCRATCH_MNT
+	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	# Exceed the soft quota limit a bit at first
+	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 2m' -c fsync ${file}.0" >>$seqres.full
+	# Write more data more times under soft quota limit exhausted condition,
+	# but not reach hard limit. To make sure each write won't trigger EDQUOT.
+	for ((i=1; i<=100; i++));do
+		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full
+		if [ $? -ne 0 ];then
+			echo "Unexpected error (type=$type)!"
+			break
+		fi
+	done
+	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+
+	# As we've tested soft limit, now exceed the hard limit and give it a
+	# test in passing.
+	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 100m' -c fsync ${file}.hard.0" 2>&1 >/dev/null | filter_quota $type
+	for ((i=1; i<=10; i++));do
+		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.hard.$i" 2>&1 | filter_quota $type
+	done
+}
+
+_qmount_option "usrquota"
+exercise u
+_qmount_option "grpquota"
+exercise g
+_qmount_option "prjquota"
+exercise P
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..e50942f7
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,34 @@
+QA output created by 999
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: Disk quota exceeded
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
+Error: EDQUOT|ENOSPC
-- 
2.31.1

