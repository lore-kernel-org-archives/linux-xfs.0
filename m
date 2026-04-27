Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E5B30BF6B;
	Mon, 27 Apr 2026 10:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285199; cv=none; b=XmJVGPQKifk46Xar6oJxTQ396u6OKDqWYniDpIRSGjgkwrywSamMEdO4EGgUXemcwoo7O8cSUAdYpSnLjIRyu5uxE/MJZ4zadBp4SUwSlHM7/Pti/bjMYqYqQ0+vBttfZ7ZuMAT+4bljo2hKwxVOs5ZgGhJFkgXazEXfwSJ+2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285199; c=relaxed/simple;
	bh=b6WbYeUbkYBMoyD1j7ZMWhWOpAndXEFAukY1wASc+3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbIXsHFjHbMQIFq7OLvDDzo4nimTSyUEtyq17wuz2vzecj0Uk7uofSFjdrdv5ftYzUsfhLL4H03S8re1D1z4s7z6TIU8R4AXV6M7/jCI810eISlA6jVG8O0EI8aPBKiZVJBFen+uKWud35avYWzcVa7RvWi1ceUBrXDuTukQERE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cldkCwB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cldkCwB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1222BC2BCB4;
	Mon, 27 Apr 2026 10:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285199;
	bh=b6WbYeUbkYBMoyD1j7ZMWhWOpAndXEFAukY1wASc+3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cldkCwB74NsyKVXfDEJzE6PJuT1TkNYu7RNHGnGEgqY9O29Bcs1AYOHcZVxWvFlt/
	 rjb36wFOUrSbq2ZMklydEXboCbGxs7WNYzBeAi/D+uKZvY00GGAx3EpLyYZdN/HtGB
	 K+NNBY7Wm8d5oGR6C7hkA2pcu9uVdtw4Uwyeuq6NgC+mWE+jlajDw2I354G/hqZeg9
	 feqwci1ERCI8ukoAx44Xgi/olTsCfrcjTnbCzrXDsF1yt9DZ7OYrm5z9Iqs/uxDXH7
	 qgtpnv9VWObJQ6X+WHXq3TgMVB89FrLrnt+B2LB8UHwk32T6AYgvTHoMWrDyTGdZRO
	 VVvg+62APvT5A==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 2/9] fstests: add _clone_mount_option() helper
Date: Mon, 27 Apr 2026 18:19:34 +0800
Message-ID: <fdb1d2fd48f6be71f863a6c1e07a19655c499d61.1777281778.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777281778.git.asj@kernel.org>
References: <cover.1777281778.git.asj@kernel.org>
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
---
 common/rc | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/common/rc b/common/rc
index 0e7b7eb1d98f..2d28e174f605 100644
--- a/common/rc
+++ b/common/rc
@@ -397,6 +397,20 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+_clone_mount_option()
+{
+	local mount_opts=""
+
+	case "$FSTYP" in
+	xfs)
+		mount_opts="-o nouuid"
+		;;
+	*)
+	esac
+
+	echo $mount_opts
+}
+
 _supports_filetype()
 {
 	local dir=$1
-- 
2.43.0

