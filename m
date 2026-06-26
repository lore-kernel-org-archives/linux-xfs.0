Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B63749F2;
	Fri, 26 Jun 2026 11:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474366; cv=none; b=jGs69krnVOS6STWlDUvlYvUtdHtVFggzER9KReBUooFfnrg+wKXLzvC3IXxnWr7GzjDJF2yS5c+ixPb4lmmKwJZjSmbCnAxLCTB/eZjqBaYWXzRUS+o67okAnCYlCKAtMh3CNTlTEKHbA+lCcKvx+WTkog17K9JgT9ffeZqBmwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474366; c=relaxed/simple;
	bh=HjfdRn/qz4r7YX8X7ynmmFvMleCBbJKuZMR55klpxec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m1Apzi8WNorvzU24RPmIvmjHL/K/+1RbTjvQ9ahGa+VFiGxwg6tJ7zdVUbeFtrHnVL9RVNPg8XmOd77lNwYVsF0lYhC2WyaCUJIRdMTV9+ep+vB7jm2wEiHLtscZZnYSYGdq6hjqYI41OBExW2wyLuoyw/XoJ1xhBi+uqgn3x4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDtHhNS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDtHhNS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB39D1F000E9;
	Fri, 26 Jun 2026 11:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474365;
	bh=BTZg3uw/z60en9bHw3BRSWU2+QdKXobFHUYRcNnEduI=;
	h=From:To:Cc:Subject:Date;
	b=PDtHhNS1s2MhPLYKcJ8mnUMFs6elII3ioz+kTwpo26B3gcpJIXtgJ3B4l4P4i+ivg
	 /f80I8r9oHM25Ng9JC8J0BftIgGwDtfS2qLzGkNe3T+lswHdoQjyguWhqvpBQ6Tpmh
	 Kq7KeH8vpyJczCc222n29Y3MXJbvgIh3Vs3jDrdK9iKb2fifLhzljgareZh1dwZ0+T
	 9mGxmqIIAYMS0qJI2cAOPtNth7XzHA25j5XeZFlX+asbMEAqLOU14GMmtT+ypCHfyP
	 ju+ZFQgr4lEh2rSz5uqkR5+9J59d2hPvITXmU+go+RwYdNkYkqFfJwUJp4CazN7p2C
	 ENt2qhSrDjgDA==
From: cem@kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suze.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [RFC PATCH 0/4] Introduce capable_noaudit
Date: Fri, 26 Jun 2026 13:45:19 +0200
Message-ID: <20260626114533.102138-1-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

In some cases - filesystems quota specifically here - we'd like to check
for effective capabilities without issuing spurious audit messages and
without the need to specify a namespace for that.

This series introduce capable_noaudit() which has the same goal as
capable() but without firing audit messages.

Also, this updates both generic quota and xfs quota code to use that.

The last patch unexports has_capability_noaudit() which was originally
exported to be used in xfs but turns out it does not meet our needs.

Note this is based on top of a current series I have to remove
has_capability_noaudit() calls from xfs so the xfs patch won't
apply cleanly without that series.

If adding this helper is acceptable, I'll turn this into a non-rfc
series with the required changes to apply properly.

Comments? Flames?
Cheers

Carlos Maiolino (4):
  capabily: Add new capable_noaudit
  quota: Don't issue audit messages on quota enforcing
  xfs: replace ns_capable_noaudit()
  capability: unexport has_capability_noaudit

 fs/quota/dquot.c           |  2 +-
 fs/xfs/xfs_trans_dquot.c   |  2 +-
 include/linux/capability.h |  5 +++++
 kernel/capability.c        | 18 +++++++++++++++++-
 4 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.54.0

