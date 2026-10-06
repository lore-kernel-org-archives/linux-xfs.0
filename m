Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5103DEAFA;
	Tue,  6 Oct 2026 08:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276982; cv=none; b=KmYqfavmnb7GWmZn2NNf6cnVfkSumw4lz/ggxkm6KE+YN8x0guDypRw6u6VNcrPqSu8eLrLTAWy2ckZG5YU6kqdihXHNH5xt55zr/Y6uYnltMTfTQxKE8R2NsrnJffJ7D/uIQhI4ezIx3jHSPQZPDIhyGXIE/tTzYxkMywMwhzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276982; c=relaxed/simple;
	bh=KM+vDkF2nR+GM3B2I38mkQQHlH89HXlubxdoXyrRMEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGqzxFK+VcgGUWfLGZXdYtTMVxtK6rwxGxbY5IUExfMveHdzCxnaP9b2mfAcRh4QuohgHfpxAtOj6eM1qqc8vctIMaLHnvl9vsOppu+rU8Cy4i9VIwhhILH/zH/sPxrAYYfuRSOOyT/WyauAk7tl663R4YFPQvAF4juHN8060/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngJ94jZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngJ94jZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FB91F000FF;
	Tue,  6 Oct 2026 08:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276980;
	bh=j7fMyiLEWqhuLHjASayvGfGl8dCR3auJbWrfl9uBIzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngJ94jZZffDsv40ilSFX3FfkI92qSiXNwI1NewFk44Vt0w8jMMkOSU9/O5YNiHNa/
	 Eo9J5TsvDCi8UXloNPS6PYK4Aus0RQc6ovo1LZLFYMopKCVoCaXTN/2A5ytuOKrFoI
	 wtFMQ14K8CA2ZdYzkhbLH7+VlqjK/j0EPypnaHQD6kKm2tK2crKifrHNOOE+j9dbJD
	 qjhzLKYL0XveRFR2UfGy0zHgEM4YbN5yD51telNy2GSyjNNzlOdnzdxNOEI1aeBGNk
	 WkpJ42J2gs+wDKAXKDKie7OwfenoYXSxXpTcS6lU0DJ0XPoIw51LpzJPnHTLpewSmw
	 oWCeMCAACD7Hw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 03/21] fstests: add _clone_mount_options() helper
Date: Tue,  6 Oct 2026 16:55:29 +0800
Message-ID: <ff8994fe7511fb1ed3b08bf7830c53168c813713.1791272793.git.asj@kernel.org>
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

Adds _clone_mount_options() helper function to handle filesystem-specific
requirements for mounting cloned devices. Abstract the need for -o nouuid
on XFS.

Signed-off-by: Anand Jain <asj@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/common/rc b/common/rc
index f2ab4bc491af..b9481ba8ab55 100644
--- a/common/rc
+++ b/common/rc
@@ -428,6 +428,19 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+# Return filesystem-specific mount options required for mounting clone/snapshot
+# devices.
+_clone_mount_options()
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

