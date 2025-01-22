Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB561805B
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 13:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552746; cv=none; b=ggE+eU88rqX9pzDeOYnVY8Q4ptjTXgESVEbz2hNW2hZfFEnd2em+s88tnknbkO7uVsyiHT714o6Zus80EuZL1KEuw21PrINbSMi/0HO0mn4yksFhDDBQjVlL4Z1t1dfDmlCzu8ByUF8whXKW95P//7ZIRkLr9PuBB/YAekBLKs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552746; c=relaxed/simple;
	bh=Gz2bTdwEU9tMkA7WgKDSohvXRV1wZIg0yIy7UYdq8m8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DLrM87PSGF1Fp2O1GOEF1d3UfBolUOFho6ScQylvO0f54yDCRFjYBjQYQxb3JJuQNbFCnL7v2dK98vyswk/M7YWgPhJkHMKX+QjoQClQd37sKdzBNBuL3g8ct5LywY8ixFa6q8LXwbonGTAnsylQCTN+mdDJaaWGaRvAYm34imM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XrAIrbku; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XrAIrbku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737552743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UKPZ5ozu5DoxdJOGus267plaWFhW6apkInYjlQPXXPY=;
	b=XrAIrbkuU/shNCfo8uedHHiLzxZCBeRMZDbFISdGhHkDh+NZuqfRvKFMXsABIX3iW5vZwN
	cWf3qL+IsvVXY/W4fa879ZrPu8AahE9OIN/ZYmexmnHGqAllGaDQ42qJo6+7zh3eZy2lNN
	X97Oh6YWgTJ9UWuaFUxhky/G1NP4geg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-ulDuNFvfN4ipQ2v8w9A0xg-1; Wed,
 22 Jan 2025 08:32:22 -0500
X-MC-Unique: ulDuNFvfN4ipQ2v8w9A0xg-1
X-Mimecast-MFC-AGG-ID: ulDuNFvfN4ipQ2v8w9A0xg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3605919560BB;
	Wed, 22 Jan 2025 13:32:21 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.118])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FC3C19560A7;
	Wed, 22 Jan 2025 13:32:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/7] iomap: incremental per-operation iter advance
Date: Wed, 22 Jan 2025 08:34:27 -0500
Message-ID: <20250122133434.535192-1-bfoster@redhat.com>
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

Here's v2 of the iomap incremental iter advance series. This is mostly
the same idea as v1 with some of the cleanups noted below. The most
significant change is probably a bit more rework of the logic between
iomap_iter_advance() and iomap_iter() to make the former a bit more
generic. _advance() now returns the remaining length for the current
mapping for easier use in some of the iter handlers.

The other item of note for v1 was some discussion with Christoph over
changing over more of the operations to advance directly and avoid the
need to handle both types of advances in the iomap_iter() code. I don't
plan to address that in this series, but I've read through some of the
related code and think that perhaps this isn't as invasive as I
originally anticipated. Reason being that even some of the more complex
operations (i.e. direct I/O, buffered read) don't necessarily require
plumbing advances all the way down through the sub-helpers and whatnot
to eliminate the dependency from iomap_iter(). IOW, I think toplevel
direct I/O could just change to something like so:

	iter.processed = iomap_dio_iter(...);
	if (iter.processed > 0) {
		iomap_iter_advance(..., processed);
		iter.processed = 0;	/* success */
	}

... to translate the op-specific code into the updated iteration
semantics. Given that, I'll probably make a quick stab at that once this
series is settled and we'll see how that pans out.

Thoughts, reviews, flames appreciated.

Brian

v2:
- More refactoring of iomap_iter[_advance]() logic. Lifted out iter
  continuation and stale logic and improved comments.
- Renamed some poorly named helpers and variables.
- Return remaining length for current iter from _iter_advance() and use
  appropriately.
v1: https://lore.kernel.org/linux-fsdevel/20241213143610.1002526-1-bfoster@redhat.com/
- Reworked and fixed a bunch of functional issues.
RFC: https://lore.kernel.org/linux-fsdevel/20241125140623.20633-1-bfoster@redhat.com/

Brian Foster (7):
  iomap: split out iomap check and reset logic from iter advance
  iomap: factor out iomap length helper
  iomap: refactor iter and advance continuation logic
  iomap: support incremental iomap_iter advances
  iomap: advance the iter directly on buffered writes
  iomap: advance the iter directly on unshare range
  iomap: advance the iter directly on zero range

 fs/iomap/buffered-io.c | 50 ++++++++-------------
 fs/iomap/iter.c        | 99 ++++++++++++++++++++++++++----------------
 include/linux/iomap.h  | 20 ++++++---
 3 files changed, 94 insertions(+), 75 deletions(-)

-- 
2.47.1

