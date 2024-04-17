Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0277185C5D
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395680; cv=none; b=ONMWw0YtNwBVkWN1vc4O1ajP6ayTpx7VrypTEXU8c+EstUDRDl3GctD0BrxZSIWtVSHZS6oKfkgqenVCy987h3csRuHq8t30dQvYx7QIG8UXEq2t+abI2x9AuvqyTQSnUEqihJdAthLME0QCcFz68kaqAc0cqIGZLs8T00CWIFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395680; c=relaxed/simple;
	bh=3STdhBmdGiRXUHbXoavWHl09s21Go2NY1UpdTyCWBK0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kc77oN9upvWgX/SdjgLKxeSr+G5H+uDJezeLrdtEozAFWM/woHUkv2TTF+4TjFeDWepUuYbQFINvEeoaKNiusy8+k7P1sARVcFx7OxiDiwFdMEA3hvzVH8pKAB3EOmagdTfRS1y9S/qvCs2C7CsIdyI78QiljNnPB7Sf/HdTO5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXiXzckJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXiXzckJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875C9C072AA;
	Wed, 17 Apr 2024 23:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395679;
	bh=3STdhBmdGiRXUHbXoavWHl09s21Go2NY1UpdTyCWBK0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pXiXzckJJw6z7pqdnppvB/DzkiJdFIU8HKcsGhrnpsCyQzhHrPSBmfvLUbjOmNBdn
	 EQxGcMx7769G98ijwSBlzfmfDLuYA+uv/1obUGWdhgEcyxTNeEHeEj2/5dYzui0ZWJ
	 zdIDuwPAuEEUhSxFe1I1aSZVxhfmonEMdh4P42KOrFrmi07NQkcEIN58tyUqLdIweJ
	 GOh0SYZKpz04CFk2Z9TyzTpRwIigxoHg0i2+cEBgkBb5qOD3fC4L79e4PqXswkf+V3
	 y9VPrQN5dfu9SWipye95gY4CScWpCsWZsHs1hoFCpXrLHjN7cr847EO04L+hu4YZKx
	 N1Z+haHserudA==
Date: Wed, 17 Apr 2024 16:14:39 -0700
Subject: [PATCH 2/4] xfs: fix iunlock calls in xrep_adoption_trans_alloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339555995.2000000.4526556907495165731.stgit@frogsfrogsfrogs>
In-Reply-To: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
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

If the transaction allocation in xrep_adoption_trans_alloc fails, we
should drop only the locks that we took.  In this case this is
ILOCK_EXCL of both the orphanage and the file being repaired.  Dropping
any IOLOCK here is incorrect.

Found by fuzzing u3.sfdir3.list[1].name = zeroes in xfs/1546.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/orphanage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index b1c6c60ee1da6..2b142e6de8f3f 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -382,7 +382,7 @@ xrep_adoption_trans_alloc(
 out_cancel:
 	xchk_trans_cancel(sc);
 	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
-	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 	return error;
 }
 

