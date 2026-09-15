Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E950378D9A;
	Tue, 15 Sep 2026 05:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450705; cv=none; b=hMvoK/1Dgz7b7sA/BPxOOX+fXxSi3wTWGcmlKdzj0sT4NgdsyNVoYlrsMU3wH6cs6k3YE93+GrG4hGmFR6AZJLRgj2PSGNpLxtM/k8GMnGcDrj1PyocjujGuSu+fS6m6V3yxyQugd07G9GIXFrdreYrNDac0G71A9eBVAMESI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450705; c=relaxed/simple;
	bh=IM8T/HpgK3AkfYs6TlHWuEPuVDeIsj5qEdFBYGIcbvs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJA7U21MQPgKF03xCOrw0hFNCPghVRN4L6QrYHP+KSCSBuxytW/K2npvszFF7+J5Otv2svSAmezwRqE/pX36zwUcC9q7oxeIkUBYuusGESHHPDT5xCkGuNzdRDjzzkFY6O74Z3UZPwFJ37/BW6uwoICLourhvutpohuuypKWzf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rg2kgiBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rg2kgiBJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A61441F000FF;
	Tue, 15 Sep 2026 05:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450703;
	bh=IfbLkzPoNwsmMp2BJC+xedu23k8+vdXGim7lECDBZJ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Rg2kgiBJFBBtrhLguYKJ2o/4Et5w66YOGSdDDKJPRF4rg0ATwUkwER+nm3h63jAUd
	 0z9BHZ2ObLy6CoKTuZrber6+0X46TyqgjuOOFZFdNQ4/+jGL9oIbzoBBTgYZmDIYh8
	 /1Gv6Q+2iRsVhtNRg3nGnZpYXW6qSFvXX+z8/qk8Czwcz086mFADz9dTNycdZ+suDs
	 vuhbP4hheuQTvu08syAjTl2S7mCG07oZJ6uTDfKsf3As+kPl6PAYV5/rEOHQF7bsjm
	 lXUfQCsyzNJGBn3nk5xgUhLw0J2oVJd2YBzLlzqMTKYLXkQQ01TbzSH3zVmG83CTNE
	 h7M8K5uwbVQFg==
Date: Mon, 14 Sep 2026 22:38:23 -0700
Subject: [PATCH 07/11] xfs: fix blockgc group quota scanning when usrquota
 isn't enforced
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048648.3061055.15354036415153320075.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed the copy-paste error here -- if user quotas aren't
enforced but we're near the group quota limit, we fail to set FLAG_GID
and hence we might not actually free any preallocations, causing
unnecessary EDQUOT.  Fix that.

Cc: <stable@vger.kernel.org> # v5.12
Fixes: c237dd7c709432 ("xfs: flush eof/cowblocks if we can't reserve quota for inode creation")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 82dac88e3c4c71..de8be344e987d0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1653,7 +1653,7 @@ xfs_blockgc_free_dquots(
 		do_work = true;
 	}
 
-	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+	if (XFS_IS_GQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
 		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;

