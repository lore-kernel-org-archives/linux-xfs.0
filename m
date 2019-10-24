Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E68CCA9EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 00:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DB8D2084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 00:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gmZF2i8o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404828AbfJXAeB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 20:34:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbfJXAeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 20:34:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O0Xxak139370;
        Thu, 24 Oct 2019 00:33:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Yp88jRNHDAFa6HkOyrP3/IicedvCpq9E5P+Iukyemnk=;
 b=gmZF2i8ooE+O4wgzUDzTHmGGjrCcetbyo5y5pyokvSCv/PxKO6HA68KZB46DReS7RPSX
 18Q+jLL+YqgTA0UFU8xD/XMM3QbBvKwvbXjcBYf/TI7Lu9T0NCqW61GTjd9VQGmpZfFf
 gTbxq6baSnNaavK0GCN9VUnfuAhazLe5HB5J+5ghWycynxCaDz3TpS7EA00JivXSPp9g
 kkzPu0t1YsD4dIzS37FnStb/MlymVBfWo0dxiX3SwjIU7Q0CDYSWzObiIpbMumHJnstW
 vvu67Mrzbf4T74hENun46gR8qWRAZi8JKRjIzJyE8FxUpb0j5pg28LTep4oRNOvNTKmx IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtrn5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 00:33:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O0XRO0074495;
        Thu, 24 Oct 2019 00:33:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vtsk36d51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 00:33:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9O0XwlI011591;
        Thu, 24 Oct 2019 00:33:58 GMT
Received: from localhost (/10.159.148.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 17:33:57 -0700
Date:   Wed, 23 Oct 2019 17:33:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 3/2] generic: check storing and re-reading timestamps
Message-ID: <20191024003356.GE6706@magnolia>
References: <157170897992.1172383.2128928990011336996.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157170897992.1172383.2128928990011336996.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a test to make sure that we can store and retrieve timestamps
without corrupting them.  Note that this is likely to fail on older
kernels that do not clamp timestamps properly, though at least in my
book that counts as corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/721     |  102 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/721.out |    1 
 tests/generic/group   |    1 
 3 files changed, 104 insertions(+)
 create mode 100755 tests/generic/721
 create mode 100644 tests/generic/721.out

diff --git a/tests/generic/721 b/tests/generic/721
new file mode 100755
index 00000000..711d3c5f
--- /dev/null
+++ b/tests/generic/721
@@ -0,0 +1,102 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 721
+#
+# Make sure we can store and retrieve timestamps on the extremes of the
+# supported date ranges.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs > $seqres.full
+_scratch_mount
+
+# Does our userspace even support large dates?
+test_bigdates=1
+touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
+
+# And can we do statx?
+test_statx=1
+($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
+ $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
+	test_statx=0
+
+echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
+echo "xfs_io support of statx: $test_statx" >> $seqres.full
+
+touchme() {
+	local arg="$1"
+	local name="$2"
+
+	touch -d "$arg" $SCRATCH_MNT/t_$name
+}
+
+report() {
+	local files=($SCRATCH_MNT $SCRATCH_MNT/t_*)
+	TZ=UTC stat -c '%y %Y %n' "${files[@]}"
+	test $test_statx -gt 0 && \
+		$XFS_IO_PROG -c 'statx -r' "${files[@]}" | grep 'stat.mtime'
+}
+
+# -2147483648 (S32_MIN, or classic unix min)
+touchme 'Dec 13 20:45:52 UTC 1901' s32_min
+
+# 2147483647 (S32_MAX, or classic unix max)
+touchme 'Jan 19 03:14:07 UTC 2038' s32_max
+
+if [ $test_bigdates -gt 0 ]; then
+	# 15032385535 (u34 time if you start from s32_min, like ext4 does)
+	touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
+
+	# 17179869183 (u34 time if you start from the unix epoch)
+	touchme 'May 30 01:53:03 UTC 2514' u34_max
+
+	# Latest date we can synthesize(?)
+	touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
+
+	# Earliest date we can synthesize(?)
+	touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
+fi
+
+# Query timestamps from incore
+echo before >> $seqres.full
+report > $tmp.times0
+cat $tmp.times0 >> $seqres.full
+
+_scratch_cycle_mount
+
+# Query timestamps from disk
+echo after >> $seqres.full
+report > $tmp.times1
+cat $tmp.times1 >> $seqres.full
+
+# Did they match?
+cmp -s $tmp.times0 $tmp.times1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/721.out b/tests/generic/721.out
new file mode 100644
index 00000000..087decb5
--- /dev/null
+++ b/tests/generic/721.out
@@ -0,0 +1 @@
+QA output created by 721
diff --git a/tests/generic/group b/tests/generic/group
index 6f9c4e12..a49d4b11 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -581,3 +581,4 @@
 576 auto quick verity encrypt
 577 auto quick verity
 578 auto quick rw clone
+721 auto quick atime
