Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B56E313E2B;
	Thu, 28 May 2026 04:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941194; cv=none; b=NntLdzcVCaIDSpZkuk68WICkjzraSViDfa4NVJpkjVLv3y9944zIsXisXf12tcDCO4GH7joTFY7xCMuXJCRs0hIMYXGb0E4LGN8jZ5zqTDl5mh0/RjPuwtmhvqM20k4lyLzdBGbaAnWr+76RGLFYWgMwU8k1qBV3v6pc16xiiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941194; c=relaxed/simple;
	bh=Vv7hsbI3vJyMGJlds7EjtZBqWR0b+qfx8M3pi8lwAjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp3JJoZUj+4DTMPt8Qqnzq+JCWO+L83YzWnsUPGvW8ggDTwjFgHWbiDDaIWsARibuhbGow124Kpg3ZNYroxujQxexg5N0ZJO/B6Bq2hOeRF03NsGBs8GTNO8cU+d82MzTch+7v35CM8+/ll26kSul6Dymi7T6LQM/wUy/8EfyqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZexiFWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZexiFWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B506E1F000E9;
	Thu, 28 May 2026 04:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941193;
	bh=7n0Nsl40Fw8pzsga6mqykSNEctGK2l6RNst2Rut9Pjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZexiFWLnDTo2Fh7TyZ/Q0NPjoqk4hrd3g2PYPWoFiN/0weGUYii5ltA+VtV6aKWO
	 IQeAuHmU2kKV2mpc/da8GWjaJN8y1QQUrfKt0GaqKfChHvND7fkX3p+8Tbyx+8wbLQ
	 ettTJI6/63vCgDjDTcy0VkDwlN/F5K3rfyQuM2hHZSWmfx/pNWKpWZB5Dv6fcvWR4d
	 CWJfOD8NjLPvRT86kM9mg4Bg6zD06BrRhTtnlGHinhvyjhoiZARGmv4UlqSA6D56t1
	 8K0utVSsjoSJygLq+5e5ZJ6pIB+tJkKaaY1XmT+Ak3dabWZb0mIzDDosofZdaTaafw
	 Mm6dEs1rt7eCQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 10/11] fstests: add _change_metadata_uuid helper
Date: Thu, 28 May 2026 12:05:41 +0800
Message-ID: <c906338d34767c8f244171e0cf87558c19cdeab5.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
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
index 5446552aed92..79be51e4da31 100644
--- a/common/rc
+++ b/common/rc
@@ -1537,6 +1537,29 @@ _scratch_resvblks()
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

