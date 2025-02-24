Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738E42571CB
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408327; cv=none; b=hK76pFK/W1nvC/JX04mtOUNwbAQogOi0MdRsgaAk448zUTP3IChMummopFJ3+7+aU1Q+CRzfApPKfcyuKk6wc5wMxUeiKmADJiNSJjOfryLD6jV56rYBC7U4xP+pv3hPUBBoxt8YAsTcLL08lWr5QEIBv7f9bi4t4O6hYrBQfgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408327; c=relaxed/simple;
	bh=T91SNXjwBw05XWX6O+qBJInWN7oYayzS2/t3eW0TZTI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EjmuQMO1VW1vU2ZVUSo332VMU9oBxtQvc3BLjsn8dY5dcfOWQudnz6gWLnvKNj7a2TqTfTlFVNwk3F+8WqiG48G+zRxiIr/vM0jwj8wsZLHEB3XUKxGG+u/FFIzpuHHHtTrpyJYWBzQUbIsaBrJwnXiQRg2qn1DLYHUNCct8Rrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y92ikPe5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y92ikPe5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740408324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r588k3Qo1UlR2EUrdzYPkDQTGrazx1bBsTWduKS4XAM=;
	b=Y92ikPe5iS7QV9CxdmMki9HlGp6+0wk40sS6lgmfiBmDxlXyJyyAis5DD5pLwdx0TFqevt
	jqPvUWE3J5HOumP5zDrskZMR8ZJLnhdT/wH56G2zg+urvjyyJ7cySYlPlpdC9vtJENuar8
	gS71vfEfRJmCc6SJnkRuVAEZBFD7eUo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-672-fjpf-U2CMf66rSuvQCqwjw-1; Mon,
 24 Feb 2025 09:45:20 -0500
X-MC-Unique: fjpf-U2CMf66rSuvQCqwjw-1
X-Mimecast-MFC-AGG-ID: fjpf-U2CMf66rSuvQCqwjw_1740408319
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69DCD18D95F8;
	Mon, 24 Feb 2025 14:45:19 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7FF8B19560AA;
	Mon, 24 Feb 2025 14:45:18 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 00/12] iomap: incremental advance conversion -- phase 2
Date: Mon, 24 Feb 2025 09:47:45 -0500
Message-ID: <20250224144757.237706-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi all,

Here's phase 2 of the incremental iter advance conversions. This updates
all remaining iomap operations to advance the iter within the operation
and thus removes the need to advance from the core iomap iterator. Once
all operations are switched over, the core advance code is removed and
the processed field is renamed to reflect that it is now a pure status
code.

For context, this was first introduced in a previous series [1] that
focused mainly on the core mechanism and iomap buffered write. This is
because original impetus was to facilitate a folio batch mechanism where
a filesystem can optionally provide a batch of folios to process for a
given mapping (i.e. zero range of an unwritten mapping with dirty folios
in pagecache). That is still WIP, but the broader point is that this was
originally intended as an optional mode until consensus that fell out of
discussion was that it would be preferable to convert over everything.
This presumably facilitates some other future work and simplifies
semantics in the core iteration code.

Patches 1-3 convert over iomap buffered read, direct I/O and various
other remaining ops (swap, etc.). Patches 4-9 convert over the various
DAX iomap operations. Finally, patches 10-12 introduce some cleanups now
that all iomap operations have updated iteration semantics.

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20250207143253.314068-1-bfoster@redhat.com/

v3:
- Fixed whitespace in iomap_iter_advance_full().
- Rebased onto vfs-6.15.iomap.
v2: https://lore.kernel.org/linux-fsdevel/20250219175050.83986-1-bfoster@redhat.com/
- Push dax_iomap_iter() advance changes down into type specific helpers
  (new patch).
- Added patch for iomap_iter_advance_full() helper.
- Various minor cleanups.
v1: https://lore.kernel.org/linux-fsdevel/20250212135712.506987-1-bfoster@redhat.com/

Brian Foster (12):
  iomap: advance the iter directly on buffered read
  iomap: advance the iter on direct I/O
  iomap: convert misc simple ops to incremental advance
  dax: advance the iomap_iter in the read/write path
  dax: push advance down into dax_iomap_iter() for read and write
  dax: advance the iomap_iter on zero range
  dax: advance the iomap_iter on unshare range
  dax: advance the iomap_iter on dedupe range
  dax: advance the iomap_iter on pte and pmd faults
  iomap: remove unnecessary advance from iomap_iter()
  iomap: rename iomap_iter processed field to status
  iomap: introduce a full map advance helper

 fs/dax.c               | 111 ++++++++++++++++++++++-------------------
 fs/iomap/buffered-io.c |  80 ++++++++++++++---------------
 fs/iomap/direct-io.c   |  24 ++++-----
 fs/iomap/fiemap.c      |  21 ++++----
 fs/iomap/iter.c        |  43 +++++++---------
 fs/iomap/seek.c        |  16 +++---
 fs/iomap/swapfile.c    |   7 +--
 fs/iomap/trace.h       |   8 +--
 include/linux/iomap.h  |  17 +++++--
 9 files changed, 164 insertions(+), 163 deletions(-)

-- 
2.48.1

