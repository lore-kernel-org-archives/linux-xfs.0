Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FA06E2AE;
	Thu, 20 Jun 2024 20:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916618; cv=none; b=IFKdgsTKluD4hJA9/dfHnqSIjMDda6ozZvcJ9N+H0XhhQGQ52mf9K9Tg0PnzqDrpRoCjpovHMd5OBEAyW5nijmBgDaFtU9pcwQF5ht6/8InbZeKsuA2DPo863nWV1Tz/PsD2ZPTTbe2s1+Io3i5jkSaIXlxd7u2dV4diLMSZv7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916618; c=relaxed/simple;
	bh=XgYEiDUilycTw3C4AiC65gMhfCB6OH6RxW0C3KjVyXE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OkKqAJ3Ht2K42F2Io49x/CbgLtVN600DoarcMyTfv9IHfwXAtHRxnGFmHsKe0jj0JHt0mFOpLjQPq9loHm/3eTivDTwm+axzY1VEJNze1QxZWZXcFJpFP3L9vrUYRoJ/IK+TDxMZvTDW4lld3GkXkRMSNDm+lrpVG8QD2vpp3ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAEXwD+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAEXwD+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD52C2BD10;
	Thu, 20 Jun 2024 20:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916617;
	bh=XgYEiDUilycTw3C4AiC65gMhfCB6OH6RxW0C3KjVyXE=;
	h=Date:From:To:Cc:Subject:From;
	b=kAEXwD+0YLEt0/BEes5uitfM7DejY6xujma83Q19FrlN9XW6rvWQwPa4xL9ZOY0LF
	 /oV6rg2lSHgn8qJOrP9y8DmcznyIUB/aJsiy59T1eIe7O8IYE1S6u+FVNYnlyvuesW
	 PLTrYXA3VRCXt6oBN6pRVCT6TZl/rgOl2WleWgyD5H/c6kbZGfaYVxlzqln9IiIGDG
	 hYAIookgZBDNfmJx7rimRCsgI0bsUCkgfUYmJqWuEs7gpqjFopNY+nkP5t9iVU4w2Q
	 hEtjHZJDvsjolDxIjm0DZZn2Q3fCqckcvFxkirUUnIOacOlDLuo4GRwMIdiBOU1atN
	 Z9ABX3hdIF/sA==
Date: Thu, 20 Jun 2024 13:50:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCHBOMB] fstests: catch us up to 6.10
Message-ID: <20240620205017.GC103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This patchbomb are all the fixes that xfs needs to bring fstests up to
date with what's in 6.10-rc.  Except for these two patches:

[PATCHSET v30.7 2/6] fstests: atomic file updates
[PATCH 03/11] generic/709,710: rework these for exchangerange vs.
[PATCH 04/11] generic/711,xfs/537: actually fork these tests for

everything else in here is fully reviewed and ready for PRs.

--D
