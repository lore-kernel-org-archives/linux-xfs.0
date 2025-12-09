Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC07F19D081
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765296963; cv=none; b=b0pocOlYQfpn5Vo9nDovzy6DQExIQrrnDTIvMFGXW4TIlWoh4f11f916gyL6t7GeXtutg8fvUgzePnx2XOq/wZKkTo1jCSLjJrah+xuHA94uFmb60l1d5AsP39utadUJLO0DD4YMYMJCYwVU8jJAAVyFXe7CIhs6aIcHtDj18XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765296963; c=relaxed/simple;
	bh=Tfd7lSWTLNvPiZwZSDTwX1qApmQ/aK7RM4Qoh7isZ7k=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=sTwNe0EImJXBASKQsGackjEaUIDJ4+ucAXsaiwa3BbUQg75e4XDw+KL4ulJgUiKkfVBEYeR/XDPGu3xMgZKbdAX3nIbOx9Rgr5f/NsVDPhEXS6XPS+hCkpT7jcB1zw6QU/tSPt7DWw9bo0WTD/P+0qppymTtUbzf2OVZLntuzqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DC6ree0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DC6ree0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7BEC4CEF5;
	Tue,  9 Dec 2025 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765296963;
	bh=Tfd7lSWTLNvPiZwZSDTwX1qApmQ/aK7RM4Qoh7isZ7k=;
	h=Date:Subject:From:To:Cc:From;
	b=DC6ree0OBlec4ml08GtjwV0s0udioL2zIKOOT2COEB7cR9Bjbs7lkY+scmuhWXq62
	 X9Kks6Cg2jA1QqvAEEK2mln6OMPvkYQeyf4P96qie/ETlqjPcd4vGI6C6nzSMUH2US
	 Co84yVpekJsTw66qPXFOqD6TppK8c/Mt28gaaWeXwWHYKgVinSUEXOd80sRb3yVMQ/
	 3JlqbHK5uux+zueJDIMYlpOkhQviWHJFuqWN5TF2IxMLx5YeSalyU7KW9tjQOrgMtB
	 Rg5NnvrbiDYCC7mrD3sgbPdUfzQuBZ9jqg6KnLu0K78Ns0Jp3/Wg2OTWqRSxQxjTTK
	 NmO9O3bD0EP1Q==
Date: Tue, 09 Dec 2025 08:16:02 -0800
Subject: [PATCHSET V2] xfsprogs: enable new stable features for 6.18
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Enable by default some new features that seem stable now.

v2: include performance implications

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=default-features
---
Commits in this patchset:
 * mkfs: enable new features by default
 * mkfs: add 2025 LTS config file
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.18.conf |   19 +++++++++++++++++++
 mkfs/xfs_mkfs.c    |    5 +++--
 3 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 mkfs/lts_6.18.conf

