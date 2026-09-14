Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D884963CA;
	Mon, 14 Sep 2026 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406742; cv=none; b=Xui99Ph4Qu3osimnKXjc/BLHFzH6xrZNGrC/KgvnnTwaww4w2cqiEk2uilZJFiVauVdeb/OJPOvNA/md0F8xDSSZbHB7Zl9ZUfPQcanvX+pQtXvPw7mPnO2ebN8QsYZ83qhYpCXMAQ+HZWeZAkfsPR0mc8x/82OzBupR1CPbrqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406742; c=relaxed/simple;
	bh=5ayAGfMjiIlDs8q6zSVLOFS4Ux0UyH4CeVv3gODjKgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6K1uoo+FIlfqkgGyRU6oR2bUQ48L7EnGVe54AySXsJro3Zjn8PX9tfm2ZFCQKvWNFywOTGeSZkPivd8x+9LDTF0RmQugc25XLIc/rwUpomFNKVbYpLD+QMS+cDpjBWLhenKlQnhCGsQhPAD2GbT0BtvzQLmg0ngdq698+KB4ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEm5Jq+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEm5Jq+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60781F00893;
	Mon, 14 Sep 2026 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406740;
	bh=rDiPHfbSLd6SIcPIvLOCdjC51/CEQe2eqX7uUKX5UlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEm5Jq+wVatOAgYUGZd+8u/+acvZXpYYKtZtYeaLTijD28RjgSsR653HxcVzWgw63
	 JUQQQFEc2REOjMHhP1fXE30ntDgDIlkYdLW4CGFgYAvsEZ8Sr76iGVHaVG+w/zcRFs
	 3SJoJuMSyNY3rbp68tR4lSGRYXztYoueAMltLveO06IQRNc3BdjxcxHKqxb/0zSPd6
	 i+UJRwtGVipyH+neMigBLuSvdkA3YBYxL9WJPzAhzPCmVjslpMW38nS0bebeOm8vRB
	 KXLdmOGvmc3/BbdeenGPxZ+a67Uy/nYXNFCNC+3rCamau8XcRm9kihQcvDFhxUr9XG
	 OPi6FS3HZBJsQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 4/5] common/rc: use common helper in _require_fanotify_ioerrors for f2fs
Date: Tue, 15 Sep 2026 01:25:08 +0800
Message-ID: <20260914172509.3799016-5-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914172509.3799016-1-zlang@kernel.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The f2fs branch of _require_fanotify_ioerrors() reads the raw
/sys/fs/f2fs/features/fserror path.  Use the new
_get_fs_sysfs_feature_attr helper instead.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 439ca0d5..711c5507 100644
--- a/common/rc
+++ b/common/rc
@@ -6308,8 +6308,8 @@ _require_fanotify_ioerrors()
 		test -n "$x" && return 0
 		;;
 	f2fs)
-		local feat_file="/sys/fs/f2fs/features/fserror"
-		if [ -f "$feat_file" ] && [ "$(cat "$feat_file")" = "supported" ]; then
+		x="$(_get_fs_sysfs_feature_attr fserror 2>/dev/null)"
+		if [ "$x" = "supported" ];then
 			return 0
 		fi
 		;;
-- 
2.55.0

