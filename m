Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C47E3655CA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370836; cv=none; b=bMVJ5Rk7a+mDA2j+4VOlSWNEesNF+BQr6djTTr8b8QVw+jq0SI7tBQAka1hnqmoMLqPSzSVoLSWiSaZkba2DyycEsg08Gu7csdwe+dFW3um2uDvyN0QdNguNWxcIVLHWqofX5Y1iUiINyg8N6JM/qvPofmWFiKkFxzje7H/iKLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370836; c=relaxed/simple;
	bh=MEtHkeEYXpQsVWDfvzGS1PEoAI9qP9ynXKvjoJAIsXE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZoJU0xnq/c+p0ryHyu/cHtHtZozc3PUfK3BPrWuymi5OpWOXHclQGZoAExu3ZDGxz/zrmlYDALEFYw8Y8HaRaQ903r6tbtbCazk41R83vPpaa0em79Clt51/KxEdXULlbCivUEe8r126fDqZgYy5FSkDZhMrXASgl1gVhmrZApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VU+0OG4Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VU+0OG4Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lc61K+bdIQMZZfYwvz9qerIdG45c2dXdEIhcksRk9AQ=;
	b=VU+0OG4Zrl3ZVnWM64JqPsglcE60FRxzZbOlnSM+KCpZeN0uG8lKQHsmPYdwlbIjkEg+V5
	k1mjBWu9MPSZtaQyY+OG1jgUP9vod5TjA4BpPqFigHShcjpHsqmvx40RWHSnliJ8zDUjFh
	1WWEr5mgxgHqp1Hw0Dz6he++3NPBwBU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-vcbveC0TNMm8XQ43YqvmqA-1; Wed,
 02 Sep 2026 13:40:32 -0400
X-MC-Unique: vcbveC0TNMm8XQ43YqvmqA-1
X-Mimecast-MFC-AGG-ID: vcbveC0TNMm8XQ43YqvmqA_1788370831
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FFE0195396F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:31 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A89DE1800765
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/4] xfs: fix a couple sparse chunk alloc problems
Date: Wed,  2 Sep 2026 13:40:21 -0400
Message-ID: <20260902174025.284387-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi all,

Here's v3 of the series to fix the sparse chunk alloc shutdown. The
original report is available here[1].

This is mostly the same fundamental idea as v2, but the implementation
has been slightly reworked. Instead of creating and using a _minleft()
freelist calculation variant, we rework the min freelist helper to
calculate a min and a max for multi-alloc cases. The max is used
appropriately based on allocations that set args->minleft.

Patches 1 and 2 are unchanged from v2. Patch 3 is new and refactors the
semantics of xfs_alloc_min_freelist() as described above. Patch 4 is the
same general fix as v2, but rather than create its own helper the max
value is passed along with the min and they are used appropriately for
length checks and available space calculations.

I've also since realized that XFS_DEBUG seems to be what defeats the
custom reproducer, for whatever reason, so I can confirm this still
survives that test on !DEBUG. Otherwise the series survives fstests
without regression.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Added patch 3 to refactor xfs_alloc_min_freelist() and calculate
  min/max.
- Updated patch 4 to use the max value for space available and longest
  extent checks.
v2: https://lore.kernel.org/linux-xfs/20260814132239.271492-1-bfoster@redhat.com/
- Reworked fix logic into allocator instead of sparse inode alloc
  specific.
- Dropped Fixes: tag since this is no longer directly correlated to
  sparse inodes.
v1: https://lore.kernel.org/linux-xfs/20260731163337.152522-1-bfoster@redhat.com/

[1] https://lore.kernel.org/linux-xfs/20260717130429.1838767-1-matt@readmodwrite.com/

Brian Foster (4):
  xfs: set minleft correctly for sparse chunk errortag allocation
  xfs: support additional levels in the agfl minimum calculation
  xfs: calculate AGFL max to support multiple-alloc transactions
  xfs: incorporate increased AGFL min requirement for minleft allocs

 fs/xfs/libxfs/xfs_alloc.c  | 106 +++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_alloc.h  |   7 +--
 fs/xfs/libxfs/xfs_bmap.c   |   7 ++-
 fs/xfs/libxfs/xfs_ialloc.c |  14 ++---
 4 files changed, 93 insertions(+), 41 deletions(-)

-- 
2.55.0

