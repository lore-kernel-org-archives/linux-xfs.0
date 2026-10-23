Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787497;
	b=387vZt6IAGZCS91O2wN9/JaF+D1OHnEItlo3y/pDQ0vkXCqXyul+9g1JwXsKp834Nw5o
	 QyYjLEsQraDCavGrW4dDwXZ7M0kXgxCvhRngddISMod2gmJAwvlktyKEHeJGMUdjbqXgP
	 tkMpwKtXUdHs56BO9lsmj2r1Aovc00yWVVpn87mJYbBUNj0R2kO5nOv4zD4Q5t4HBOBGF
	 8RAHhWWnbC3PqbURpw9Dy118x4TOob/lzmtV5Nr+x5oy1BqkbApeqNpuW1nPI9PHlm/bW
	 WRQtQos8HyvCnFM8RSWZeTZBXuXV2MYrygWnmR6AvwsALgMXBQ3MwLv9qEGBr9huOag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=G/9/wRrx7x7dIPSfgHcgsNOFU2IbKvGI38f96L0Cc1I=;
	b=Tini0ovLdkatKI2EkFGp9IlgiFHeVlPlm9uKEwaoohFiytrV8UU9WAo7k7vsIhvZHnkj
	 jWV0hWkM5uW43J/OdRF7c74Az8pUmDLqjmBCFOM73AOL9cB9nWEKw4AI+PyCVSqhsi5V7
	 bgfSawsuKaOE7LufqWcwF09KBVRD6mc0PFb7CmBGrsOoYibazpWViGOF1gQpplECmIgTA
	 YUGc7qrS9Cgvh2UZ63ksKWNjYmnI1lEuTEAtMw2xwwFyvsidt6j9m7+ryA3bGN3R8zS7x
	 QazR+vXbEJJF9eLkoKSPZ1ycmA0aDJ3N41h1Bf+0m7WCmSA4NAGWjTVueBBR1Bdsvaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j1Tx8XKl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ACF606A31E;
	Fri, 23 Oct 2026 20:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j1Tx8XKl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033191F01825;
	Fri, 23 Oct 2026 20:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787496;
	bh=G/9/wRrx7x7dIPSfgHcgsNOFU2IbKvGI38f96L0Cc1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1Tx8XKlxJMkAXPvi4mNoxXug5sabrL1B1Nd5C6vC6lr9yXCC472rRNRjbfQJAC2S
	 DC76mfpddpGHoh2c0dM++2TUeQ8Tx//KDpwF752yKDlRQQXk23fcqnQWM7UQQwDenT
	 m5j7ighX4bpDUPbaXF+dQnHNgD1rSR6Ov2RBuCe246Sla52A7kYDHSHIeQOk8gadL5
	 3vdLjCedlS91MwRnXspl4SeZedbpxDv4p3njARWfJcAEIK1crM6zOc4NuNfHHBzKle
	 02em7aFMBC26DG9K/yLc2WGYx3ieWTkoN1vTK+4FolxidSS/fZW/xeceVzZ7TQjV3Q
	 Rn6IWg6zHfaEQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 4/6] common/rc: add helpers for /sys/fs/$FSTYP/features/
Date: Sat, 24 Oct 2026 04:31:12 +0800
Message-ID: <20261023203114.1655019-5-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023203114.1655019-1-zlang@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
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
---
 common/rc | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/common/rc b/common/rc
index bcecaaeb..67a64a09 100644
--- a/common/rc
+++ b/common/rc
@@ -5571,6 +5571,58 @@ _require_fs_sysfs_dev_attr()
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

