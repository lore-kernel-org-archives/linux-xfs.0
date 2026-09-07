Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400B3B5E01;
	Mon,  7 Sep 2026 06:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762600; cv=none; b=tv684FlIOItZ5aVGjnra6CIqMjsx+WP0/fg8eM0jEGQ3C/8lstM4HaHMU7LQgKy0ChX6u0IzkOJQqxEYuxOOUxYNAUR5Al+uJKDVzFe7T3iY2ENOgqV3oZbjPDGvAMc48WKOFDqgIx/0AtDfzsKS8TzvHukGxLUSuppNzKhb8+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762600; c=relaxed/simple;
	bh=E9QN1izrpSQpgyguPyCtfJkRMVqfqzfQKh1XYUOwJug=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dSzbRMC/W38ZaqMfv67Upel8vprsm+rmsuRyUW80uIQGwoAUu3jvizkXGWApTxyjFy/7JD7jRSbkMsVEESyJiCoUgNMNpdoSsLowQ5kf0xqo4XmR5vOAq4x1+erFc31qbYL9K2O1Cv+3sqlQXW7OuvjtgbNEUKvDU929axX3xpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCBxTH37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCBxTH37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DA61F00A3A;
	Mon,  7 Sep 2026 06:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762596;
	bh=4+0zSxh05j4/rYf3H3A3NX7tGsFnGSrP9yt0k2B7G1o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=BCBxTH37rY6A6E1C9MV7SJWPrs8DxDk6ABoErPZdyluwa8BZqoMmgnXKeVTLUSsrg
	 aCzU3sqOjBR9VaB//Thi7YmARdGNaIIQs3l2O1R5bzOlYFY44zurFkMXUEuwtnF+Dc
	 MFf9L0141oOpr5Bw1u9xEcXHv60mH+7sjU2bZhKFsLwuRa/AZB72pPawTcAYKTzK+u
	 mZ2wmGZ1PJ9tfagv7vos4oVaGFOJxYuD9wmc1vhHv4z5i0DOVNmZ8pgrfvBmmuasSC
	 DctUBNnTQPxq2j14HTdoUokIrbc910qvHHcUVvaDqqtX2pgP2eRXqSLvO8N1xTBuYc
	 3p001FnLHeXpQ==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v3 4/5] xfs: LLM-inspired bug fixes, part 8
Message-Id: <178876259516.14936.3457896459561009065.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:29:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 01 Sep 2026 22:41:48 -0700, Darrick J. Wong wrote:
> Here's an eighth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> v2: add rvbs, tweak commit messages, do more cleanup of healthmon lists
> v3: add more rvbs, address more review comments
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[1/8] xfs: always set xfs_healthmon::first_event when inserting at front of list
      commit: 58a0c7578b25b578c16dea7db2493cfa3a08ecc2
[2/8] xfs: move healthmon event merge tracepoint
      commit: 10b1d5fd7189986a0cdd90dde181089b4b2fe40e
[3/8] xfs: port healthmon event list to list_head
      commit: 9097f5c03f038cea83d174b6d322d7b2678a3c99
[4/8] xfs: merge healthmon insert/push helpers
      commit: 4c98464e12fcfe3a71646f8efa5d3f7f1b5e2bed
[5/8] xfs: check healthmon outbuffer space correctly
      commit: 74eeb68a628dbc4a8f976351ad2f1ef5463513ee
[6/8] xfs: bump lost_prev_errors if we lose even the healthmon lost event
      commit: 295f2cfd3e2c814c2ecd2c1d522bc31c5288e414
[7/8] xfs: report nonexistent parents as a filesystem corruption
      commit: 014c1aff607a839b8ddc732da919b94560ae58c2
[8/8] xfs: destroy seen inode bitmap when we fail to add a dirpath
      commit: 1a441c6842da75c5b862cc1c9f7969d6a93b54b9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

