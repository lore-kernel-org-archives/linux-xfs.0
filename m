Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730A212FAE
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675706; cv=none; b=eUiPrzl/980hHz+CyjKTxTKw/UXEJ8L3lHFngPfrVLyLRQnXvj1jNsMqD89o4LGxDP8aQ8G47vRNcYNRrwjG23s1fRHYmS65IR9TgpHkdv1DOTAFTOh3Tw1CD2LCQHBXGkYJm38h6fBx1zLdd/UsYUkvPZB3RzlSdruCmrIfj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675706; c=relaxed/simple;
	bh=BfpGLOdJ5xIbRBa6d1DuIHV90Znz7lLhvKuT6x5a8MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C+QCAgEeTb7r6tNiClisqAh4uUkCvcvf80Rz0aSWm7cSekmGGYhcrqm5Fi+w1y04wnCcMygzsUuCvZyP2GSZXp/+5cEwJqhfItOnYuTZ2UYSQGtfJ9je+SjmjhRsKnQk7vxQ64l1QodJ2FLQEDnGNftUpxZ0r2wiiRlmN3Jp/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AIPxEVwB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIPxEVwB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ospvvgr5dB4V3lRGMle4aysRqaFUlA+9kzm63Y2vmd8=;
	b=AIPxEVwBCU33geu+UiDQiyfyuqTke/IrqbH/WUbfV52bOgntJniuat/sX7diGdtSZkbiHX
	qDdJ+oypJCsd2Glx4ViE5ppiwP/sTZakc0WIVj19rj0qRS8AtCgD9RaxdV16TOptEJfHEy
	jJqXXr8aH0gGkogOnh5JCnKgcKWpL1A=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-108-oaJeM_7LOp6Gt5-vbbPXXQ-1; Tue,
 04 Feb 2025 08:28:19 -0500
X-MC-Unique: oaJeM_7LOp6Gt5-vbbPXXQ-1
X-Mimecast-MFC-AGG-ID: oaJeM_7LOp6Gt5-vbbPXXQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C670819560B4;
	Tue,  4 Feb 2025 13:28:18 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C7A5F19560AD;
	Tue,  4 Feb 2025 13:28:17 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 00/10] iomap: incremental per-operation iter advance
Date: Tue,  4 Feb 2025 08:30:34 -0500
Message-ID: <20250204133044.80551-1-bfoster@redhat.com>
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

Here's v4 of the incremental advance series. No major changes here.. a
couple patches have been reordered in the series and patch 3 in v3 has
been split up into several smaller patches.

Thoughts, reviews, flames appreciated.

Brian

v4:
- Reordered patches 1 and 2 to keep iter advance cleanups together.
- Split patch 3 from v3 into patches 3-6.
v3: https://lore.kernel.org/linux-fsdevel/20250130170949.916098-1-bfoster@redhat.com/
- Code style and comment fixups.
- Variable type fixups and rework of iomap_iter_advance() to return
  error/length separately.
- Advance the iter on unshare and zero range skip cases instead of
  returning length.
v2: https://lore.kernel.org/linux-fsdevel/20250122133434.535192-1-bfoster@redhat.com/
- More refactoring of iomap_iter[_advance]() logic. Lifted out iter
  continuation and stale logic and improved comments.
- Renamed some poorly named helpers and variables.
- Return remaining length for current iter from _iter_advance() and use
  appropriately.
v1: https://lore.kernel.org/linux-fsdevel/20241213143610.1002526-1-bfoster@redhat.com/
- Reworked and fixed a bunch of functional issues.
RFC: https://lore.kernel.org/linux-fsdevel/20241125140623.20633-1-bfoster@redhat.com/

Brian Foster (10):
  iomap: factor out iomap length helper
  iomap: split out iomap check and reset logic from iter advance
  iomap: refactor iomap_iter() length check and tracepoint
  iomap: lift error code check out of iomap_iter_advance()
  iomap: lift iter termination logic from iomap_iter_advance()
  iomap: export iomap_iter_advance() and return remaining length
  iomap: support incremental iomap_iter advances
  iomap: advance the iter directly on buffered writes
  iomap: advance the iter directly on unshare range
  iomap: advance the iter directly on zero range

 fs/iomap/buffered-io.c |  67 +++++++++++++--------------
 fs/iomap/iter.c        | 102 ++++++++++++++++++++++++++---------------
 include/linux/iomap.h  |  27 +++++++++--
 3 files changed, 119 insertions(+), 77 deletions(-)

-- 
2.48.1

