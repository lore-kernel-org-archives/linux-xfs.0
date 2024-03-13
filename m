Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1960CB652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294471; cv=none; b=XJVL4n8ZLG3XR+YLYzWxo8MD8Q7nPR0rcWwGDmWYwSy+e0yJsAZfAPlS6FjPsSZ5+EC+Qc9oZrZUq00FUVwT0RyOfc9o1riQrRojezWiUxUszuX9OK9MRokUGz14kUc1qP4vcEF04+ZYtgwkFzt5vTkScRZyNOg7kFBuKs3jBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294471; c=relaxed/simple;
	bh=onBqUr9TfULye4LJABGUSYg4brOfMPhkvOpLRp9tCT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+RdyMLjyUERHEOBQeFaSaiFS+SsI7DFqclKDK8z5RWc1anJfEXsg/+Y7U1bJO81RLjQTmIWYFcKAvl9+NPpPWutaXsoIwFjp9ZQ+JdTxvM+YFTJZsBjMNytPzsCkcoI1j4c025dsK2dD5vUAAvZUjEjtHp5OWOo5ZubgiaOaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9NGTadX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9NGTadX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918CFC433F1;
	Wed, 13 Mar 2024 01:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294470;
	bh=onBqUr9TfULye4LJABGUSYg4brOfMPhkvOpLRp9tCT0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T9NGTadX5K6KO/M4Wj09a0JlCAb6pgnkxh+8H0FqyD5A6GnJZk+gQw2LboBYq67Re
	 XOi+Lc2gERUjCA7C9MaYW2QfIqXPii9nQntn5wZUK297THJLZemUs36rLUTDqprb1E
	 Oh/x7AvXn4lDYZmnQ7to3SXzmtR02Bdpw+xtvKZEI4Bt/Kiu+q1z7LR/PVKIn5OG87
	 gQtaC0PUa9xPHOIVh60b/f+iF/l52DLFkK2Foj2LZfDC7eJeVj+qpGb3r/Cj+Vq87o
	 RNvyf4O5VEXuSIZxO8Ouk8C5pAD7tuihmcX76gopT8GbUW7OG2ueXdMCj5WS8F7xwK
	 SgtgE9ENIGsOQ==
Date: Tue, 12 Mar 2024 18:47:50 -0700
Subject: [PATCHSET 03/10] xfs_repair: faster btree bulkloading
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
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

Two improvements for xfs_repair: first, we adjust the btree bulk
loader's slack computation to match the kernel.  Second, we make the
bulk loader write as many records as w can per ->get_records call.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulkload-faster
---
Commits in this patchset:
 * xfs_repair: adjust btree bulkloading slack computations to match online repair
 * xfs_repair: bulk load records into new btree blocks
---
 repair/agbtree.c  |  161 ++++++++++++++++++++++++++++++-----------------------
 repair/bulkload.c |    9 ++-
 2 files changed, 95 insertions(+), 75 deletions(-)

