Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947C63126B9;
	Sat, 25 Jul 2026 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965218; cv=none; b=Lri+1asblA63r1YEMf2HdGy0z2JGGYtEevNdhe6Xq7/meA283ldjmFsTJ1wt7eN5iEryRArYVoe3+/eBBGEpDLxzOuwsZnQFtspfkV4fgZaUvvjxZNL2HEahzLBg70ArCvHrl9NFQg4esTD9SRt3pd/gcoQtn9ymPnOn8voXDtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965218; c=relaxed/simple;
	bh=BYDLbjAQqW5drO92NUi1mOXfWtHCoczMQO6AW7ugG9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlDfOg96EGdFpuTdV8A0EsZu04KSjQ5DTGn3fKaSoqrThv6wkulowvY42zNoUZ494rpu5RYkEMkmGvznVrxpiyYvom+gUPr4Rg7N52n1rM2zfd89Zm9AMey7GWkXBrWntE8mmFrfM6Z7EDYhCgWEtiwXcZdl0NiIS0+JtTTVXsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlB1QwfV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlB1QwfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E10D1F00A3A;
	Sat, 25 Jul 2026 07:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965217;
	bh=zh0uytEMqjA2I2FeFvX8PcZzuNURLo9sVtjieXsXpLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlB1QwfVTeXeBpH//kROjTjFriZR1UNQ/vKmNoeG3UONqbOcnHhIYL/5FU214KHt7
	 S0NP6lbSTVLmG9YTgS3rHSlDfZIPvCfzyoYHLZP8DBtmP/8CLOzLVqdvKvpLcYZi81
	 1Ldiavbf+We6h59ZwGDJy5XuyuQGPPgDoSsJFxnkq20xM3aOWC11+4OaSS0VnTGXhC
	 +qyAksbw/4xMnh2eF0m4P7hWXwRIBVBVL7Ds4nmWGDcyGHf+7Xyj+eJfctciXKMRlu
	 MEShUTGWp6eNsexQTfqYYX2ToLhFcwUgZGGe+7k6Z/aTGhWSfKylr4f0rT/Eo4Wp62
	 kplQkZdEkG6lw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 12/13] fstests: add _change_metadata_uuid helper
Date: Sat, 25 Jul 2026 15:39:09 +0800
Message-ID: <8d69567fb5700c5a4075509bd7272d02ce9ba4f5.1784949155.git.asj@kernel.org>
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

_change_metadata_uuid changes the UUID of the golden filesystem before it
is cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/common/rc b/common/rc
index f73251365a60..45cf9360ba73 100644
--- a/common/rc
+++ b/common/rc
@@ -1533,6 +1533,29 @@ _scratch_resvblks()
 	esac
 }
 
+# Change the metadata UUID of the given device to a newly generated one.
+# Args:
+#   $1: Block device path to modify.
+_change_metadata_uuid()
+{
+	local temp_mnt=$TEST_DIR/${seq}_mnt
+	local dev=$1
+
+	case $FSTYP in
+	xfs)
+		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
+		;;
+	btrfs)
+		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
+		$BTRFS_TUNE_PROG -m $dev
+		;;
+	*)
+		_notrun "Require filesystem with metadata_uuid feature"
+		;;
+	esac
+}
+
 # Create a small loop image, run an optional tuning function ($2) on it,
 # clone it, and attach both to loop devices, returned in ($1).
 # Args:
-- 
2.43.0

