Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA47DA95;
	Wed, 19 Feb 2025 00:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926141; cv=none; b=TN3kiU5lD3snO2nV9vh2eRhyNoHcZfI+E2bx+MJbyqR+Jc2sNe6CwB8cbRlwwSJPhz3oqV7kyXRXmoHI/I0u1Ttag5xQ7h6F/tWE/pQN/fjlgM6ipnkKVx7R3cybhqTwfbciVpVmr130of4wAKLeOdpR5fQ+hwb7vyxcF9RfgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926141; c=relaxed/simple;
	bh=628Yg7HRHNU8WEXTG1C7sESkvQBQqRCzYDJEJcwSULM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2fvBr/GfD3Io0UW/R+2QUOcMkStqZKKS22yrU5N7dYA+5+K6mY4N77eu2uuXzLLqU8YNvTOukq4Q971C+oiIvj9NBznP9t2MUlHUxwvRB5HAh5Z+80IpsNKb7m+AtXl0qB2Rj8sMqc2D+0p6utzl5qTADtUyqjWPSkznDa9S4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1RWBEYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1RWBEYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9471C4CEE2;
	Wed, 19 Feb 2025 00:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926140;
	bh=628Yg7HRHNU8WEXTG1C7sESkvQBQqRCzYDJEJcwSULM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z1RWBEYD7BYJeamewsyMXXcUOA7cg1KaVEuQf0+JtM5X9sRxbgQIO39ku1w6am4NV
	 rJKO9eoATtS5K5RL2tM91DG/oN8mf3ytQYNSewZfRBVgyu3vh2oGhSAJfI66Ha/cVb
	 hIJgPBjgKxS52zQvubUpIgCP/DBb3AkrlWbKfzthBtGjj9iWY87C/g/QeCX6jLdZl7
	 VSuI5IAF8D/tKe/LRjQ0l/wT7/oS3cdyBBpxgpbqVA8kVV2/v3jzHw/jqbwBg++vV2
	 YMPNgi4OAp6481ihwMGcJMiZG+FLRiMchg7csWa10pw3DZDsfeI8SQ7IJYvlkVFd++
	 ti478/OQlj7mQ==
Date: Tue, 18 Feb 2025 16:49:00 -0800
Subject: [PATCHSET 12/12] fstests: dump fs directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992592211.4081406.17974627498372247228.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a functional test for recovering parts or entire filesystem
trees with xfs_db.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rdump

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=rdump
---
Commits in this patchset:
 * xfs: test filesystem recovery with rdump
---
 tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1895.out |    6 ++
 2 files changed, 159 insertions(+)
 create mode 100755 tests/xfs/1895
 create mode 100644 tests/xfs/1895.out

