Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBC620E018
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368493; cv=none; b=NIFjhxDIH+JuNjQ31x6mC6D+eZe4i24yxNSLq3H4jyw+IV5aBg4BFmOmRdECtrYlSmM5q9AbJX30XnKGdkdTewsCF3lz6LBBiq+HN6X5skjnFUCKZHqv/BcljfXHo7kfjXM0CT0jIk7nBlUwz5vvtJCMcIZQQhwG+ITAF4gvNqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368493; c=relaxed/simple;
	bh=JLOPw3F/qfTHqVFlElNw4MKcedFuW2GJPmJXfw3mOfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A1Dfl6shoWnLtD4NAsm5YlPp4zHR8p9pbKueu/FtO4PMKFJG4ELqkkIp2HeBEKChCaKde1HVVrZp6Alfk3K2DECMwVoHmNRHG+yaZqen4kvudny/lKl8+jZLeuXXlkhZd6jUHEihyMjZq24eFvkfNeQISatqF8WXxOVoyk7xqKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ij4NFxo6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ij4NFxo6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739368490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lnsAJvP76BblrZHpn7tn12NKgMKeKuj4GJotDz4qgiQ=;
	b=Ij4NFxo6JoeV6wSJ+HOSWDEFw+E2DhOaRa0PLh6a3mMwZGQ/7uHOAVJlsr0l36hJ/AH0zF
	Tmilc7mstTLvBoGHRmBS+b7jenmzzMY/2h+mtY5XpfpbUP8I1CQffNgnkLCBsANVHkAd+u
	INRuxARPrwJua+x69AgkLwemPAg4X0g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-Ux77mPN7OVCmFyA5pPwLqg-1; Wed,
 12 Feb 2025 08:54:47 -0500
X-MC-Unique: Ux77mPN7OVCmFyA5pPwLqg-1
X-Mimecast-MFC-AGG-ID: Ux77mPN7OVCmFyA5pPwLqg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FD48195609F;
	Wed, 12 Feb 2025 13:54:46 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0689330001AB;
	Wed, 12 Feb 2025 13:54:44 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 00/10] iomap: incremental advance conversion -- phase 2
Date: Wed, 12 Feb 2025 08:57:02 -0500
Message-ID: <20250212135712.506987-1-bfoster@redhat.com>
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
other remaining ops (swap, etc.). Patches 4-8 convert over the various
DAX iomap operations. Finally, patches 9-10 remove the old iomap_iter()
advance logic and clean up the name and type of the iter.processed
field, respectively.

Note that I've taken an intentional shortcut here in the DAX read/write
I/O path (patch 4). In principle and for consistency, the advance in
this path should occur one layer down in dax_iomap_iter(). I have
followup patches to do that, but they were not yet working properly. I
think I'm close to having the kinks worked out on that. A bit more
testing is required and I intend to include that as a standalone patch
anyways, so I didn't want to hold up a v1 pass just for that. Otherwise
this survives my testing so far.

Thoughts, reviews, flames appreciated.

Brian

P.S., I'm also coming up on a short holiday so response to feedback may
be delayed.

[1] https://lore.kernel.org/linux-fsdevel/20250207143253.314068-1-bfoster@redhat.com/

Brian Foster (10):
  iomap: advance the iter directly on buffered read
  iomap: advance the iter on direct I/O
  iomap: convert misc simple ops to incremental advance
  dax: advance the iomap_iter in the read/write path
  dax: advance the iomap_iter on zero range
  dax: advance the iomap_iter on unshare range
  dax: advance the iomap_iter on dedupe range
  dax: advance the iomap_iter on pte and pmd faults
  iomap: remove unnecessary advance from iomap_iter()
  iomap: rename iomap_iter processed field to status

 fs/dax.c               | 94 +++++++++++++++++++++++++-----------------
 fs/iomap/buffered-io.c | 78 +++++++++++++++++------------------
 fs/iomap/direct-io.c   | 25 +++++++----
 fs/iomap/fiemap.c      | 22 +++++-----
 fs/iomap/iter.c        | 42 +++++++------------
 fs/iomap/seek.c        | 16 +++----
 fs/iomap/swapfile.c    |  9 ++--
 fs/iomap/trace.h       |  8 ++--
 include/linux/iomap.h  |  7 ++--
 9 files changed, 160 insertions(+), 141 deletions(-)

-- 
2.48.1

