Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04C333C9
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716345985; cv=none; b=CuLJOfrbdSnNrIIHZ0YtAfWSZNbacGwnrujosXRH8YKpTFAMos9e1xj6Sj2uDCzoaHo87Mc9oOF19rsaoVwOJuo8BTKC2uYpev2gfCDk+Z/UIYtkE0Fas5y3oSWJyYhyRr4iMGtsUrQmj2oz0iMP199Bg46s1GoGYG8ozmDqu8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716345985; c=relaxed/simple;
	bh=jijeS6SC6glwkFyCIPJYe83bkqkjIj5N4DlpiyMJnvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNug16xv7ZhggJNM6d2PNEYQ0227IdyRUgAGf5jOLHxx1TFS7wjSlK0loRf89Po5+FBaPcvw18f/xVAtNVC7yWvc+MnrFFrxlePFXvEqrpHe3gnZqvPF9Ol4odlBpl+/t24lZ0W80qEmO+xC/4kxOno5Y99Cp0IFgr2BCHM2QFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIl9sQ3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIl9sQ3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83020C32789;
	Wed, 22 May 2024 02:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716345985;
	bh=jijeS6SC6glwkFyCIPJYe83bkqkjIj5N4DlpiyMJnvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aIl9sQ3WzF/Yc43voCAtWxm4n5M/1ZDzOxlN9DnLX3aJSKL9NJT7yghk/HlxQXU9C
	 ir9zckgpFM0qHQ5bqoxhXaiBiu8teGATWSwxrYrFJMBJ64lrTRWeP++beSVCSqFJDU
	 48rECCERWIKUlHJEUjqMc7SJ7shX4xC//Ki3olTxNRQo8m0p6FVclaqmbH3t6idaho
	 jMxJc3gtIy2YXRUsf2Yi1PsbOVfCmXnV/y0BUdfdzSuUT4m8IDLsp+f2/L53bhbSQV
	 IO/OTgkxMHolpC4sM3EtEHsyLNtC5iCNb9RmnXIrmHykt7paEohG8EZHpJAZA+NJfE
	 6hZZaRSsI1iTQ==
Date: Tue, 21 May 2024 19:46:25 -0700
Subject: [PATCHSET v30.4 04/10] xfsprogs: widen BUI formats to support
 realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534079.2482738.13797016573790493405.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
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

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-bmap-intents-6.9

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-bmap-intents-6.9
---
Commits in this patchset:
 * libxfs: add a realtime flag to the bmap update log redo items
---
 libxfs/defer_item.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

