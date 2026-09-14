Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12A2E7165;
	Mon, 14 Sep 2026 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406738; cv=none; b=mb4zQn7t9vhaeCwHJysav1oLrLNVx9cSNxdUdfAYSKAOpFErPPhl04WDaaZ0lpio7f8W0T1MOvaZnFiZqFxiYqvEVIaZkkL9rzCxr8wzHs6jLbgLUmaRuKZmOdEW8yKmTFySVr9cNfTXqXUAR7pyICrXKg5oeyku0jwnw/JpjiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406738; c=relaxed/simple;
	bh=Zf3691MswbAZfWfxLo1cFo4lOuGeVXoP9FgSbKL4Hkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhCLBI1Kt7y4vL/dz/Z9FmsbdUyh4Md3WJD/A0d6qtLA4+YWizR72ObGWtzL0jnLiX+PWYF03CAgbkJvJc6/lBSdZRouOUxFo8RQKwUxCetBmqnAzMBzpfCloabhKjZHzuief5kaXZOWY4Yy+5Ahi4RP4Y7IaMKCrSNy8NBYnbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8SoN8ZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8SoN8ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4068F1F000FF;
	Mon, 14 Sep 2026 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406737;
	bh=9PVgKiXjGpFIZee+OkaSaw39Yf1qRKw7H+0w9BHBi3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8SoN8ZVVgPMSGnhgG+hwi1x5TS5FEKP5NCLFLsHjYQcDa/S6RPUMBFV+YRD5EQZX
	 gPuocZH6v7E6K2xmClnBvou2ftA5QuRLEU9bwUA3Pmv1cgeLZDzCq5s5i/+3NtHcoD
	 jzFZhiX+B42ud6Rk0hfhbDhLRYkjZSt2ukE3qS0h3CRG/K64Ah1dbGcJDuLItVqpow
	 R041V2adELIwITeNVbolvYFWYtk9C38n3lvdwLAnwCa1SiyL+zC3Gq41IYNXgBoZ4/
	 V4ykiQoEp8/4c7b275EcVNNAP7QuPZB/aiiuRgLSt9iK/E1HaODO3hF2VDovcqRtDO
	 RiI0K3enAQ5Jw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 3/5] common/rc: add helpers for /sys/fs/$FSTYP/features/
Date: Tue, 15 Sep 2026 01:25:07 +0800
Message-ID: <20260914172509.3799016-4-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914172509.3799016-1-zlang@kernel.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

More and more test cases depend on /sys/fs/$FSTYP/features/ entries.
To improve code structure and maintainability, introduce the
 - _has_fs_sysfs_feature_attr
 - _get_fs_sysfs_feature_attr
 - _require_fs_sysfs_feature_attr
helpers.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/rc | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/common/rc b/common/rc
index b99e28a5..439ca0d5 100644
--- a/common/rc
+++ b/common/rc
@@ -5535,6 +5535,58 @@ _require_fs_sysfs_dev_attr()
 	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
 }
 
+# Print the content of /sys/fs/$FSTYP/features/$ATTR
+#
+# Only one argument is needed:
+#  - attr: path name under /sys/fs/$FSTYP/features
+#
+# Usage example:
+#   _get_fs_sysfs_feature_attr send_stream_version
+_get_fs_sysfs_feature_attr()
+{
+	local attr=$1
+
+	if [ -z "$attr" ];then
+		_fail "Usage: _get_fs_sysfs_feature_attr <attr>"
+	fi
+
+	cat /sys/fs/${FSTYP}/features/${attr}
+}
+
+# Test for the existence of a sysfs entry at /sys/fs/$FSTYP/features/$ATTR
+#
+# Only one argument is needed:
+#  - attr: path name under /sys/fs/$FSTYP/features
+#
+# Usage example:
+#   _has_fs_sysfs_feature_attr raid56
+_has_fs_sysfs_feature_attr()
+{
+	local attr=$1
+
+	if [ -z "$attr" ];then
+		_fail "Usage: _has_fs_sysfs_feature_attr <attr>"
+	fi
+
+	test -e /sys/fs/${FSTYP}/features/${attr}
+}
+
+# Require the existence of a sysfs entry at /sys/fs/$FSTYP/features/$ATTR
+#
+# Only one argument is needed:
+#  - attr: path name under /sys/fs/$FSTYP/features
+#
+# Usage example:
+#   _require_fs_sysfs_feature_attr raid56
+_require_fs_sysfs_feature_attr()
+{
+	local attr=$1
+
+	_has_fs_sysfs_feature_attr "$attr" && return
+
+	_notrun "This test requires /sys/fs/${FSTYP}/features/${attr}"
+}
+
 # Generic test for specific filesystem feature.
 # Currently only implemented to test overlayfs features.
 _require_scratch_feature()
-- 
2.55.0

