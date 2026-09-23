Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DDF3AAF62
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180131; cv=none; b=Oda6TptyDbu7nSltwikKhXQx4G4NmeAqxTYvpS6zojlaqKvan+l33mPYpTVCljyFTsi3TJDGiUmTzpgA1voCI/TIxQ0ZvQb3KKV5leFY7qTBmif6lVxMlSHpcijqJHaKVxnGCVzt9KkwrS7W3X3rKlLV0eiCDLnxEu1o1v/8jjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180131; c=relaxed/simple;
	bh=FuiNiJzKiITIqTca8B9QWXMbAFf+peie29BRgoIB9NA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rNsGEkZfrkfW2p7gWOgT1fPHAlBAIz9yNeLGInlbpAm81Q/uEutosNy0c8sgRDTN8vF1k9APwOtO0lJE8bedmGEV977mZo9z6GAsE7JCWj+6Jfd7W4i4AWcI6yqrLvHgyWPeWbO09MaV+JV/ewUMks7ppVa6P/cbz9tEN92kA0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xf4WET9e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xf4WET9e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790180128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SDoZhkqDdVkmDKqKoSFukIKWkbR8BSuxx22B9+Sa5Hw=;
	b=Xf4WET9eu/xu87821pRB3/461Q5gRdX+pKw4b7jtWjHdrnXnwvkwlQV9AJIFGf5SbFW1eQ
	stIBJ6u5nDmBO26Pf5Mm+BShTnMX15dI8p2Qse2jQ8Tng+DcGhFYbnzRnxn5B5jvN7px8O
	z5qNuCUjguy8jIiigt389hklb76WyzA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-puZQ4P3kPPirX3D7i9UAsA-1; Wed,
 23 Sep 2026 12:15:26 -0400
X-MC-Unique: puZQ4P3kPPirX3D7i9UAsA-1
X-Mimecast-MFC-AGG-ID: puZQ4P3kPPirX3D7i9UAsA_1790180125
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE425195606E;
	Wed, 23 Sep 2026 16:15:25 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3BA973001070;
	Wed, 23 Sep 2026 16:15:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v4 0/4] xfs: fix a couple sparse chunk alloc problems
Date: Wed, 23 Sep 2026 12:15:20 -0400
Message-ID: <20260923161524.416059-1-bfoster@redhat.com>
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

Here's v4 of the series to fix the sparse chunk alloc shutdown. The
original report is available here[1].

No major changes in this one. The series has been rebased onto for-next
and I collected the review tags from the previous version.

As a brief overview, the idea here is to rework the freelist calculation
helper to calculate a min and a max. The min is the historical min AGFL
requirement for the current allocation. The max is an optional value for
minleft allocations that perform at least one more allocation in the
same transaction and thus are susceptible to seeing the min AGFL
requirement increase due to level increases in the first allocation. The
specific fix is to carry the delta between the max and min into minleft
for such allocations so they are either guaranteed for a given AG or
fail gracefully before dirtying the transaction.

Thoughts, reviews, flames appreciated.

Brian

v4:
- Rebased to for-next and collected review tags.
v3: https://lore.kernel.org/linux-xfs/20260902174025.284387-1-bfoster@redhat.com/
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

