Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476FE3DAAB9
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201684; cv=none; b=dZ/THYDAAnB/KSmnAJ+Z9XC0ios8ZnWlxFvbl5MiQqN/FVKvhrCeh/taPQ5vaKu+GnDQfw7xSdRYqLKwcwmMtYhsJP3paXuhK7kAzgqBsM0uDrSshe+KJqj2Ctj2OoLyJbb+VdwrQR/GLKpX947JD/axZ7KTOD8ArwU+ITmHQLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201684; c=relaxed/simple;
	bh=XvSn54vFXe23J8v1BlwDYbMVMXB1WCOacM/D93b4lzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ehVi3WflENUym+TAz/Dvw7nhyyNpWIIOgAp1RLQ2czP9sKzvTUoQskkK+DUoievxbmeNQMgLPN8VzY6kdALpGj9bcoAvNthEYXtHVbVfy3cZpa5/8r5LkdYw4+Z1Xsz42lBtJ3mCCWORfwfOq23GASi+BmotXF+kMMvrKni0DWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hYZETNAM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hYZETNAM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791201682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eBdMsqNur2akkLPlKimidF0hkUFYpXEHfcVykCMNLmY=;
	b=hYZETNAMJo6LtzDnQDJsBK8vzJjiejCSzl63mHPlwUNETx/cUFcPNrQ3P1ArGZ7DSeaUSf
	7raKL02JT6NakTjfSv6LNuKedu2wLvEvLYbpz286uC9KUhPLkZf/RBABD8ze2XDX9TCoUb
	+/3WUc/JuqXxwGANO/32EYhoCPPr7dE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-MCAmik8zM7CLLs0gsPMueQ-1; Mon,
 05 Oct 2026 08:01:20 -0400
X-MC-Unique: MCAmik8zM7CLLs0gsPMueQ-1
X-Mimecast-MFC-AGG-ID: MCAmik8zM7CLLs0gsPMueQ_1791201679
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1BA31800EFA;
	Mon,  5 Oct 2026 12:01:19 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45B971956047;
	Mon,  5 Oct 2026 12:01:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v5 0/4] xfs: fix a couple sparse chunk alloc problems
Date: Mon,  5 Oct 2026 08:01:14 -0400
Message-ID: <20261005120118.229086-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi all,

Here's v5 of the series to fix the sparse chunk alloc shutdown. The
original report is available here[1].

This is mostly a convenience repost of v4 with a variable rename in
patch 4.

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

v5:
- Renamed params to xfs_alloc_longest_free_extent().
v4: https://lore.kernel.org/linux-xfs/20260923161524.416059-1-bfoster@redhat.com/
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

