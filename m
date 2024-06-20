Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3612BAF3;
	Thu, 20 Jun 2024 20:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916813; cv=none; b=Xodm9VIZBoJYP1bnDjhgenTTjD42PraNI0bqeNRnej8MqAqgh/DeyW+RBOeV/wHm14rWwksFnekb2onXYeuQ/aFRNgwLgdBGcOt+Qj8fZ9apxF4vXUTxurPiQb2CqlOtrH3IZ7h3M22pIEl7FxamDu2A8MUlehc/NOrZwFc0W5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916813; c=relaxed/simple;
	bh=wf7R1ORnurTAZP9wWfMnUf2F6Fg4KJumz1Jn7j2fhcI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6fkc/3ezbnmKkAqH3nFEqXGVQFmtrjsA9pxvYdj4xU3vF0bKbkRdqVMa4W3+xIozqy7BgQnFp1rcBnTLMPcWCeNFQ/SKlOpwITtVXzYdSjHomHwUPjAUaIdhBnbqgM3Jw+R9MM2jVFDIUqXehRO1ds6wbEHy9UQFkny/hdroGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTKsR82i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTKsR82i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8662C2BD10;
	Thu, 20 Jun 2024 20:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916812;
	bh=wf7R1ORnurTAZP9wWfMnUf2F6Fg4KJumz1Jn7j2fhcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MTKsR82iHSJmjss4gaPpH2iLxbp9tSkX7FZE0hUWXMryjJAyvpptKG+gFc6ZV3P0n
	 4ytZ7Cd5KBfTfsJroJS/dXuYyOcvtmJzAISIbfjpNDSB2XTgxGM70WujvJz0lZ7EnQ
	 aP4db5jFz7HFqzXhgvEB0gAdAIYiLZVgl60nQKpZlNKd5NeOGZqhlNUJMJ3I3KUVIg
	 sUR6Asdk8l4h5q4MeL/scAuTppo7veeJZpyC88cN4fj6ntGFxK9ePCHhR/V1tNojLc
	 FIqkdvZdeeW95qi6zdr34xme3vXX6oTDMBtHK3T1gxMhNj5oig8bW3AVRCF957ZpUN
	 02eixvxLfDdEw==
Date: Thu, 20 Jun 2024 13:53:32 -0700
Subject: [PATCHSET v30.7 5/6] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891670520.3035797.9407325539574639419.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620205017.GC103020@frogsfrogsfrogs>
References: <20240620205017.GC103020@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
Commits in this patchset:
 * xfs/122: update for vectored scrub
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)

