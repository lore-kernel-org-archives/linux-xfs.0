Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477C19E985
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636017; cv=none; b=qHot4YUf6vL9YpWC55cr5BBLBrNH0B5nTQXrp34lUNz/b1aaYXjSpg27nZx+Z2wD+q85G2WbCM4TLHFgxbjBmyNdJyuRCn7yMF69+yzIdUaFUanGjc75kOvIWXjW5R47r0oM2sQ5qxK8SmVlmv1x2DvN4TtSieETJIoRO/L9Wes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636017; c=relaxed/simple;
	bh=DvohCED/m04lyihUpFjPwPEpug7ZsQTeDzNQNTx2TqI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c11bWoUKklaAVxrARIkm1CHLNYwaF/eR4eR1T0J8e80skPXS8YtEZpbuaf3TPV/1m8NlMHgfQ6O81vLyu1iG8kEdXHqVJzxJEkqyo7IYv+poncu6TYLHaQMrIKl7SrONEECiZCmPWzKyGlvcCnoYJ+kxKUY7ibPQvpbMvhPIHDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S61b7DqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S61b7DqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA340C4CED0;
	Thu, 19 Dec 2024 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636016;
	bh=DvohCED/m04lyihUpFjPwPEpug7ZsQTeDzNQNTx2TqI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S61b7DqRQlfUS8Mg8+J+S/GNi07wPWp6xAWLXvb+jmKPLsVtxFEDlGJqcswtb7/gn
	 LQf85BzC77z3+dotettfoEQLxRBlc5XJeD2WYo4YCyvxh3u+mixn5MikzfQzJHaC6L
	 MCTQecQM1D+nVK4gLhfTvHf+OM/L8ZqNda/hqr46/dO7sgeWHpurS+zDgEOnpVAP0V
	 INvhZXUe+fOJlLGaA9CCfxeKOVppWYKXXqzZRaOAxvXbTLi/us8mE5JAI5zHzYEGwB
	 Om4JDS3YHZg0xYxNDNJxeM77DI0S1G8MXZT/UKNgVeuUUpp49ZptjjfSiNuKVmspl4
	 ZmXcNv/4JMnzA==
Date: Thu, 19 Dec 2024 11:20:16 -0800
Subject: [PATCHSET v6.1 6/5] xfsprogs: last few bits of rtgroups patches
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
In-Reply-To: <20241219191553.GI6160@frogsfrogsfrogs>
References: <20241219191553.GI6160@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Since the rest of the metadir/rtgroups patches are ready to be merged
into xfsprogs 6.13, this is a funny little series with a few straggler
patches that came up during review.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rtgroups-stragglers
---
Commits in this patchset:
 * xfs_db: drop the metadata checking code from blockget
 * xfs_mdrestore: refactor open-coded fd/is_file into a structure
 * xfs_mdrestore: restore rt group superblocks to realtime device
---
 db/check.c                |  294 ---------------------------------------------
 man/man8/xfs_db.8         |   12 --
 man/man8/xfs_mdrestore.8  |   10 ++
 mdrestore/xfs_mdrestore.c |  162 +++++++++++++++----------
 4 files changed, 112 insertions(+), 366 deletions(-)

