Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A1814F9E7
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763763; cv=none; b=osbPqGVxfl9Sp3KV6AalZpThjZcraBvJ5lW746kdSKI2tRJ8urjQ5CLyO30YIYsru9qTFqiEK4isFYx9HylNYsOmzhMf9q6XN2A+Aqywws4OW41IQc1dokidFjqXMOSdAaGlDlCdGeUkEUNzRUGTXniDsg9Qp+eU0a1veijvT9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763763; c=relaxed/simple;
	bh=2Ku6GWXzeUooEpQ9fmvwzHly+vx9YMnpXoXU1yLWkjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sojXz1pH4jygWO7p79D/cqYlmJ0YdxCsmwo2lQsn7lHWzoeosFtie2WO7b6Ad4o5g/T9AsvjgFyrMeTPexxDC9pCAjeerT/oiqKSWNNZDuBRfMdi/R3AVCJWPfCON7tNmmPPGslJYlhnIO3/k485Lyp6GM7gYgFbNWRmrM+R1pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OMBbXJo4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMBbXJo4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738763759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UE0Mu82ZO57A+buR7Qcmk9UKgElNJhuOTuZastYMajk=;
	b=OMBbXJo41FssTGv6okDWjYnozFTWtCDaQKNYKIISwhRO7cqAKD9V+u2bR110/UoFRTIIg3
	dB0O8zkGykFN9hOt+5E6sykKmvi3nq93fhE6wd0gR0WCZbLmpMNYrGtdSYMcsmls5c/Ai1
	E+/9CRnYysIYMEDpnbGdHSOh5Q5W+WM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-i2SRAXqwNIuU760jdVXhfA-1; Wed,
 05 Feb 2025 08:55:56 -0500
X-MC-Unique: i2SRAXqwNIuU760jdVXhfA-1
X-Mimecast-MFC-AGG-ID: i2SRAXqwNIuU760jdVXhfA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79BE918004A7;
	Wed,  5 Feb 2025 13:55:55 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E88413000197;
	Wed,  5 Feb 2025 13:55:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v5 00/10] iomap: incremental per-operation iter advance
Date: Wed,  5 Feb 2025 08:58:11 -0500
Message-ID: <20250205135821.178256-1-bfoster@redhat.com>
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

Here's v5 of the incremental iter advance series. The only change here
is to fix a transient factoring bug in the split up of the
iter_advance() rework that occurred in v4.

Thoughts, reviews, flames appreciated.

Brian

v5:
- Fixed refactoring bug in v4 by pulling 'processed' local var into
  patch 4.
v4: https://lore.kernel.org/linux-fsdevel/20250204133044.80551-1-bfoster@redhat.com/
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

