Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF67C1C36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832347; cv=none; b=XdQxP5QSIX2Ufs+vVP9X48ZxMZOjsy0XTAWWLLeiFf0D4Do7nG4iiXe1RgB6IQssg6b4zXjsx41kWwbC1xtc0BvYCPleuuxgUHmoxp65dzlFlmMXKfiN88NUdSxE1mng+vwkiA72PyomTv83xI6QIJ0Xhlh89S+3yXHJes3fCTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832347; c=relaxed/simple;
	bh=XySbrjS9j91DXjNTdhVoO5N4VQh6o35UloQ76v40G7w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZFuKFEBz5Arqz97t4KUb1lTdaUeop8O11f6+P1EavIj/SBq2V32JoJ5WxG/YJqcQu766q9Z+IRWkn0YfiRM2Z9WP27aOy2B3NaW9N+550qp+7nDbYOtBITxSWXHfj0nONPICXx18kdwCtUMywkAKVNHiUV7p9GhEcTjfg1Ha9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9DxKwOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9DxKwOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B14AC4CEC6;
	Wed,  2 Oct 2024 01:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832347;
	bh=XySbrjS9j91DXjNTdhVoO5N4VQh6o35UloQ76v40G7w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a9DxKwOgJxoWMM/+MwfdPrsoDIAUsvoBsWmKb2uLOidChWxEHFhoonYQj4qkM211Q
	 ZOgFD9QYx3SbDIhkyBs/xIZYDo+nO9r1wH0yl+uM8IxDtTzE5t1Q2qkewU/cQ4UgNh
	 LRs8+akFdYdRjGbQFsXDZclAudMuZpxHxvpJI+pRgS/k1W+ISWXSCBLJdCzqkCT75Y
	 x3eT8wmhWQtUvxFgGVrsdRv2IW3hnbOJl7n8F7o0+FI8dx5chBsE+IvoK19XPYUX2k
	 bfPTwbDJoY9jbz6KQd5HFQvNbKFF8ppxdorDipMeMyTRd6MRmW4E00dP/mN60ppWAH
	 9V+3+qWp5So1w==
Date: Tue, 01 Oct 2024 18:25:47 -0700
Subject: [PATCH 1/4] xfs_repair: fix exchrange upgrade
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103393.4038674.368177237231285654.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
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

Set the correct superblock field for the exchange-range feature upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/phase2.c b/repair/phase2.c
index 3418da523..e50cd3f8c 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -205,7 +205,7 @@ set_exchrange(
 	}
 
 	printf(_("Adding file exchange-range support to filesystem.\n"));
-	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_INCOMPAT_EXCHRANGE;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_EXCHRANGE;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	return true;
 }

