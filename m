Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51742A94
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346079; cv=none; b=vDufdu3k/9ZM9ii6NU3OvuZWFR6dKIDg+DKQK2lGCJ7Ku9mIr5fH4F5mDcFuzAxQw+rz2fD618NwU5aVJR66gSb2tdctABT8zOujH5hEAIA3i1H0P+/nbL12JtNXZa7n3C9EBpwnQFAO8SXBskmUZHGqRuNW788gab7BMneeCaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346079; c=relaxed/simple;
	bh=v7K5vlRgSuh8iVZvQE2EOFW+3L/lMyVchCaQqMlAHWo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7ukfbZ20yqaurLAsAxRwFYF7hEPxkOu+okS/hWKkSLCErQuPZUzFZnQ/O0tEAWDR5KaVrr3JUFektNb/uPRziz+py3+OXWE7B5tpALAySVZfvkwPnfSKZKNebtfwV2SMoXKbpvTrHhwNEu92hiMnoEjmgZ0P/CRuV75rPTLsvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OO77Le2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OO77Le2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7903CC2BD11;
	Wed, 22 May 2024 02:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346079;
	bh=v7K5vlRgSuh8iVZvQE2EOFW+3L/lMyVchCaQqMlAHWo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OO77Le2/nM4S/8fd0JN4r0VPuxLP/XGUPiLxc5/jorsT8lpoVO867LIbLHaowYJF/
	 hvtrwn0NO30UxJhB58udNtfrTPNd06fDckg8Pi9b5ldugvfaWidJ7lGsl2mmO8Mbj3
	 /IK2PrQgSsAFgzQCzl2N681VAmOvVnrk5HGT300TuDgvVrcwAZKC9k3UhiMF8frQ+q
	 uL8zBNUyKBdc6Y0jz/QL3FuiAAWrkUacFu/SvpA4E2C1ClihKK9A67eh5ZAW+W1rjF
	 DrPXtu1RsWGOIs6Q6F4MrV70AFFNolKfbkt1+uO7HMlVwxspsl5KCvXGL7rENVlxSN
	 Frf00SOpx8wvQ==
Date: Tue, 21 May 2024 19:47:59 -0700
Subject: [PATCHSET v30.4 10/10] mkfs: cleanups for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634536154.2483724.11500970754963017164.stgit@frogsfrogsfrogs>
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

Clean up mkfs' open-coded symlink handling code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-cleanups-6.9
---
Commits in this patchset:
 * mkfs: use libxfs to create symlinks
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 34 deletions(-)

