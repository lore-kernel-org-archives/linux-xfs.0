Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C11B2FDC27
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291246; cv=none; b=i9J78ANZdCwgBQY5qsw0CN98Z2ZONpvynUsWsgNIhZqbFP06g8/WZyaagBxk9/XNdeK9TQZhSCR9AckDCZuXydAnoEqJZUHo/K4AwRjqQSjTqYwwTF7eHPV9t1TOK+yfQ1NMRkEYZl10Okxxsoj/gU9cHiPrlIN7/b/DnD87YhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291246; c=relaxed/simple;
	bh=ZlfPQWsrT2vUkC3ynBsHs2IKg5OOR5PRvWo5aMa+kPU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BC5sZP6+VRG7gKlKdaNpvzh8f5LL0y3sIJIwXNIvm/bItf4DIKGxWshxWRXQPeNvnmULTBWswy7ukNxa6MJXZbpH1x3a5kVns2i7FCBo6HSAy3xxs3XToR+np8rNunDPl+2VCDozICnrfK2iLr2PAIAdpPJjsPKSBwIncAwScYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srNQD/X+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srNQD/X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADA3C4CEF7;
	Mon, 23 Mar 2026 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291246;
	bh=ZlfPQWsrT2vUkC3ynBsHs2IKg5OOR5PRvWo5aMa+kPU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=srNQD/X+a2zc2KKhZVTT5Bu1y2MLoDucUILno5ZBrXkug5CVwWPsyC17kTabPYpv2
	 rg83wfztQulCBbKYtSJF/x63FfdSaMJt2J1opy2wjDbhpKBPOx82UC8XHpItDl9b19
	 xM2QVRNS0zEo9EVhg8VUMevlaagLA88DO9vAmnBaz4tlSj/NaibYzHEU+NOCowTs8c
	 VnOrhZUhx9nEw5bNB/yXYVAcqHpLwllZ60GUVO5ruRMIOVwN/f2K4ZhOk8NRm1d8cD
	 +s/tqXfznxzhBw4JHRiNNWgyxaT+tba0f1CvDMkWYTbyi6RaOhr/gplVkrBNCvYZlf
	 T0cPyYA/htnjw==
Date: Mon, 23 Mar 2026 11:40:45 -0700
Subject: [PATCHSET 1/2] xfsprogs: various bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120286.2266172.6821817395168865287.stgit@frogsfrogsfrogs>
In-Reply-To: <20260323183941.GJ6223@frogsfrogsfrogs>
References: <20260323183941.GJ6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series contains miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
---
 repair/attr_repair.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

