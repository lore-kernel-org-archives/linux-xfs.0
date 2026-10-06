Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9F3E4C94;
	Tue,  6 Oct 2026 08:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277009; cv=none; b=QL2Hwv9xsPdr7nblAjFedbq3jL9OqWyD4mrAA2MNTDPq6/pAt1z3smcWjPZ3Q8g/KsipxkpCJHL9r4W3g3xqSmMmEv8mRW9vP3BjrX6hfWHKnNULkEqd6AMHiIcB8GtHMLB90TDE14aWJNCKRWhJPyji+cVPnEIFqdGRV/7wQso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277009; c=relaxed/simple;
	bh=5uosXh6uxYUIG49Gb9ouYcwYTZJ/4+MXXmVZwNtg+cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/7g0ZNQX15QKnePqNOhWLlTSsAYJHyQHGw1EAV8SAvDLgrVh8vR8ezfH3Swd23eIzeswLJcorLqG9aKNYT63jjnS4A/g18Jlob5v8XTpLi/IGwFzHNYAvDBL6sUkcYAtbZjVkf2qrY3+hFZZiK5SKX8Yh/z6if/fmRMqNyo+B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIyJTUM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIyJTUM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16341F00893;
	Tue,  6 Oct 2026 08:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277008;
	bh=yTPg7WgNbGqn4E0eJg50IlBitUMXBRXH6jwA/Ev1yYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIyJTUM5V6A2hzrluI06O2pv8CMghQkGaLA4/m/bkadkBdjQ5IQPOca6zasX2hjUB
	 OeFF9xSwFHM00CFx0rX5NVsEvyoVOxoOwwHsh1B6tx5JoxIXNNv3iqaDQ3fxoY+Kxf
	 wQT53h0NwCBpUZ5FQAr3CNryW3C6L0hDWGjG3pjq1Su1XErfffrRuC/RlgIxPlOrPA
	 IqCotloCa93t96LQj+3su8eopYkorHlyPd6ZBEMdxg1D4WlPGV1P26TLbz2RBBWuVE
	 pNMshtn6Ltbm+Zg4kmtMgavo22KGohl9KWGnLyY1SyXY6rYJliES9SUNppz/uDLVzC
	 vdlJL0fItfjqw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 17/21] fstests: add _change_metadata_uuid helper
Date: Tue,  6 Oct 2026 16:55:43 +0800
Message-ID: <8aebfe6024e971c967497284c702862f16cbe570.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
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
 common/rc | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/common/rc b/common/rc
index bc0522dbcdd3..7feeec04a500 100644
--- a/common/rc
+++ b/common/rc
@@ -1577,6 +1577,23 @@ _scratch_resvblks()
 	esac
 }
 
+# Change the metadata UUID of the given device to a newly generated one.
+# Args:
+#   $1: Block device path to modify.
+_change_metadata_uuid()
+{
+	local dev=$1
+
+	case $FSTYP in
+	xfs)
+		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
+		;;
+	btrfs)
+		$BTRFS_TUNE_PROG -m $dev
+		;;
+	esac
+}
+
 # Create a small loop image, run an optional tuning function ($2) on it,
 # clone it, and attach both to loop devices, returned in ($1).
 # Args:
-- 
2.43.0

