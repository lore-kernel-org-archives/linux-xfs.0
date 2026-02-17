Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500AD211A14;
	Tue, 17 Feb 2026 21:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771362875; cv=none; b=MDIe7Eshyoxh0xSGa66Y1usZi2rt30RWFLr/ukc+ZxvfLoEybJqhqrj35CWm7d4sGKtXHEWmB0F/cSCH/9YL78/YvnfHst/HgvxwFsmiJ0Y7zcOctHoJCmQ7X08ik+hmna/59Q35L3PJAgJTDzX0ld2kb50Y0iqAR4aah+VZoOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771362875; c=relaxed/simple;
	bh=rF0onOkRJ1MrR79ZRlAH0saur24ktYQyPGIU00QVPCI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=s4vlYJAUJxVCbG4HZC/NMsScc+53wdsQal9ouS9pw7qn4AY7FEmyHPw+3CbnhMh6Z5YD2oMnc+qdMvuDe94dMDRrgrEk85zMtRgSXga5ySF2tIv/lIfg3Voj6UDOkNyW3cM2rbQie2tClN1/x8onV4Qz28b2h8OOr1YlrGSovrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obNAHU30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obNAHU30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0374CC4CEF7;
	Tue, 17 Feb 2026 21:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771362875;
	bh=rF0onOkRJ1MrR79ZRlAH0saur24ktYQyPGIU00QVPCI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=obNAHU30KeK7e4E+sJrNxIjHjieqmvasFe6OLCrFOzjIJ/x/ojJyR0JO/ZkJX3uKX
	 tbWWtrc5dHY8LwitoshVEtU/1kxURSuzZIjO8r6uOdGHN18+12Urb+dFuH67HYbwhT
	 DI/Yw/Kr77gPExDFVz6ed7SpTm8irFrx3L9YGbh4TpucAbeBjCbzUo8hygal10yJRL
	 xBSwgaiQww96d3ZVpu08zOJmu+zi9YB6vCrQNEcrYCrJQasyYZ2peWj5ctsXwB1q7s
	 4MajCpqM0F2EM1gDpyQG2Glw6Qc+6LCZgMx4vt+uN6/sO5VpYO1WkvlgkjKbwgyU8D
	 SJBJRAHiqaIeQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B0D13806667;
	Tue, 17 Feb 2026 21:14:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH V3 0/6] block: ignore __blkdev_issue_discard()
 ret value
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <177136286684.643511.2911265753074075940.git-patchwork-notify@kernel.org>
Date: Tue, 17 Feb 2026 21:14:26 +0000
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me,
 kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 bpf@vger.kernel.org, linux-xfs@vger.kernel.org

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Carlos Maiolino <cem@kernel.org>:

On Mon, 24 Nov 2025 15:48:00 -0800 you wrote:
> Hi,
> 
> __blkdev_issue_discard() only returns value 0, that makes post call
> error checking code dead. This patch series revmoes this dead code at
> all the call sites and adjust the callers.
> 
> Please note that it doesn't change the return type of the function from
> int to void in this series, it will be done once this series gets merged
> smoothly.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,V3,1/6] block: ignore discard return value
    (no matching commit)
  - [f2fs-dev,V3,2/6] md: ignore discard return value
    https://git.kernel.org/jaegeuk/f2fs/c/699fcfb6cb80
  - [f2fs-dev,V3,3/6] dm: ignore discard return value
    (no matching commit)
  - [f2fs-dev,V3,4/6] nvmet: ignore discard return value
    https://git.kernel.org/jaegeuk/f2fs/c/38d12f15c477
  - [f2fs-dev,V3,5/6] f2fs: ignore discard return value
    (no matching commit)
  - [f2fs-dev,V3,6/6] xfs: ignore discard return value
    https://git.kernel.org/jaegeuk/f2fs/c/2145f447b79a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


