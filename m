Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC64146A66;
	Tue,  6 Oct 2026 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276983; cv=none; b=m85kOrkQrlOZXYQIoneOrTpukgG+3Fae9FGmnKn8kIlBRqSGLT9wXcDodCxZVB85oVIOjqEyJPCbC+gidaGAlRoPHd1b9pBx6PTASUxkagyEVJhO2H7Zm8kCybS+Xb3SRxONUpiUVT3ojIIAmeJsQQhSM9bSV3H5yjLeXCrVA8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276983; c=relaxed/simple;
	bh=rcVF3lLs3XMniUBfyq8wrBPaBtECq7YNiKqxeLkQVhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S17QX2wF7MnhHMQgtX3h78ToRWRSkzpZ3hrpCQz7PK0QhKrQDleCmaMEKG4vqa/AbPaMxpP2HsQRI9JQOFH0+mb727P1GwWfLKVO7Sxa2bYkQevQzquhWEOTa1xTAIW5agQ5zb26SFdVvoNYe44MHrBFG6mOtsez4tuBugQYhsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iEqzWU4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iEqzWU4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8877F1F00893;
	Tue,  6 Oct 2026 08:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276982;
	bh=lfgbtYsfIa3Y1+/Z82Q1Kr3zd3j2Mt67FJlEnxgejh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEqzWU4jqOYhGSK3tWZ9l4zIwxukxufwe3uZaA4r50qe9e3B72bAC6m96SeK/Au02
	 dHVVR23Tcn/ROR12XbZMrONs24DxouhWKzDtkFDgmju0/wtQu1ztOZHVnCcK20UOMw
	 7ytNgUwfNtzWMD+8TiwXqZpvXoiaxOtgiHrRS4Jpr2D3S1kp0YDFSRnjQEnOocsxje
	 A1LldE9vOdp91qG5YsDLDXxsb9NjF03/PiJkl4Lu30XeK1k6tqz1GlYgwDdrVQFnDH
	 D831obKyOMxrA2nVT4iz0O/p+oOIUy1B3Rku3OlCboz+qgZhGgP+4GtdjC+uNAQukn
	 0PF3q7ksFcWfg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 04/21] fstests: add FSNOTIFYWAIT_PROG
Date: Tue,  6 Oct 2026 16:55:30 +0800
Message-ID: <bbb4964b26c4c3afa4056b029abda1cfdb08ceb5.1791272793.git.asj@kernel.org>
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

Define `FSNOTIFYWAIT_PROG` for an upcoming test case that uses `fsnotifywait`.

Signed-off-by: Anand Jain <asj@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@kernel.org>
---
 common/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/config b/common/config
index 69e5d83319b8..76b43b8c6ad9 100644
--- a/common/config
+++ b/common/config
@@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
+export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
 
 # udev wait functions.
 #
-- 
2.43.0

