Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304423;
	b=KP+++UwgmXPaSCZ123KLQDnlQNNEnQxtxSG3NBZYGuiXaU9diAIEvabWJeubtlkB7Guq
	 ya5/AJO7AzWwKYhDC8TDTQHzMzpKlWXp8r838tLtO+rmvVUbMCh9ujE6UBaczypISQmEK
	 XlqIO53vJKLkfWtwp1ehLDW2XglZvbN36bIqzTAe4EPbZENnGEvVC3mOolZ56qrBqaOI2
	 m72CKvM/JBsF1jX3H+7WQ5ub4jITzYBbGCrkWVPCG2VqkgDDRkjN3wuWwh/KQtu3oSDlK
	 FfLjEF+CBiRXLbeaVnx8JtAY5wLYWUfRgaLoouDVZuTwpqQqzKV62b0lDzSRhI9I/6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304423;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=fBIq47AVLPInkagUxpJrBM82pb0jiiVwMQRNhW22De0=;
	b=tMdMf526nYFm/nz0mSueOyZzxgIbZGZ+bP/cFokLsUF4UeHAoJQk3kEDSeFjLm7ZLy3N
	 Ovv/kX1SBXqA9eFZo8DzUWOlJTug3sMscR2n4mGb/v1bYIm6wIJVQNv2vCnuj4Vm7d+hq
	 imT6uT5qtnW7MbgaY+l8P1XlBp4J4l4aFXkvcuGBeOcrQA1zN3QpAuC3ju8vtpZIzALeL
	 Yp0d3mUTXHXZQE9e06pGr75WnSu5/nN+qu3miyKwNDQWoWID2NenWyOwFsGuu/oYVSfyl
	 34AMenhdQNZcWaN6+buuzXh5XYxMPVs1Pn3AsZypUnVrb+Nn3jrHz9gvAt0itx1+5dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bnq8+Tm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17A2606A32A
	for <linux-xfs@vger.kernel.org>; Sat, 21 Nov 2026 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bnq8+Tm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6A51F000D0;
	Sat, 21 Nov 2026 23:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795304422;
	bh=fBIq47AVLPInkagUxpJrBM82pb0jiiVwMQRNhW22De0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Bnq8+Tm4cLyCJkZJdaLXguph7unBDAsT+t6huhGSZyCxMnyBandj2Bx2B9ck0fx9Y
	 5w1yrOD0wC/6ofgwhCETuHbOMil2zVJTJex/bl97Lup77STpyvcfk4pnI4VmjfSmF/
	 3Gp+SFPQ0R8srB2xam5I/OrRLrOFRXYBxnrKqQihlGX5D/AnZQdFz2WdvX32aM3FQz
	 hY6ZbxbCsKl2ejClpSPZNQgPGkH+QNbVRcg3BIbqk8orH+xwWIrHcfVyCdUdaNBQBA
	 tc0RHLYRqJIOYeHvohdJ8D9i7Vcx4EQcEh7Z+lxO3POKhehICOHeowNBCxIC0tnFFf
	 DTTfwFu14vTvw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B442E391B08F;
	Sat, 21 Nov 2026 23:40:22 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <awHueLf-qBHxapi-@cronus.toxiclabs.cc>
References: <awHueLf-qBHxapi-@cronus.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <awHueLf-qBHxapi-@cronus.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.4-rc4
X-PR-Tracked-Commit-Id: 855abf2cf8cd69a248362ca4b518de9387dd6bf5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f802b6558eb81bd5888d761a0cdc8afe5fd8c941
Message-Id: <179530442131.1212204.10423909461248747629.pr-tracker-bot@kernel.org>
Date: Sat, 21 Nov 2026 23:40:21 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 21 Nov 2026 20:42:06 +0100:

> git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f802b6558eb81bd5888d761a0cdc8afe5fd8c941

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
