Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A5A3BA241;
	Tue,  6 Oct 2026 08:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276993; cv=none; b=k9t8bp515fSIFIRBMlL0/0lx9PUDeO2UI3kalCkMtUnqXYT8xrdwMUGJuOiYrFTTsEGC/R716KvC6GG5FfnZRqkOIvhcN1Bp4DF6WidIPyVRmq898ZyM/5pFBClSlBa4unyOy/oFb0w9EeUV9GE0lad9eJP05w6BaEbX87rqP0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276993; c=relaxed/simple;
	bh=yfbK03gbRr26s2sy6aPYHv61IioTcDrykDJbyM7P6Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ3LP9OHwVYvaEDwVe1fU1mARxsLi+BRbGK7vbMxvUPkkzyQD0Du4iWFr/q3p4MqiVQPg9+7Pt9NwV2oVFBKVlUvSIFAIZ9totg+bNLNTZnCCRiIQFFAHJ0FfvRgrd4mhFxu2hi0q+4EoAvPr7/c23XzWwMvIlOS6sIvSER7cGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BualXTil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BualXTil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A561F00898;
	Tue,  6 Oct 2026 08:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276992;
	bh=gyagzCFzfR8NXrj8ArDpU5SoX4giHOzAJxEfd06R/sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BualXTilDpMmacU+nIUf+jMyv28iuEyWHfqD1JDs/+PK01kJRqYhkEEKpRwdvMtGI
	 /bg0bBYZWnI2SGNMb3IsZ64Qqr1UfJsKBH8x03j6vGltUYNX2BrPjAZeDg08SdWjrf
	 asjHGQyppjtPsowREyDY4UVp8v/H6jFCjj/myAuC8rbUtV2Pb7oiGmn8y8Q+SSX8Qn
	 6+J90Gx/Sx6lc8f5PvHrPW94Z/Branm7y+YLUmSsF97AsFJEukviGN8qEJG0AAfWyy
	 gw1MIhKkt3AOlhLbinpsduIqr8HA93/WPfuSuAK9spotN2UJNeLF3B8yLiKywZemN3
	 Djml1RGbQvekA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 09/21] fstests: introduce helper _scratch_mkfs_uuid()
Date: Tue,  6 Oct 2026 16:55:35 +0800
Message-ID: <5a816f5c76ae3e0761524d53998afd9d0d74f58f.1791272793.git.asj@kernel.org>
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

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/common/rc b/common/rc
index 37b32b498c80..37df780f64ef 100644
--- a/common/rc
+++ b/common/rc
@@ -1449,6 +1449,36 @@ _scratch_mkfs_sized()
 	_try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($*)"
 }
 
+# mkfs filesystem with a known uuid
+# Input argument : none
+_scratch_mkfs_uuid()
+{
+	case $FSTYP in
+	f2fs|ext4)
+		if echo "$MKFS_OPTIONS" | grep -E -q "-U"; then
+			_notrun "Config contains mkfs uuid option"
+		fi
+		MKFS_OPTIONS+=" -U 12345678-1234-1234-1234-123456789abc"
+		;;
+	xfs)
+		if echo "$MKFS_OPTIONS" | grep -E -q "uuid"; then
+			_notrun "Config contains mkfs uuid option"
+		fi
+		MKFS_OPTIONS+=" -m uuid=12345678-1234-1234-1234-123456789abc"
+		;;
+	btrfs)
+		if echo "$MKFS_OPTIONS" | grep -E -q "uuid|-U"; then
+			_notrun "Config contains mkfs uuid option"
+		fi
+		MKFS_OPTIONS+=" --uuid 12345678-1234-1234-1234-123456789abc"
+		;;
+	*)
+		_notrun "can't mkfs $FSTYP with uuid"
+		;;
+	esac
+	_scratch_mkfs
+}
+
 # Emulate an N-data-disk stripe w/ various stripe units
 # _scratch_mkfs_geom <sunit bytes> <swidth multiplier> [optional blocksize]
 _scratch_mkfs_geom()
-- 
2.43.0

