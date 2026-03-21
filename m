Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BC136EA88;
	Sat, 21 Mar 2026 11:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094150; cv=none; b=pGLMFinQLtX/D0bBQPp2aYT9D0jtUUQrOrHuYV3pubSbhIOXGQpfnYWUSZvoWGRtyoMIdm0cLtyCJUqHD74Xk7wS9q5IPGHmGfY4TcrP5X6PxefnROdaFVp3Nt0Slni7jPkqD5To3B6Zq1/AjXJ+cBdJ/TJmGp0T2VzZ8EHDXYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094150; c=relaxed/simple;
	bh=Nb7Jj7Kv075pqwu9v9tSFZbPIirnp1cn6S/R2NGRoWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XhjY6KNyTt2TdxAN72UZryNuW5/yVrjyMf9wYqlBPRor4MS0uEG4KUa4Y0P9YHjyQM54UrTUoVzmGvATRJejYnP8pUPLdimcD+Xc0wleu1m0h4Bzj84T6qsg5c1kfjAzszNPqNdGWSL9vN/gsvawg5BuPXAOqmeu+QW4YYn1eJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5Hrruaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5Hrruaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBDC19421;
	Sat, 21 Mar 2026 11:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094150;
	bh=Nb7Jj7Kv075pqwu9v9tSFZbPIirnp1cn6S/R2NGRoWw=;
	h=From:To:Cc:Subject:Date:From;
	b=B5Hrruaf2xvPLVgvbKDoZX8qVWVEowDhveZxGrPuri/fDpplRFcTR2dAKy+Ika63H
	 0PO55qhEUjT4qNTePIl3C7xx9ETTfeDKcYq++hDsxtQv6pcptzJEqm9fMPAo1DN4Cs
	 l+zhyzxxO4kgVWsPuQd2+nOlJ6RkC4wRwEdFst9F9gJBFrtvhnhanjcTsuTjmxZZmV
	 XOKL/Q5dgvfSLXPpo2oaYQqbxreT178yUzL1jSwV7KhV7IoNsrmgN79Oi8FNQAOHJJ
	 n/7wN/tweR7DAQ7cYA8RZx2VtIwJc/e0FUYbx8j4DfFq2MNNk9mRfNiJY6S5DIOmvs
	 Uu6Az5ERpQl6Q==
From: Anand Jain <asj@kernel.org>
To: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: [PATCH v2 0/3] fix s_uuid and f_fsid consistency for cloned filesystems
Date: Sat, 21 Mar 2026 19:55:16 +0800
Message-ID: <cover.1774092915.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
  Derive statfs::f_fsid only when using new 'nouuid'; naming matches with xfs.
 
v1:
 btrfs:
  https://lore.kernel.org/linux-btrfs/cover.1772095546.git.asj@kernel.org/
 ext4:
  https://lore.kernel.org/linux-ext4/e269a49eed2de23eb9f9bd7f506f0fe47696a023.1772095546.git.asj@kernel.org/

Anand Jain (3):
  btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
  btrfs: derive f_fsid from on-disk fsuuid and dev_t
  ext4: derive f_fsid from block device to avoid collisions

 fs/btrfs/disk-io.c |  3 ++-
 fs/btrfs/fs.h      |  1 +
 fs/btrfs/super.c   | 35 +++++++++++++++++++++++++++++++----
 fs/ext4/ext4.h     |  1 +
 fs/ext4/super.c    | 12 ++++++++++--
 5 files changed, 45 insertions(+), 7 deletions(-)

-- 
2.43.0

