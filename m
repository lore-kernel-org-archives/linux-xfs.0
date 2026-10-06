Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8013E3EEADE;
	Tue,  6 Oct 2026 08:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277001; cv=none; b=GPrF6ZF+Ery6VhyZ+NzBoI9OxyknkL9yET5vy4/umXZht0566M5Tge0dIulMO9eXe4VoFaTqxGnwoP2OLBawxV64ko/BnOFVSzHK4vFoOYcTKoNspzPdOxAtmGiIgXOOw00tm9zS7aRByjCOBCikOtSQbm3AVeHF6g4bhJ4Cxjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277001; c=relaxed/simple;
	bh=EJgsNPQbxlMC7e1ILc+3XrGIcP1GhU4+XzueYnDvaQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI5bm59k/GnwZH1ddNKsGKQVHblqCIc2BxfFMHsjJuZd5vjRNGsih0My5M+JEjdQYHVD7pD+0yTwFkswGQoeS8rcOL0fMxL8VNRd9mikRPK6E5cO8Ypfm+j0guYzWX9/qrm8bK/LkDYkI4CEPPQWbMdv3LOKJKBT9XIX773cfeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlgN13zA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlgN13zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BA01F00893;
	Tue,  6 Oct 2026 08:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277000;
	bh=tZ5sOykvgVOXYk7mwUNscwKSpK5HqPfMQs3F9fX2Kzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlgN13zAGyCw+Rg8Wp7I/TqM7Grrt/GcdxWrf4jTiyq6YWBEDPB2gIsQPyPVnqrUm
	 J7ut3Etaaee/eUMOJG0pRBUyVPe4/FIubY3/R6WTa9OY0+SxkKfTsZ9ML7oukP95H+
	 CBa6m0igBeZzsZ5d7PHbdB7jsrI40+esKZ6mmWoWdhL3qhZwyYSw2KCNkGkpYRGM53
	 9T7QdsmjZw76TPQCXFuY+2DWwJYq9zBOQSvSJLtolSg6X/zhvCcH/JeUAKO88iJxm3
	 k/m6dcZuPCw/J8m7hquX22A35VAX9DTPIQWP0XgSE7+Vp1e1YksAuRsTsKS7xGP2TU
	 bzzuzrxjPdEHw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 13/21] fstests: introduce _require_security_ima() helper
Date: Tue,  6 Oct 2026 16:55:39 +0800
Message-ID: <029bbc3a840e7681e597c752f4482b0140c312cc.1791272793.git.asj@kernel.org>
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

Verifying FSID handling in cloned filesystems with Integrity Measurement
Architecture (IMA) requires active IMA policy configuration.

Introduce _require_security_ima() to common/rc to ensure securityfs
is available and the IMA policy file is present and writable, skipping
tests with _notrun when unsupported.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/common/rc b/common/rc
index a11235ec03b8..4ae3c74a52cf 100644
--- a/common/rc
+++ b/common/rc
@@ -6354,6 +6354,29 @@ _max() {
 	echo $ret
 }
 
+# Check if the requirements for Integrity Measurement Architecture (IMA) testing are met:
+# 1. securityfs is enabled in the kernel.
+# 2. securityfs is rw-mountable with the IMA policy loadable.
+_require_security_ima()
+{
+	[ -d /sys/kernel/security ] || _notrun "kernel doesn't support securityfs"
+
+	# securityfs may not be mounted yet on the host; mount it read-only
+	# in a scratch location just to probe for IMA support.
+	local se_mnt="${TEST_MNT}/${seq}/se_mnt"
+	local has_ima=1
+
+	mkdir -p "${se_mnt}"
+	_mount -t securityfs securityfs "${se_mnt}" 2>/dev/null || _notrun "cannot mount securityfs"
+
+	[ -d "${se_mnt}/ima" ] || has_ima=0
+	[ -w "${se_mnt}/ima/policy" ] || _notrun "IMA policy not writable"
+
+	_unmount "${se_mnt}"
+
+	[ $has_ima -eq 1 ] || _notrun "kernel doesn't support IMA"
+}
+
 # Due to reasons explained in fio commit 40f1fc11d, fio version between
 # v3.33 and v3.38 have atomic= feature but it is a no-op and doesn't do
 # RWF_ATOMIC write. Hence, use this helper to ensure fio has the
-- 
2.43.0

