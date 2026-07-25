Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CDD2F7EEE;
	Sat, 25 Jul 2026 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965173; cv=none; b=iZCEmOXsPePXmvZbVxhgNkjEByG1wGylw1SNOkumo61m43yE6/Jkxw8tQdNEwy0gLjsitRsXcER8ZTBHFMUrtvoOZMMpxjzL6pFWd8SIWpPvxShTlHVO7e4Aez4HQLqtPY0xktDtsbPyM252jYv6jpnKx2hXFWq8rvkD8ECa+GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965173; c=relaxed/simple;
	bh=5+AP/GESRSlzYiHlcmMF6TiY2K8ki1KU15B6MYqmP1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4jzpAOSDtZUxB0j7F8PTYtbKKpzv/jfQOH7lgFGUY9qq3nlkwwx0S/rHmMWGCl7vS6CnlXCz4NO1fo5OaH12Blt4bCC/R8AFqpSb536sO39OEQSOlnjhzeeUO1/4DcgRN8u5ntSgy7cBYHqfyX5kcgkFvqT0MUM+RSSr44HO1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHYW8eX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHYW8eX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686371F000E9;
	Sat, 25 Jul 2026 07:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965172;
	bh=BkQ928IhhS+r1y6PyP6u8vBrScuRTuqSeOELrgnM3/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHYW8eX55SVMeWWNqD/xitYCLBDikNWltjyL/MM5YfJXS2SNbnoJdxdpuiF3O1Wm+
	 bPLwXJrfMQM/Tuo5c/aqeNiDANdTN+aRutBAnwdiTkPJrQmtlzbV6cblyeh6kdwuLq
	 G5PjfUJnbvaxe09etCN0+a56/afTupNrMWhVYfVuNiIWJd46ASJomhaWzCmLugaei2
	 dvsoayJUxNZ7I01SpC85OaBJxSHMNAJFKHW+qH24yImu6OjxDZVrzIscoDB3OIQXET
	 MpgHNNArxL/q33jLDoi8r/KNtGc74uR7y0ysWgq0mUEoYVW8eBmr+x7zCsM7JQ7KqD
	 ZQuWLsF5E31HQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 02/13] fstests: add _clone_mount_option() helper
Date: Sat, 25 Jul 2026 15:38:59 +0800
Message-ID: <75ceae4b427ab53c921af395854794b78d7e07a9.1784949154.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
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
index e8ff5be0c547..53e5d9d43af6 100644
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

