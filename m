Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E859155313
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804004; cv=none; b=qZETLY9sgskxlFZ+oilio5PynE3vZqkBMJ4BtMFx0j0snitOosPQODgUvkMZlujNT2RQz4SuwgJxSg+0QutckKpaQoON4RL/zRJKkrPyS7KqJ5QwHJvOWTj4t6Htc7i8KT6Ic3HRooIjysGRmKhoWiW7sXiZ8alAs8FrKVbd13Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804004; c=relaxed/simple;
	bh=651JdkIKH8HUqx0716uQJmNAkp2CMsm27IT2q/6R37U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inAYIgmyqGcUCQOUVmy81YwN3rrPKmzCMWo4Is8Noh2OC2yBMgLUvRj3CmjQPilEmMUG2iUhnXno59uk6+GYgZ1xD1G9rWyBkBzxWfDAmFRYNbZYWujF9fcoY0vGv+NaBLI6rdSQfwXnv0wj66XscheHSZMfqZCmCshamHNkJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J125P3iR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J125P3iR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED6BC32781;
	Mon, 22 Apr 2024 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804004;
	bh=651JdkIKH8HUqx0716uQJmNAkp2CMsm27IT2q/6R37U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J125P3iR3ARQvZrMpbh6h6TrTp/tZDZN9KON9C7lUFz4Sd+5ZBA/RJ8+/QUAcYkgF
	 y+MYMIPv365UXFnHC4ZohQxVFOFbK5hyT0rbwwFsjPpTjP6SiZ2LE8XVto0f4hpyQT
	 maB2OM42gp51Daq2kj/8la8h5SyNEmUe8oKe9b9NczEqY8evysIP6t87PTjDYL4mFB
	 vWPosePUqss7pFpWPqHfnz7Mt9YZRYVdfRARW5PzMgMFDx47vTuXZmBpPWDRnVASTD
	 vetxPIUxMHqX0iXxUWLkQuxDbtsu13EXpHhUpdfl5/q7BNZporXsSZlYwoamP1MyGR
	 3t86T8Uf9TYhw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 37/67] xfs: dont cast to char * for XFS_DFORK_*PTR macros
Date: Mon, 22 Apr 2024 18:25:59 +0200
Message-ID: <20240422163832.858420-39-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 6b5d917780219d0d8f8e2cefefcb6f50987d0fa3

Code in the next patch will assign the return value of XFS_DFORK_*PTR
macros to a struct pointer.  gcc complains about casting char* strings
to struct pointers, so let's fix the macro's cast to void* to shut up
the warnings.

While we're at it, fix one of the scrub tests that uses PTR to use BOFF
instead for a simpler integer comparison, since other linters whine
about char* and void* comparisons.

Can't satisfy all these dman bots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9a88aba15..f16974126 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1008,7 +1008,7 @@ enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)dip + xfs_dinode_size(dip->di_version))
+	((void *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
-- 
2.44.0

