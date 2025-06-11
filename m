Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA451A9B32
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665993; cv=none; b=UQ3iZXKd0YrRouelteaSlNCbg2Uu5f0l3Xhu/TODIDpDLuZ7wjNq6XuGa9eMxJCLpUYaGUpbnpxFT1x2ANy0/pYcXVtuhAGlgwXmFK8uOabVAugq1+YJApwNtG0KsVoZD6BNDYfjqxHKT6UWOZE7XyyW2Z4l93uM3Qyb7t2ERgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665993; c=relaxed/simple;
	bh=UpUyBsZJAmnG7cKBFBFuI9PBW9VLXNfr2vzzwu8eLPA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EN6ggLbWLQqnMolWYCFE/zxsvk63u5Ypmb0A0V4JRLMSHo4qggtuNzIdBUSmMKWUBXLAhIoXmvhUUqc0988GOIbmkYbMOFenvi/VIfwhxfhW17gQlAbhzjtaP3Y2ICMiryY/B4N1258i/tLhfKyAqxCkUBceC57cGDQuM5SlKqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jx2ltorT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jx2ltorT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749665990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UsDGclV18pT7F7kVwS4vnqf5w1kP/TnlX5E/Xw5InIo=;
	b=Jx2ltorTdv+32MuIB4u6wKYF3kr8rCgrRb2wd7iwxbd1hR6Dd0rFKtObmiMXrzpwbs+9JH
	VwEbPT3scK6/oTwfs2/l3+wePKghkjh0VcPYd0cEZnRSuJSlXST5F1DOIoN3eklDQyWkgE
	xmSidGql+OGHv0YW1NWf9Muvm2l4UU8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-yWiXsjgmNv213A1hoqPAuw-1; Wed,
 11 Jun 2025 14:19:48 -0400
X-MC-Unique: yWiXsjgmNv213A1hoqPAuw-1
X-Mimecast-MFC-AGG-ID: yWiXsjgmNv213A1hoqPAuw_1749665988
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8090B19560A2
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E57230002C3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:46 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: support on by default errortags
Date: Wed, 11 Jun 2025 14:23:20 -0400
Message-ID: <20250611182323.183512-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi all,

This is a quick side quest based on the discussion on the iomap folio
batch series here[1]. I could see this going a number of different ways
and/or being enhanced in the future. For example, we could have per-tag
warning state instead of the global op state, dynamic default
configuration, put this behind a kconfig option, etc. My goal here is
really just to implement enough to keep things simple and pretty close
to existing XFS_DEBUG behavior.

Ultimately if people are Ok with something like this, I'll change the
force zero tag in the iomap series to on by default. If not, I'll just
leave it as is and go with a custom test. Otherwise, this survives a
first run through fstests without any explosions or spurious failures.

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20250605173357.579720-8-bfoster@redhat.com/

Brian Foster (3):
  xfs: support on by default errortags
  xfs: convert extent alloc debug fallback to errortag
  xfs: convert sparse inode alloc debug fallback to errortag

 fs/xfs/libxfs/xfs_alloc.c    |  5 +---
 fs/xfs/libxfs/xfs_errortag.h |  6 ++++-
 fs/xfs/libxfs/xfs_ialloc.c   | 14 ++++-------
 fs/xfs/xfs_error.c           | 48 ++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h           |  3 +++
 5 files changed, 60 insertions(+), 16 deletions(-)

-- 
2.49.0

