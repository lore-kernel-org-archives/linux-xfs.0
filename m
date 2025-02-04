Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBE25A62C;
	Tue,  4 Feb 2025 21:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704452; cv=none; b=eneMcDbh6vSFadqizd0NnmiD6RamCrbRQV6eN6ccKW/wBKuYJ0s0ch6muHrTbHXHxxjiXLBEhqTjrUWi3d0RF7V7eBlHwgp88Jh8XKhtonhJRHQPsJoPOQ8dCZk0PDq7+3D/ZeNAM+7URnGkWa5qhbzrm46ldLxv2KPTRhpD3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704452; c=relaxed/simple;
	bh=fFn6Zjw1hEY+R7NHnsX/8ymKBs5LhOBu0mb7v1gkThw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=okJ8ctJ9GEPyJsth/TKNeELmRFGZ+yub8YlkprfO7ImYbalKiViqdM7TUWvHUHvSgdASaClAlxTDgptBrM9f8fka2B0M2CC0debADtROXbaomU19VGmgqzeBzL+MyMvKgI2tuEZPrwBmpj25UVBCD2v42V3RNB8VfuL4MFsa1TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQEdn1b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQEdn1b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010BCC4CEDF;
	Tue,  4 Feb 2025 21:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704452;
	bh=fFn6Zjw1hEY+R7NHnsX/8ymKBs5LhOBu0mb7v1gkThw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LQEdn1b4iUFGylaY23IX9N+Gv8ChvvuM+g0/Th9pG93LRIJYWPa1X3eCGAH94wySM
	 YS4jVOuIHXmXgjTi+W2iCqkiGzA9Yt9XSFWWouCe07pARzsjzGaWkKb302DIdSdgiV
	 DOzHOOT8bRRrMtYLchAsoPXtxVgip5MXUXOS8Tt4p3SQuAsSUxzp+rvr7fGQVirIVp
	 fmllNHDeeCIQAJ3laW23iTzkit2BXHbVOnz/cWSpXRCcvQHahSNRT9km8uMhkKLWd/
	 o6s2v564WO8PDLw48IE04ZeYn6dxOw2lAh5lUSsgq2f6fTvGCjF7R3tYAaChvM3XOc
	 a9UFBRDKOLWFg==
Date: Tue, 04 Feb 2025 13:27:31 -0800
Subject: [PATCH 20/34] common/rc: return mount_ret in _try_scratch_mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406411.546134.11968180503485222405.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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
---
 common/rc |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/common/rc b/common/rc
index 03603a5198e3b6..56b4e7e018a8e0 100644
--- a/common/rc
+++ b/common/rc
@@ -440,6 +440,7 @@ _try_scratch_mount()
 	[ $mount_ret -ne 0 ] && return $mount_ret
 	_idmapped_mount $SCRATCH_DEV $SCRATCH_MNT
 	_prepare_for_eio_shutdown $SCRATCH_DEV
+	return $mount_ret
 }
 
 # mount scratch device with given options and _fail if mount fails
@@ -657,6 +658,7 @@ _test_mount()
     [ $mount_ret -ne 0 ] && return $mount_ret
     _idmapped_mount $TEST_DEV $TEST_DIR
     _prepare_for_eio_shutdown $TEST_DEV
+    return $mount_ret
 }
 
 _test_unmount()

