Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793987022;
	b=lMAokFZUeYyiq7BXYZ1mC8NyVLxHnch5g11X0hvRA87pyeNoRmU2O60Ry2emMrQZBGSS
	 coL7sE9lh/4+8HHB10V29+FLZ9sNEg3B3e+x9K0bFdOCPoE0tP/+44zEwptxE4A988RWZ
	 rKHgNDMznv5bqCOjLlDf+4QPZK8iG2O6Pp6iihklTKwoYwFIrRW2H1M/+kbMbtUIxs7fn
	 WhGYO6UfsrR/okaFLlYBnUlbEYlqk9MgFf6DifDOV+sb/rip9fXUt/1XsMF1xNFonHUmC
	 o+7mqmSybpILSeA5vAT8A2+M1VkotTFo3uXClOMtiGUIOw27GX7OJlyRPkGxLZVoyiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793987022;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=NsZVTThYUHlvUgIZjnejLQycZxHBfURsSPrwtVeHbik=;
	b=InybtYl40z+ogEtKVLUgWghaJOCfQyxGB/xarMiuwNr7Bh0EmoDh+w1Qbn4RXg6LZpZs
	 2Hn2OM0Sj/LuMw8y12Zwoe5kenLL3fyc8BMwo9/aP60kdJy2MWkXQwvodqD6I0SRX/f8p
	 cd3iJcugS3PmJwC5oQpakdEQqsRcJaOKJ8fUx4uSzwqb5Eib98Ggm+sLd+Cv10exVLFVf
	 ga8c++rrLZ+J8XL75jRt2JftJ8tf3biTQS1dknuG3vPvTfVgzmd+/6wdnopmlqp2nRO0S
	 qk4/RWBnGABx/jhO9m2ysKgFrZZz7uIms+ZFUC+M2Oigz2rnSMK+bfIuD/ZeRDU2o/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sp94VYGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E94606A326
	for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2026 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sp94VYGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E9E1F0089F;
	Fri,  6 Nov 2026 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793987021;
	bh=NsZVTThYUHlvUgIZjnejLQycZxHBfURsSPrwtVeHbik=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Sp94VYGlRG8K6q8unXH1ult/hinGEIAvShs58DSrMtphbAcpRzaPaZPcvkgGh0m0D
	 r3WpObYPxSQKR+EarpK99Ken8IEN799eYSj/F0XZCAowzvHSjLIlEvXq+10zJSQ2kY
	 UfQrjCLCViPxlge6xDQk5NYiUlByoqKBZtfWWaQ64iFhNyr8g85o6OWrtJt2I646kD
	 ldJiDDa3hptayYG66a/fAd4cNWX5x4OyMmbNUp3OSiBEjddrWFWrtK28MDG+YCY8nA
	 FYzgbVPIv9geC/yQ1uL8CE2HM+D6uD9Npu74ncFwWPOPIopP/ETQHSg/Sre5/VOu4r
	 QfNDJLJqv8NYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5E2893A41005;
	Fri,  6 Nov 2026 17:43:41 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <au3QTc4bZbvePBT2@nidhogg.toxiclabs.cc>
References: <au3QTc4bZbvePBT2@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <au3QTc4bZbvePBT2@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.4-rc2
X-PR-Tracked-Commit-Id: 7ba9663607b31108b4350b604a3c85ae86c67c19
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ccc72d4b3fcf8c79178b7024541e1aa694e08a7
Message-Id: <179398702005.773298.16957740212495265960.pr-tracker-bot@kernel.org>
Date: Fri, 06 Nov 2026 17:43:40 +0000
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

The pull request you sent on Fri, 6 Nov 2026 14:45:52 +0100:

> git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.4-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ccc72d4b3fcf8c79178b7024541e1aa694e08a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
