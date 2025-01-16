Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EFB19343E
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063653; cv=none; b=gdMBqbWzepXPOQm7iKHLkhOQJfDmRYN3B1BSqNXW2N10eMMa4qOybyRyb75AgoySr7/SOMdCnmrjO69PNi0cCo9j16NVyNkyuQax0DUntziPqty4Ue0YZbzN0N7dAZReKwuOVvm6u13I0wsrVUcat0tCRA96w13aKNsHVHryBvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063653; c=relaxed/simple;
	bh=J3E0doO5rIY6mf0Xnnta4IHrgGr/NJrHiObK125jkFI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=tU+jvwjvYMzgaU9kuX8KSIB2Ves05NF1KXl5Tx8NnoyTXilaH5YBzQeHA2SsKHiPJp3Y5OPVnMob1W0uQDhm82eGcLy3H1SX7BP/Bh3zU/jAIBbtYjJobXfhtrRT+oK1lXvTKk5GCuyKI1wQo6FvDfX2h1pZoafUw3ofVHK2DnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qYrgX9LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYrgX9LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D277C4CED6;
	Thu, 16 Jan 2025 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063652;
	bh=J3E0doO5rIY6mf0Xnnta4IHrgGr/NJrHiObK125jkFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qYrgX9LD+BeGR5ninaXoYfWdxbudrmVQ7L6rkZdddIrNJW8mGwN8UXoV0sgeafXYP
	 xuK94Vob4PU/rPt21WjK5B6NEreW5zMSk04bcu8WrUoIBJWIkpQrRNKyUIJfvQnVdM
	 Hg9GQ+k7ZaTcqvgK4MC0/sH/X/T7lTKE3yNWPUnqKiMcUU3Z096O4S4aCI7QYKqbD/
	 M7BS0W5oIDZ2lFlTANT9R9tigKLKD3ytnC6s0Z4AZM5zmDOEjeISnn1rWeyxNZQNsk
	 gqoswk4H85MDGXit3CUcYwGgxP+kc3OpKdQPY0AZHM5qvQpgw0rJm5aYIWibWnzIIM
	 8qXoga5+RJbMw==
Date: Thu, 16 Jan 2025 13:40:52 -0800
Subject: [GIT PULL 1/2] xfsprogs: new libxfs code from kernel 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: bfoster@redhat.com, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706333861.1823974.8905921624026520740.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250116213334.GB1611770@frogsfrogsfrogs>
References: <20250116213334.GB1611770@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 19bca351dcdfef4a63ede08bcc9f7bdeec10c453:

xfs_io: add extsize command support (2024-12-25 22:14:45 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-sync-6.13_2025-01-16

for you to fetch changes up to 773c4c6f33cfd0a909fb742f149bd6f59cfa62b6:

xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT (2025-01-16 13:27:27 -0800)

----------------------------------------------------------------
xfsprogs: new libxfs code from kernel 6.13 [1/2]

Port kernel libxfs code to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT

libxfs/xfs_rtgroup.h | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

