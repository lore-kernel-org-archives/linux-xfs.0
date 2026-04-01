Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942764C6D;
	Wed,  1 Apr 2026 06:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024298; cv=none; b=MwDXdsLh2n8vfxtsl2+Z34EXbFUL4rzJ0aTPfRYttO1vwm3PjSlwPLg5UmCHRJg6+EyfDRtePpDnHNLVoJWsc9rCZwgEug7H6NcXbVfUor+MZ6rDaxjxsiiJ60kZxd0bszjye7aoeWt7sxh+ipqmGSC2I9scp2/BphKky4rWAx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024298; c=relaxed/simple;
	bh=y+55w/Q+Rkvy4jwubItIe7Gths1ZcvWIm4I0FO4J2I0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=scJ6m6tlbILQD3l60iZ7g+5jRxwyjmxuG4UmlOypWWai10VJmxsGxbwD1iMyijqXRkzeViLY8ymKF/flboEerbbHyipn6dyXzFJPvxHzFoy4iDThtxMJmud1tqVFtpluxSXs056tdzcu0+GDFXVy0ZzhsMIVDRXJIvkqRnkMHS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=CWp/uZOX; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="CWp/uZOX"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aIu3enog3U7jn1/Hlfn5lt5SeCo1XuSw89RR2uZdzLo=;
	b=CWp/uZOXerXwx6p74k01itNrxEbji5oG/ysZjHgeCuZ+lN4JVAyupv7HF3H+C1NAZhoxQAL3c
	VRHrT4m1zzHEWmYof6hH/P+7j+zE4dY6PCj15BBrEChTDPGYSyUmfGPzAhptrnM4QuIZbsWCJdv
	LzaTi7p6f1Ne0A2hpDH1150=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4flvlQ2Xjwz1K995;
	Wed,  1 Apr 2026 14:12:02 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id CD6294056A;
	Wed,  1 Apr 2026 14:18:09 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 1 Apr 2026 14:18:09 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 1 Apr
 2026 14:18:08 +0800
From: Long Li <leo.lilong@huawei.com>
To: <zlang@redhat.com>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <leo.lilong@huawei.com>,
	<yangerkun@huawei.com>
Subject: [PATCH] xfs/018: test log attr replay with zero-length attr value
Date: Wed, 1 Apr 2026 14:06:32 +0800
Message-ID: <20260401060632.2085015-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Kernel commit d72f2084e309 ("xfs: fix ri_total validation in
xlog_recover_attri_commit_pass2") fixed a bug where setting a
zero-length attribute value would cause incorrect ri_total
validation during log recovery.

Add test cases to xfs/018 to cover this scenario across attr
fork formats: extent and remote.

Using echo -n "" | attr -s is unreliable for empty values since
attr may treat stdin EOF as no value provided. Instead, handle
zero-length values explicitly in test_attr_replay() by using
attr -s -V "" when the value is empty.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 tests/xfs/018     | 26 ++++++++++++++++++++++----
 tests/xfs/018.out | 20 ++++++++++++++++++++
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/018 b/tests/xfs/018
index 9b69c9cb..3a40a85a 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -33,10 +33,18 @@ test_attr_replay()
 	# Inject error
 	_scratch_inject_error $error_tag
 
-	# Set attribute, being careful not to include the trailing newline
-	# in the attr value.
-	echo -n "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
-			    _filter_scratch
+	# Set attribute. For zero-length values, use -V "" explicitly to
+	# avoid relying on stdin EOF behavior which is undefined for empty
+	# values. Otherwise, being careful not to include the trailing
+	# newline in the attr value.
+	if [ "$flag" = "s" ] && [ -z "$attr_value" ]; then
+		${ATTR_PROG} -s "$attr_name" -V "" $testfile 2>&1 | \
+			_filter_scratch
+	else
+		echo -n "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" \
+			$testfile 2>&1 | _filter_scratch
+	fi
+
 
 	# FS should be shut down, touch will fail
 	touch $testfile 2>&1 | _filter_scratch
@@ -147,6 +155,11 @@ create_test_file inline_file3 1 $attr16
 test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
 test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
 
+# extent, zero-length value
+create_test_file extent_file0 1 $attr1k
+test_attr_replay extent_file0 "attr_name2" "" "s" "larp"
+test_attr_replay extent_file0 "attr_name2" "" "r" "larp"
+
 # extent, internal
 create_test_file extent_file1 1 $attr1k
 test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
@@ -165,6 +178,11 @@ create_test_file extent_file4 1 $attr1k
 test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
 test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
 
+# remote, zero-length value
+create_test_file remote_file0 1 $attr64k
+test_attr_replay remote_file0 "attr_name2" "" "s" "larp"
+test_attr_replay remote_file0 "attr_name2" "" "r" "larp"
+
 # remote, internal
 create_test_file remote_file1 1 $attr64k
 test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
index be1d6422..11b1c034 100644
--- a/tests/xfs/018.out
+++ b/tests/xfs/018.out
@@ -41,6 +41,16 @@ Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file0
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file0': Input/output error
+attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file0
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file0': Input/output error
+attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
+
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
@@ -71,6 +81,16 @@ Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file0
+touch: cannot touch 'SCRATCH_MNT/testdir/remote_file0': Input/output error
+attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file0
+touch: cannot touch 'SCRATCH_MNT/testdir/remote_file0': Input/output error
+attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
+
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
-- 
2.39.2

