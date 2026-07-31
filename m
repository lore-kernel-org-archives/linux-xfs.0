Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB13A468C2A
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785515625; cv=none; b=Qg9hRFn8/tTfS/ZpA4TxAZv1ohXxQUZrDD2NC5q0+QeyOtXdNKH2urSItiPzWU+GES/DzJtmAJMzCChH34Vwli2by4hPRW37ezzIkxDQxh7Mqb70dX9nRR60kCyaRmxP3iVSOG+qlH5EnU6fbEpGUjfMz8uxnV6tlE97r4WK12g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785515625; c=relaxed/simple;
	bh=KpUhhiOU0+FHx3F0Xf/uU/zXI8qfQwKif45IG83Mk6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WDUpj+8z/lkO+MOn2M6GRQhooEGAn2FgovOCu0lF5TExU4jDckb1niH7Cv2Z4JsXRBLBgJCQ1UpLoRPvaB9ZvNmAdAzUddN7Qq4tQTHMCSyMKxzTOV56n4M7lAUUnxSLXVIuY4dBR0j5PsnLEZabQJC+m3TRcDNldybYgqr3u/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgfNJQuy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgfNJQuy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785515623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=icBEEUxLowdMKy1lCtc8E/nu9dX8AlII+63L/ZiGZys=;
	b=TgfNJQuyHQt4zV9mw5UCsKrteOeFcXwGwcJgElD8YyqLMGpha/bXhT4/FgrEBkwUXkQy5g
	pnDFu5nsaYAcq9lQrzo8cBqMdNAJIRkmsFJzdvmKaRSxBKU4DYfUdoHFD1Yx8/lP4kHwAQ
	Hn3NZcTBSPCpm5HXTgMLceYIl7pPlZE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-YrxpwKN3Pz-BjXW59Jjkcw-1; Fri,
 31 Jul 2026 12:33:39 -0400
X-MC-Unique: YrxpwKN3Pz-BjXW59Jjkcw-1
X-Mimecast-MFC-AGG-ID: YrxpwKN3Pz-BjXW59Jjkcw_1785515618
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 955B51956094;
	Fri, 31 Jul 2026 16:33:38 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.193])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07EB730002E9;
	Fri, 31 Jul 2026 16:33:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: [PATCH 0/2] xfs: fix a couple sparse chunk alloc problems
Date: Fri, 31 Jul 2026 12:33:35 -0400
Message-ID: <20260731163337.152522-1-bfoster@redhat.com>
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

This series is a couple small sparse chunk alloc related fixes. Patch 1
is LLM detected and generated (I rewrote the commit log) during the
process of investigating the problem fixed by the second. Patch 2 fixes
the problem reported by Matt here [1].

Note that patch 2 is semi-RFC. Personally I'm Ok with using this as the
fix, but I don't love it and recognize that it's more of a band-aid. The
fundamental problem seems more that the space availability requirements
change within a transaction that targets a single AG, but I haven't yet
thought of an elegant enough way to fix that for something that is kind
of a corner case.

The LLM came up with a fix that basically bumps up minleft within the
allocator path by the extra space that would be required by the inobt
allocation, but I didn't really like that at all and tossed it in favor
of this.

I had a couple other things I thought about as potential alternatives.
One is to perhaps use or repurpose something like the
XFS_ALLOC_FLAG_FREEING flag for this pattern where we have a minleft
gated allocation followed by a targeted alloc to the same AG. This would
presumably allow the allocation to succeed.

Another is to perhaps enhance the xfs_alloc_min_freelist() logic to just
start to use the allocbt maxlevels value for requirements calculation as
an AG starts to approach -ENOSPC. That is more of a heuristic and
similar sort of workaround for the problem, but more directly encodes
that reliability is priority over squeezing every last block from an AG.
I also think it's a little risky as it may involve a new mode of
allocation across the board (not just sparse chunk allocs).

I also suspect this wouldn't be a problem if the inobt were covered as
perag metadata res the way the finobt is, but I haven't thought that
through fully.

So all in all I'm curious what folks think about any of this or have any
other potential ideas. My main concern is that I don't want to introduce
something too complex for the single uncommon use case of sparse inodes.
I.e., this problem seems a lot like a corner case of a corner case to
me. Thoughts?

Brian

[1] https://lore.kernel.org/linux-xfs/20260717130429.1838767-1-matt@readmodwrite.com/

Brian Foster (2):
  xfs: set minleft correctly for sparse chunk errortag allocation
  xfs: consistent low ag space behavior for sparse inode chunk allocs

 fs/xfs/libxfs/xfs_ialloc.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.55.0

