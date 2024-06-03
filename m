Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32912BB0D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440582; cv=none; b=s+A81zX2nXd8WBf2PVLum/SNKtp4D7FmGf9hCRuakRfXaVPCOpCJkneZv8wtHusLUztxFJlySJ8xgWG7NUqSIEbw7XP0SoSSIt+kce6tKvk0Uh5LSRJECGe6/OU6CkAJPQL4f95ZmP5Y9t9aaynuWuz/U9z9mUUPw0UkhGZrI1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440582; c=relaxed/simple;
	bh=jijeS6SC6glwkFyCIPJYe83bkqkjIj5N4DlpiyMJnvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+gSFo6Cp/wZy8KQHFyWaIxvzT40BTjbFCi+FukbrD9KtCEF3evZ0U/FWR4Tr3HRapo/WtaXsBBRauMI00tVduJl5LQxy5r4nlRdNRpmg+aBD4ScoZ21EY7lEKsHnwwNeaPesdnYMRUqOzfMftCt+aqVMWaLC+uLhyK51G8ky9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFxEPLSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFxEPLSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986D8C2BD10;
	Mon,  3 Jun 2024 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440582;
	bh=jijeS6SC6glwkFyCIPJYe83bkqkjIj5N4DlpiyMJnvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TFxEPLSc0/kyCAmkd9d32B0uBrCJ1orOKzBN5ZKob13w1ytfS0EaNZJJtZXIjoXuL
	 EUU4bAVC0xrq6CrP0HPnX2EPG3og0MZiXDAuflmTccpbrocIADvYWK3gYPKese4knR
	 UlRy6EZXTLzYdeuMmFVFFV857WkRm00NYqTO4O9aJ374zUlNQn+614qHIBOuf6b0C6
	 Wkup4MFc3fIOHU6Xh8tO21bQebNruQO9rugTDI8yNCMe5YN6NlFnsG7eG6P3/2EWkJ
	 Nta6r96hVzzfglRyOcrY0lmWOJliBS5sl277GEqbsNN4fIfH7yZPOS08VxMYweQd0A
	 4FrJydHAXRVbQ==
Date: Mon, 03 Jun 2024 11:49:42 -0700
Subject: [PATCHSET v30.5 04/10] xfsprogs: widen BUI formats to support
 realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744041730.1449579.11894722565578033409.stgit@frogsfrogsfrogs>
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

