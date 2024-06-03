Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133BB12EBCA
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440630; cv=none; b=SuBnnsUvnhDfUimfKXXobRiwcU5oLggvhvgeTvE5ZvxjxLczy15G/+kRFfG5GPE3krVSbDWOe8YJvBgc51JhF04PfouEEkkOHXZ7rs09uXTWRhWhrAznd+PZVPc+ucpvYCzgcyVfdKajgbTLh7jsPHGJ8vqa0lw531PGbYTskbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440630; c=relaxed/simple;
	bh=ni7VW+kTRCgB3lKhoLu/NmaAGU/BXbIfGBwUToTEjWg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6QGY4ouWbQqj0vIdSn3EM83KhX3nCbdRqjrOyA+05Dl4xIXKAUhC+or0LCd7UkWC801HrnW7TIst7MZsv7/qqAAbciGLQPc+1fUp50ItmybUsN7zdeko1JyyFje3xMsH0UIU+LSKUgjFhDIhB4Q/soSedBrDxw7diKmSKg5DCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xhn2eFU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xhn2eFU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4512C2BD10;
	Mon,  3 Jun 2024 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440629;
	bh=ni7VW+kTRCgB3lKhoLu/NmaAGU/BXbIfGBwUToTEjWg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xhn2eFU94GELjqu8TUjgX9xiwnkho31SsxRoubqt0WQj3h1oW2diiYSk/N+vueKq7
	 Uj4yWdsFxFX7wXy5378WyyEf5FCcuvJfcr/DpmVLqPWR2HlfynOQrnLADx3om070c2
	 KeXMUtWECAxA5j4GEXNGR84n8XVetPAvOsmcB7RGaG7ZOeyZqitY4S5BSj8CJLKa+T
	 EUos4ZXrcMDMVUako/8+twbEEqz260S2/YopBtyaexY3f+yRm33KEFG30Xo7CQyvlO
	 EKAztzwFqkGi7T+9WoF+HaDC92NMMseMA3RcjsaUAvaOyi/CuGrQ51gJdRdrmyrWf1
	 hukXMA/btyfQQ==
Date: Mon, 03 Jun 2024 11:50:29 -0700
Subject: [PATCHSET v30.5 07/10] xfs_repair: minor fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042742.1450026.8930510347408107889.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix some random minor problems in xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes-6.9
---
Commits in this patchset:
 * xfs_repair: log when buffers fail CRC checks even if we just recompute it
 * xfs_repair: check num before bplist[num]
---
 repair/attr_repair.c |   15 ++++++++++++---
 repair/da_util.c     |   12 ++++++++----
 repair/dir2.c        |   28 +++++++++++++++++++++-------
 repair/prefetch.c    |    2 +-
 4 files changed, 42 insertions(+), 15 deletions(-)

