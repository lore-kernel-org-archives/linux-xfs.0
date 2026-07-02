Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDF72E7365
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022470; cv=none; b=tI5QAtTzVIFZy8vH6xZOngb42crJpA/+sKnqkzMaGfvp+nl4VUALFLUXw3VwD5Jv6M3NJqL2ymFeOTwfDLBMANDBPHWBH1ElTgTAy+OY2KdcPgFefu2EshKex6XFV3WcXtIg/qbBWA7mr8Oyq8MZg9ahrpccw6YcDuUN2FgLxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022470; c=relaxed/simple;
	bh=o+oxAPPP5NTMG/U2LZDi+zksGIWOG3TcGK9Qj4sPGBc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjLLaP8pHYB6payf4Krw/nW08YX/DI300Vtg0xCRJ8JcihHSw5nzyNAQ8x5w3jj9bRRXckhxtkvf7nTC8YXuEWa+opvtXbxuvLqYPQHVhkFyJC7A0AEBWeNU/tbeWaCTAxOoR+0MEvIcjDg1qwTh+t1MLb7kfYKMfNmY18emlGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9hVNwXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9hVNwXB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 739181F000E9;
	Thu,  2 Jul 2026 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022468;
	bh=m8XZDlMR1X+WS/B85cJolEHD667p9tF70sfi0372mzs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=j9hVNwXBXiq1Hd7V52sBAjNPRKw2w63xDemlgjsPX6cpLxMn+YQ4MAumQrTSrd4v6
	 90u1QgHGET5HwjmSTQRs6YDTDBvvtLphmLVdDvtMWB1A8rcASBC4C1PkJWodjjNGA5
	 +CuN0UpUuYCxUISVTaK572ITG0zJvIfdgH8ex5tAJa5f+pDA96qUGVA+AxhJoIB+o1
	 q/wghLkboa/VOie7BVbv9Z4tS9ly0BZZaIoX7amHcauu6WXUUAXRKs6kKYWK8aJdli
	 /er7KYb7isLoHtWSQOaoWWCf2Jgjq/Fhj9tQiXo5leSI/NCV1Jtyk6k8oFBLddOz2x
	 AIslil64nuQGQ==
Date: Thu, 02 Jul 2026 13:01:08 -0700
Subject: [PATCH 03/18] xfs: fix exchmaps reservation limit check
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, gaoyingjie@uniontech.com, linux-xfs@vger.kernel.org
Message-ID: <178302226359.845537.16384694520609150281.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Yingjie Gao <gaoyingjie@uniontech.com>

Source kernel commit: 0a5213bbff62b51c7d4999ac8c7e11ea57d00d45

xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
overhead to a local resblks variable, but the final UINT_MAX
check still tests req->resblks.  That is the reservation value
from before the overhead was added.

The computed value is stored back in req->resblks and later passed
to xfs_trans_alloc(), whose block reservation argument is unsigned
int.  Check the computed reservation so the existing limit applies
to the value that will be used.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 5566f9faf45612..651c3784caba73 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -708,7 +708,7 @@ xfs_exchmaps_estimate_overhead(
 		return -ENOSPC;
 
 	/* Can't actually reserve more than UINT_MAX blocks. */
-	if (req->resblks > UINT_MAX)
+	if (resblks > UINT_MAX)
 		return -ENOSPC;
 
 	req->resblks = resblks;

