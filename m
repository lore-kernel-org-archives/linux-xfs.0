Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A142EBBA4;
	Wed, 15 Oct 2025 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546297; cv=none; b=BF39uTrF7nB82AjTSMnqPKzyIpDmvPnXWq81L26LB7y4G3qUkEld7ZC0yfeAH7aYessmXi1BIgQI2LIJiqubW6J4ZBFw/RMqQ1OLFWvrpfYm1ycZAGyugJxMc1DTWMgckVPyeOdcRZBDrVYrrLrwEDWbXokgXMgyuPZEuhAFa6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546297; c=relaxed/simple;
	bh=vDNJ+AASOwdSFVOeilxAJJVHodPENdm1KfaX5EXZz70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZGc6B33l1fwlC1C3uSPsaC9BsHa5r0RSk2+Cd6I2oPEOOJLzMSiZ6rya79DkkSc8H4CMQ4aIBP37xa/2koXyLBB/28UGEpZS2rvijg//2OlPtEzpnbhZumjw34ukSGUTf3xCAPwdz+YRgQ6XCnvb6Av2z0QcFdVc4xuHC8GO+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWI/xUnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWI/xUnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CB2C4CEF8;
	Wed, 15 Oct 2025 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546297;
	bh=vDNJ+AASOwdSFVOeilxAJJVHodPENdm1KfaX5EXZz70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BWI/xUnPEbExLZreYEw46mezVBl6L0BiwoeBHqsa+Gqd1dUmQgL69JBrolrrsVo52
	 q6HCSMGV0mzwL2i/AnLYhpKwY9lncCMfKPeeS2RduJF3/lccA/Efs6p5FztnxC+UJL
	 1rzC1RCiaHbG+vRpxTMTitchIHn/aoWtsVbC3h2UdN4WDXnCKMQRdGz4eu0MTTJ5dt
	 wqX7thuMkzj+fDChcviPqF7AS2cvDJFLZ29FKt0BCUmZnl/UQHcVQ14u2WmsGelhCF
	 pyyvdhC25NKKLr7pqLEn3WbHXqdQStOrvPZeLwv7GAoMdWCq0daucX3lqa/ySL8owL
	 nCyGFjybwgXcA==
Date: Wed, 15 Oct 2025 09:38:16 -0700
Subject: [PATCH 6/8] common/filter: fix _filter_file_attributes to handle xfs
 file flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176054618007.2391029.16547003793604851342.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, _filter_file_attributes can only filter ext4 lsattr flags.
Update it to handle XFS lsattr flags as well.

Cc: <fstests@vger.kernel.org> # v2025.10.05
Fixes: 4eb40174d77c1b ("generic: introduce test to test file_getattr/file_setattr syscalls")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/filter |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/filter b/common/filter
index b330b27827d005..c3a751dd0c398c 100644
--- a/common/filter
+++ b/common/filter
@@ -688,10 +688,11 @@ _filter_sysfs_error()
 # 	... | _filter_file_attributes X
 # Or to filter all except X
 # 	... | _filter_file_attributes ~X
+# Be careful, we're filtering lsattr or xfs_io -c lsattr flags.
 _filter_file_attributes()
 {
 	if [[ $1 == ~* ]]; then
-		regex=$(echo "[aAcCdDeEFijmNPsStTuxVX]" | tr -d "$1")
+		regex=$(echo "[aAcCdDeEfFijmNpPsrStTuxVX]" | tr -d "$1")
 	else
 		regex="$1"
 	fi

