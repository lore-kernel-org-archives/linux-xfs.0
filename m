Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792551738;
	b=3BkwlW7+Kif/0bVzJFwF2VQU/3bnb3oL8875l0ZCpD8QPqK1DC6knnqfLGTu6a27uFDq
	 jzhGA5zV6LgX0OOe0r6p4I99YFJ04+HfDsw8N3enusC3N/jmFSwuP8v2I2Jnbm0NbsNDf
	 NeHL/pCZlLGc1D2OurmpFWA9V4DJKO/JPw9u9IUFQTlmkRY0yKx0JYCQVJEfyV5ESEDRs
	 HOZ3eZdHteiou1D+xgx4KmrmkDYh8X1ydteU+9I/XT2oQjW06/V8dA1WMvQWF4Jg5iIRW
	 zVasw6dTN6KuIAdYA+TFQtwQAicLMA5V0PjNw6SyCSR8pWmfSZCSuyPBKmBpn8eAuIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792551738;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=nHHZSe3QmOD4F0DnbBQZvduFt6eWUOc6f7+BT9EUuNE=;
	b=wB8CXNF+kUk2DnJEd9Z/eAMD3AePqm0bX/jJ/e/4TzFkvFxkFUPo7C9D8tk7tyaEi3Iw
	 1br9e7hC8zsqLHoKaOAx7w39oUWBb1p640hEGBBDGQ9BRcLKKyEb5cjZNut9jcPd3PN/O
	 mAAOCj5vq14Jm1ahPqnIVaUxnI/JSKhjmIPCxk7IuEUzbcsDir4GAhBRJCgazBfvUNWjX
	 YIdDf4ffIb3URuD91QiFku9edvBxZd25y50GGk45xmxxHWMtWZL9QBxN3PfbTqXo8VyYO
	 FBZNQC+YbJ0m69nyS9IJpxhD0g6O/5zOeoA2kULulEKQvoBQpp00Sn8aAOppy3Q/Mmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oEOO420q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4540606A333
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 03:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oEOO420q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C6D1F000D3;
	Wed, 21 Oct 2026 03:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792551738;
	bh=nHHZSe3QmOD4F0DnbBQZvduFt6eWUOc6f7+BT9EUuNE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=oEOO420q3POcH5iyxyI5cdWmwWcjc4/CdWMO0HNDP7JGrOFy/SPQxZLMi1tHZevKr
	 WuHuQwhKVJwhj8w0olUXJp5kYZkLEXcQ8oC/rvBmUlVPN0vvmHTmA+F72AYrSuD7TS
	 tHmfJXkWBO+vlhptSEb1SPFEaSwcLP7FrNdBq2cjgWwHoCTZ6t2aJB2Q4AspUzWS8X
	 nGa7FcStTRXVUKc+xtv3UTwrLVZqHfQnDtncEGNHCFe1EJ68vcvixx71876VqoeVw8
	 Flvyu9w51u6OyWO0fdKq1Cyiiwg8rmGks68h5c8FhmmL1cKHC5YtLSLuZpEZSIwFh/
	 xjQqKzXMDo6SA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 775903809A18;
	Wed, 21 Oct 2026 03:02:18 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: New code for v7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <atYYuPvLQkQvqESk@nidhogg.toxiclabs.cc>
References: <atYYuPvLQkQvqESk@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <atYYuPvLQkQvqESk@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.4
X-PR-Tracked-Commit-Id: ec8f62cc109a3f596b3c65dc0f1011c209239051
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75663f575f34291007852859486cafc08dc10d0e
Message-Id: <179255173699.353442.6197626875489524358.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 03:02:16 +0000
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

The pull request you sent on Mon, 19 Oct 2026 16:15:10 +0200:

> git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75663f575f34291007852859486cafc08dc10d0e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
