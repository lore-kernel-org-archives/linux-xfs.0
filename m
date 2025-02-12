Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5132C271839;
	Wed, 12 Feb 2025 03:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331354; cv=none; b=OcQETgnVufZaLPjB82aHbf1PQxGQQmdoHKLQ/CYOfCNrDf9mfysJZE42zZIyjmjFXf1gIKQ1PeRYdSOQgzbdTSQfS+aQ5xmZSzXlYKwsuMIz0rMClgicqhH/hNTvsQ9D8YifZiE46glqfYq/QlIQEn2iMCDR9xKpZKE85/XMFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331354; c=relaxed/simple;
	bh=QQHwjxCQSNh450WcMhYhfkItaTknt98ZL3de2wMIqLM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rt/jU7si2hPbu85C727BCMVOQg6GWDBZO2Ua/Z/+MTiU/ihPwvN6eUgTYKMalyX7sEBjIeXKpveu1lGHSrDOJZ7Nx1TonBoO8sC0CN92WZANAE0Z7xVTpdFkPWmC0d8mb3SLODrU083xl6P5cmSMIpTez96oSw2H5Xa+rpmPXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhwNPiYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhwNPiYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7C1C4CEDF;
	Wed, 12 Feb 2025 03:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331354;
	bh=QQHwjxCQSNh450WcMhYhfkItaTknt98ZL3de2wMIqLM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RhwNPiYM+4hG7rQfr2Z9L+jaQw/S4bw8CK5jycnJz/1K7dzM2cSZ+PUIlnE7Y9azl
	 AwHdP5GasD8LR1qgB2llTaQfGP8maMUzsE4HSK+tlFlWCiSYZxrX0CPMzpIGHCGp2H
	 5xzQdIkZkAfixrJt+LQ23T2oBy76PykMMdSLasmgCx6Kz3fuAUMBX1zG2+ys5c9ce5
	 Tt4HDK72E2dsPrKDsZdvBobMcDdarfwrDOrSXMW/K2SpcFmcw0jlyiIfW3yZTlDCtA
	 FrnLpXyadtLX+Gg33Kv+PHHSfcFxpucaJUYzUa9Ja0iLjWpXI0x7GMavHvw9zU7nua
	 p17FXOG6nPKFA==
Date: Tue, 11 Feb 2025 19:35:53 -0800
Subject: [PATCH 20/34] common/rc: return mount_ret in _try_scratch_mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094661.1758477.6602985022619870400.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make the _try_scratch_mount and _test_mount helpers return the exit code
from mount, not _prepare_for_eio_shutdown.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 1a49022fab9b4d ("fstests: always use fail-at-unmount semantics for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/common/rc b/common/rc
index 70271ce1d55179..12041995e9ce75 100644
--- a/common/rc
+++ b/common/rc
@@ -440,6 +440,7 @@ _try_scratch_mount()
 	[ $mount_ret -ne 0 ] && return $mount_ret
 	_idmapped_mount $SCRATCH_DEV $SCRATCH_MNT
 	_prepare_for_eio_shutdown $SCRATCH_DEV
+	return 0
 }
 
 # mount scratch device with given options and _fail if mount fails
@@ -657,6 +658,7 @@ _test_mount()
     [ $mount_ret -ne 0 ] && return $mount_ret
     _idmapped_mount $TEST_DEV $TEST_DIR
     _prepare_for_eio_shutdown $TEST_DEV
+    return 0
 }
 
 _test_unmount()

