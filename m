Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EA58627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929342; cv=none; b=Ce9IBMyWWZ/zbHyh9ThOkPuZEfUSJrmF+Id4C5ftW5E+z7k1Fch7S+hTPPHA6SuCCHy+htUdzA5W5v/Ld0B1p3pHYZXaU6dFBLC3qBBlI9xet44EVyFVUtZBfVx9fPLvygt11nyR0yqMRK72obYxccmIM1d1o2+hsIHwH14wJSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929342; c=relaxed/simple;
	bh=1x5byBxVJZGN5MD6kQ4uxUodGp28ChuVsfLW5VnFE78=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B4TaJup505wDT92+Lpy3aiH7M8aUNCSUarzsH1OCdEa++x+Vfir3bXLCCUF5IaLH0T53mFhioBVDEH7OU56G6KTyqVmIlWCuyAXiaqEyD0nsjzFuhMcKzxESd9RFQrWnsCWzM+H6uGo1Vmfg0yqHCr+ChDhwsI0JRY07l28n4ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GeLNr7R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GeLNr7R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CE4C116B1;
	Wed, 24 Apr 2024 03:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929342;
	bh=1x5byBxVJZGN5MD6kQ4uxUodGp28ChuVsfLW5VnFE78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GeLNr7R3auxbd4wJwVqtlJW8BuWsTmMbXT3HWtX1aEWmc224dKM2eqBa4N9IZa/Ik
	 tVo/J18qYNs3cgP0YkQQKu56c+vL6VR+dNnPV5z9Tne7v5IjybdzQ6zMML1wSt8WKg
	 Ox1yM4hYINRTkIklidQ7jHwzsTfYp3Rf1AcYhmvaNYQgi3kc7EJKbuOKkkaVDW5kxy
	 5A1LxBUDJzfDsmL/PRecrFp/WWnXP3R2lAulWgtAr8Cfmv1gFQcA7CM+2aWdxntB2X
	 IVl9wOnAJbwx/t9mwofnnPtcj/akncWuAqUE0XJP+C3gpbd1hk6pQbn2fxU1LKyYqj
	 2moDeDx6F2o7g==
Date: Tue, 23 Apr 2024 20:29:01 -0700
Subject: [PATCH 1/4] xfs: drop the scrub file's iolock when transaction
 allocation fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786413.1907482.6190323348839350573.stgit@frogsfrogsfrogs>
In-Reply-To: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
References: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the transaction allocation in the !orphanage_available case of
xrep_nlinks_repair_inode fails, we need to drop the IOLOCK of the file
being scrubbed before exiting.

Found by fuzzing u3.sfdir3.list[1].name = zeroes in xfs/1546.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/nlinks_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 78d0f650fe89..b3e707f47b7b 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -138,8 +138,10 @@ xrep_nlinks_repair_inode(
 
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0,
 				&sc->tp);
-		if (error)
+		if (error) {
+			xchk_iunlock(sc, XFS_IOLOCK_EXCL);
 			return error;
+		}
 
 		xchk_ilock(sc, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(sc->tp, ip, 0);

