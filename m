Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F2F23956E;
	Thu, 20 Nov 2025 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763654959; cv=none; b=PH6d7Ykkmlq7IWf19OvzYfiANwg2z7trpOzSUTh+zngU9TOGyzd2LU85W+O5Y8iYkQUBzOi1xf3pnYDRmRFVukRqqCJypNxB5Lqyhisz7SNdLxKf1HbWG45KGdVE5OoYoP2OIvYRlmiO7dGPbTj6PTDZCtORGQnsNZyhM+r4vF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763654959; c=relaxed/simple;
	bh=nOSGLZCHU8AbQp8zF7v4HOJhbkfs/TgMhdU+fdLQ1Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8Dh9TaVXBmjFyr2fxHD08MqY1r4/+VAQg7pJr9lFYvCnCEHlYatA3RCgENWu0pRczoMSCz4yjSGgPtediZcF6cNNrkxXBF83EX3TmARGJh/X52PCwZ2Uhknll9Z3Q6vstxOUD1qAn8oDsnjln7/TB8yFZfkSGLrz+JyaRKO11c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8ojGoyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8ojGoyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856B0C19423;
	Thu, 20 Nov 2025 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763654959;
	bh=nOSGLZCHU8AbQp8zF7v4HOJhbkfs/TgMhdU+fdLQ1Jc=;
	h=From:To:Cc:Subject:Date:From;
	b=L8ojGoyMIiORg3t0dInDBMtcoLAaCS5kmZ/3rgMmv16qcW9biz5Q207illeG/a1HL
	 oyrqB0FikyTdJfRQjGTF3aRCxYesvtvLj/OLQGkMrXT2/wPP0aMdc7FAh83idjdqob
	 PdbWjjB6MbhbY2JCmo2knrTyx1VWvbeCMEYFCxB+8ToSQ6tUVlk4HbqsS77egn9rvr
	 k4tyKRAis/MpVpNjOx5vdOEop8DEBSI5Rdmo6Oo6+oSPqv/iAPbM3ttUtByjqU4iTG
	 bpxacew6BCvWnbTrhucAGWhsX8pbjnKH525LH7YLUVMM8DRA3OyGcH+oTTQf7XQwCb
	 0D9OoKLnL5SAA==
From: cem@kernel.org
To: zlang@kernel.org
Cc: hch@lst.de,
	hans.holmberg@wdc.com,
	johannes.thumshirn@wdc.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: add regression test for small zone capacity
Date: Thu, 20 Nov 2025 17:08:28 +0100
Message-ID: <20251120160901.63810-1-cem@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This adds a regression test for the smaller sequential zone capacities
problem.

For that, we need to be able to create a zoned loop device with a custom
capacity, so the first patch extents _create_zloop to accept a custom
zone capacity.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos Maiolino (2):
  common/zoned: enable passing a custom capacity
  xfs: Add test for mkfs with smaller zone capacity

 common/zoned      |  8 ++++++--
 tests/xfs/333     | 37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/333.out |  2 ++
 3 files changed, 45 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/333
 create mode 100644 tests/xfs/333.out

-- 
2.51.1

