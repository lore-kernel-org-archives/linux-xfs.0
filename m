Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59E170A16
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837917; cv=none; b=hioN3HQ+1iBj/QIMOhx+80gIkPzlHeUQAr6FLkbwx5tpsQL9cmP46LZz2ZL+ly5/8M9r5lLFK32NbHfUm/BoC8BYHgGBNs/J2LLBe976oZN+3cGDqtcnE1d3wDpLN917UdU/EhqzU1LcQPD7LwIInjQWvjRplJM8saegdPUn6TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837917; c=relaxed/simple;
	bh=3c8idNWl98g7ejLZ75yWlayva0mI92f2JclB4OnUHQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TXW6jjm9MuE4Lr2dCZYGxVLR13iK78TJCjDiKpDmBVFH6VOdOa7+GtFK/yRp1WmpigmdG+IPe+y29CoyL34+CItedZ3Pa1/zSXNjrPBae6TN4mwQgGPxIN72CQaYVRCSStwQQ/TIUmeAStGbHp42YvLCrdh/Yg4Xk/fc9+in/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1Y+d+jG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1Y+d+jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A534C4CEC3;
	Fri, 25 Oct 2024 06:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837916;
	bh=3c8idNWl98g7ejLZ75yWlayva0mI92f2JclB4OnUHQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z1Y+d+jGRzHQCiZWvgX9gm8z/+QsoGVg8bHk+hIoDt/hdBKTAe1C427fcWos3Cc52
	 72GzqRD/D+wF04oN5iN15lA8wRYBAFnmIUko2AWBck3oRKtGEd045MxUWUnY3orRBQ
	 EZeYfCsjaBkaV/kRAggSzkYWbVx9bt04QHAG2+wp9ue3H09tHsIImvQClSuFy/2FpV
	 58xSgy7xjueJXnNL06vRbNlbIv6hbAJX6O2uZfjZlgq7R4XdUG9uQfrLym8IRN8+Bj
	 B94kfq5mqBBx6cQm2PGtNwzn/KJ/IW5YLIlnfr1e76EE3BAmBQVm3FgMtcTzimj/jw
	 1rYhHklqI6odw==
Date: Thu, 24 Oct 2024 23:31:56 -0700
Subject: [PATCHSET v2.6 3/5] xfs_metadump: support external devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774131.3041548.11544427959826174191.stgit@frogsfrogsfrogs>
In-Reply-To: <20241025062602.GH2386201@frogsfrogsfrogs>
References: <20241025062602.GH2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series augments the xfs_metadump and xfs_mdrestore utilities to
capture the contents of an external log in a metadump, and restore it on
the other end.  This will enable better debugging analysis of broken
filesystems, since it will now be possible to capture external log data.
This is a prequisite for the rt groups feature, since we'll also need to
capture the rt superblocks written to the rt device.

This also means we can capture the contents of external logs for better
analysis by support staff.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadump-external-devices-6.12
---
Commits in this patchset:
 * xfs_db: allow setting current address to log blocks
---
 db/block.c        |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)

