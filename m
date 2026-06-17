Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA12939FCCD;
	Wed, 17 Jun 2026 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695256; cv=none; b=AXsm+Ts6hh9W+vwIB7lX/xAU9H1T+eC7TQXsmhV3VzwHIJyDv202T5frSXU9119rtP47xKFMFB7mOKesTi8/1MY2EHV3RMQsgnB2jpmdJLESWy46WzrFTiTE8DlUTRPs7XzedKkmYuauMlI0eN+pzlNd3jsfFjP+zX0fIEAP2+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695256; c=relaxed/simple;
	bh=0HFzIbxXaQj8Dc96akBnQcHWQgK/0N7qVXxloPqVZGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO5o+QPmvqlyk+D0OuJ8OgWQaSM6ZvRVIDdasWe1TpEryC7v/J6yjZqku5n0nYHxm1toZo38SVUKaxPgVTfmEJCEndZjxlwJDkX8qjVojKr/CjogRAGACqEWzLRhtJOaj3oSNOWNRZlsll+lYr6qn91EZz1GAv3Xt1+wKU28yb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6d5l7vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6d5l7vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5BF1F00A3D;
	Wed, 17 Jun 2026 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695254;
	bh=KaGzvlAFuLvfNXX7hkCbgPcxpzUYNoQuvBwpwaOK3Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6d5l7vmxUw9p7rL2GJTP9ljnnIua9w9nhHSTMdXOAniQhpgGQDMLbDj+U1RVnN3y
	 ho9xywoFmsInya0CoQE5jZJf0Op8xb4evzxXrHwV+toj9Rk0f7wbqij+0v2atZIYyp
	 LpGl/8YzQYXh3FIXB8mMvFcDvUNV/uQLuJQJz3XP0QXHoH4vCvMDS28Vsx5GSnun6H
	 bsXA4ag/T7Gy6YWrht1uwVl8l+YfoG3U++0mxjeuU8vOLnhfSbV4sWyhl/LzL+tMBm
	 vzHrbpLqnJOImnaN4q9DYKtM+lz4JMVozrB395RVUiqjQHNTlf+fqW8jLend4Ji4nq
	 4oixQFp8eac6Q==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 02/11] fstests: add _clone_mount_option() helper
Date: Wed, 17 Jun 2026 19:20:29 +0800
Message-ID: <0237f38f9bd3115171e84d15444e00e00898a0e8.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781694879.git.asj@kernel.org>
References: <cover.1781694879.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds _clone_mount_option() helper function to handle filesystem-specific
requirements for mounting cloned devices. Abstract the need for -o nouuid
on XFS.

Signed-off-by: Anand Jain <asj@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/common/rc b/common/rc
index d7e3e0bdfb1e..968ba33686f3 100644
--- a/common/rc
+++ b/common/rc
@@ -414,6 +414,19 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+# Return filesystem-specific mount options required for mounting clone/snapshot
+# devices.
+_clone_mount_option()
+{
+	case "$FSTYP" in
+	xfs)
+		# Allow mounting a duplicate filesystem on the same host
+		echo "-o nouuid"
+		;;
+	*)
+	esac
+}
+
 _supports_filetype()
 {
 	local dir=$1
-- 
2.43.0

