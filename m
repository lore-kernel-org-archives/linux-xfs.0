Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6447B654
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294486; cv=none; b=oEFPAFX0D2K9moLGS7ZgAFFtg3nzvpanXWBYx7dbTcHCpNjH0Ud9kfZ0GhQRGZQw+YrQ/9rttYPfCDwUQBdui+BJsNmNSOTAI6ogX33YhCNpkRFfUja7tmfGC4vITZ21WgOfv3FJXpD6f/qNnUWUvJS5+WUU8gVLmr51rsxfZAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294486; c=relaxed/simple;
	bh=RoObuCb983gNX9rN8WxGakoih49O1aKttllztD2V8xU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PwKfUK2gPoNvddG6rQ6W+2t5LN7OjGU2lcZVouYLEFeplNPBajI3YXnH4+2SCrxhnFXGGSSqECsNHYBeRI5ER5QkP5dwu/w0KbOAwKnFUoeExRRVQ3i1kQgJ4gTaOz11VVKeXa8O9o55Vx+cqX3sHSYnPotDMWJEKFt2zaFceu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6CVWoLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6CVWoLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339A8C433C7;
	Wed, 13 Mar 2024 01:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294486;
	bh=RoObuCb983gNX9rN8WxGakoih49O1aKttllztD2V8xU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g6CVWoLgKNHEUcTlOyLh+0aB/dP6RdLO5XuaI62UFLL87XqFkBKQV+qdJoIlKfs5W
	 U8aXvGFnTDUNvhZkUzqbX+DpcTR9Y8oa23jocGNqVkSppAJdmMZQJm/V5wZ7VnBvud
	 WzN2HV8BWZPJxqwFNBzgV7rAmKRIHA1aA5dv8Jdl16oTxh540XCSRtJ3PbO4BWCYyk
	 GWmK/H5fpmtxt3/rhYFQ5X39Dqo6BHYrqVigrOfad54gQJ041zS2o4/r8hMulBqSOW
	 CLFeZxEoBYqwqJcfxViw0P+h508nxMgOSZqAd2RbdK27sU3gV9u5zs7xZQIn6MLW4h
	 WMT8rXifRAu+g==
Date: Tue, 12 Mar 2024 18:48:05 -0700
Subject: [PATCHSET 04/10] xfsprogs: bug fixes for 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029432867.2063555.10851813376051369769.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
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

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-6.8-fixes
---
Commits in this patchset:
 * xfs_repair: double-check with shortform attr verifiers
---
 repair/attr_repair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

