Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86608233958;
	Fri, 25 Sep 2026 04:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309463; cv=none; b=DWvYuhdPjAktDzeHAYrYnotl+Qi6jbcT1jZGgSd8S6P5mkFnYs8p9fr7rtgOL6/a6s3dd0tl+JI9v6ld39jELi3ouWsLJRYQTRwXo6KDABrPOgpLaaqYdHM05OSppmayyf+3k25ivgpJwdYsjKVWlun73CF87sndfPjHyEPStDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309463; c=relaxed/simple;
	bh=6+zJk4wrjgynJVWglZPrnTNaDmZqjmCQyTVAtNelY/U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPhZE7p8I+7+n0rkIQwxZC4HHv3H7xxTsAOrXcCMfgTJ9uT+qxy+TyshK6WpWeG5TaD05N/s6nYHhyH1WIfN7FBL8n+FNL8Ybtc4Os1IYpC/JSeUeDL223SQ57DjYz9RAE6oZiaELK7QquCY9dln7zNfxs1uQ2QFPQ8re0vjMYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adL6DQFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adL6DQFh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14E8F1F000FF;
	Fri, 25 Sep 2026 04:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309462;
	bh=qOycJHsQTUM0nmukC9g4UsXwHik8hyImhFwK9XUxAN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=adL6DQFhL+CCWv7zID/sVSQYyYVbtvU6YpxBNXwRTlP8Y9UGu9+a9K+Vw+jm3hMUk
	 oVLLso52Facoo/8pwtdQ1lBm8k8oqyp15ZS2P5YjD/UJrvZv/uqgFkNyC+iG9P7vQH
	 ONtIXsHyOarxq0yXmo66U+ZMojewf7y4NkIqoaYNv5T3f+g6iBEfnvBdl90KRo7yn9
	 BZNvdqfA55nrhYBm1Jy9TLb9Eqn3Ulj6ZEkPdIDtEMhbEn3BtwMIy9wDznVprHS2xf
	 WorZExwyNj8FcI1f44ugXQRMuBWbQqZxgOFN5K9O1X2QhSimHV5zPAX+QXIt/q9ybq
	 zaYwqjl28LRHA==
Date: Thu, 24 Sep 2026 21:11:01 -0700
Subject: [PATCH 02/12] xfs: actually check XFS_DIFLAG2_METADATA for metadata
 btree data forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932092.3344850.8040519896432393992.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dinode_check_dfork doesn't require that the
inode has the METADATA flag set in flags2.  Add that check.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 702c90f4516223 ("xfs: support file data forks containing metadata btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index fab4015f6a9506..b047abd28bd341 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1012,6 +1012,11 @@ xrep_dinode_bad_metabt_fork(
 	if (whichfork != XFS_DATA_FORK)
 		return true;
 
+	if (!xfs_has_metadir(sc->mp))
+		return true;
+	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+		return true;
+
 	switch (be16_to_cpu(dip->di_metatype)) {
 	case XFS_METAFILE_RTRMAP:
 		return xrep_dinode_bad_rtrmapbt_fork(sc, dip, dfork_size);

