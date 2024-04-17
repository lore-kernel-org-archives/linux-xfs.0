Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820F518C19
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388609; cv=none; b=kFxwqM2l1COTdt3o9YqpH3r1wtowJ6Rouu9CQLepng2Tm+QGXMcOLmm9vXHvssXSGPCB8dt9su8o6Ect5Jm3hXtHu0V07prsJfYTZSo/MFY017NBVN/kqJk6EdZsvxxFSTedqTa4c5n8tpZ6IS3ZpO9mRqpt58vXBr8Jq3hfxWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388609; c=relaxed/simple;
	bh=gm4ogr6RpChMQPI3P8ABAQJC1I4MIejqleltiVc8kGU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PhTONyHYaXIqFmwpqZgKdofCriSrcWjAJDmrSczvN2be+Jn5PCRtf+lEwriG6ZL4G2LFpF89W3NPnFbvucANedN9OFU8qqUch0PLqTyXS58tvHyE/qk2esMhkON1aCxbwoLp+wW8126a+BXKDIMRFyGBq2+zpcebYlGyZHoASD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVffv5Tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVffv5Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277ACC072AA;
	Wed, 17 Apr 2024 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388609;
	bh=gm4ogr6RpChMQPI3P8ABAQJC1I4MIejqleltiVc8kGU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PVffv5Tpps8nPWFvRbsFeKR/zYXPGGmsr0t06QwOj69Igb+ORylSBzvRMQBbiMRlw
	 xSQT/EyTIPfeGiVbqzYKJrugXG73B7IsdIpBCm/S2dLizQkUi5d/TDqC5YLoovfZTt
	 tRVQZECpEegEJp9sKUrjYKU5eNR3S9J4aP1IQs6YsEa61rcQIfCvHJThgp9lHFmjvv
	 3VXzpet9p2vpE9AlDhfQqDlHr33C5sP8XAalwvo8i5cte4st552bNVeQTq+nuAOGnh
	 eFBGH5J1We6cDouxQXdMDeG3vS7Fl7bvCE5FgPaaXesV9q3cZKK6YaLhhAyEit/R2A
	 AaRKtC+EJkpww==
Date: Wed, 17 Apr 2024 14:16:48 -0700
Subject: [PATCHSET 06/11] xfsprogs: bug fixes for 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

Bug fixes for xfsprogs for 6.8.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.8
---
Commits in this patchset:
 * xfs_repair: double-check with shortform attr verifiers
 * xfs_db: improve number extraction in getbitval
 * xfs_scrub: fix threadcount estimates for phase 6
 * xfs_scrub: don't fail while reporting media scan errors
 * xfs_io: add linux madvise advice codes
---
 db/bit.c             |   37 ++++++++++--------------
 io/madvise.c         |   77 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/attr_repair.c |   17 +++++++++++
 scrub/phase6.c       |   36 ++++++++++++++++++-----
 4 files changed, 137 insertions(+), 30 deletions(-)

