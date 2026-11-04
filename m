Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818081;
	b=a0i9H1ydTHCsnKFSIaNINOwOfl+oV6MvYTgFf+fQPG8zJcr3ubpb/tFRBUxx8Cy2KWOX
	 b+7ONR0BrDNZM/LqHbtZWr7u8n0fCrueyXeYrhRAY4BcZ7hfBIX9ABKxrnsNKMH2Fz/E+
	 QcuOnBxF9gxeYYcuJlTbjQTVFGEmGMO/wouV0GkM/GCYrfbweDdvVa2ABpeUSZWpkM4xw
	 9hKjRDkSWaWwzdhQNERtDMISaqCSYmZNucAFxVhsPdyPn2BqXBq8RQCE/mq9AlI0N87wb
	 s8/BBQRMgXKi9wx4N0cGrSmHwWt3bli02ugSDt02kHhUCX7z91+ny0IoJa/BdrJWKMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HakPAG9j1ClAQnTmttqtC6myrrtGjQA/V5DPMytNSZg=;
	b=zpbywgCxPQW4R6tiRHtstCDUryDLAV35o1x/N04i+VRlYiuy1WUOvVndx/EIQYbXkeh+
	 Q1DzLXrnZtNiQ5XPteW2BTG7cb6BWi64nMofhd+vi2Hv7Hsifxeqm4mkj+TMU56XGGkem
	 ZsAIsOGFFXxEsWb9UggD0dTIEiNz81GNGZbBI70VBTYL4iCTdelDbarm6kK9VrEC2KTwe
	 kAeUGuV1y6ewqqOLjLfZwLKjmNRk0pNIZcn2ENoKVCEmlx1cye6tjGlQjeGzzbkVSqB+N
	 YDLZpQT0OLYCqdS+S/mJeTSXS5/Y4nWPu0g/r2kC4i9cu9iMfPOAdJpwTCaRYdKcNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T52cFluA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D56606A32D;
	Wed,  4 Nov 2026 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T52cFluA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015EE1F00919;
	Wed,  4 Nov 2026 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793818080;
	bh=HakPAG9j1ClAQnTmttqtC6myrrtGjQA/V5DPMytNSZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T52cFluAEknQYOcw57Maj4kZ5wsJ+GjMaDuCUspJBGDXT+5AdVjnwfhCZjqLBsmhb
	 cwyxShvBpzuSDG4ZPITW9b+5JYTce9i00mgW7GzxB3Ys7mlNL9dxxEl6vAai6GVrJt
	 jOygQ0+bZkTyL1xmRWq1t4h3BMsROo4XCy4hcSXpEAawznizE198T8eYc2QEHKMauv
	 Qlt+B21geX3nvevQhoHQrkZ/VPds+JfIKdviWLuKfbTO0gaYBhzd85Rm4zbIN1VjA9
	 +RB1ZOui19oPDmRJXHHoGbjhPeRM+LtZfSCZoSkaC/2mbNyk3XGBzqiLY1W4s4jRKe
	 6R7GQ5wzu0Y1w==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 4/6] common/rc: add helpers for /sys/fs/$FSTYP/features/
Date: Thu,  5 Nov 2026 02:47:34 +0800
Message-ID: <20261104184736.1564283-5-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104184736.1564283-1-zlang@kernel.org>
References: <20261104184736.1564283-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

More and more test cases depend on /sys/fs/$FSTYP/features/ entries.
To improve code structure and maintainability, introduce the
 - _has_fs_sysfs_feature_attr
 - _get_fs_sysfs_feature_attr
 - _require_fs_sysfs_feature_attr
helpers.

Signed-off-by: Zorro Lang <zlang@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/common/rc b/common/rc
index 036b75d4..35f5d21e 100644
--- a/common/rc
+++ b/common/rc
@@ -5587,6 +5587,58 @@ _require_scratch_sysfs_dev_attr()
 	_require_fs_sysfs_dev_attr $SCRATCH_DEV "$1"
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
2.56.0

