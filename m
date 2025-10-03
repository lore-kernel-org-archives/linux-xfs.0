Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C9B1E5206
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498961; cv=none; b=tQWSOgg/NKRDd+rqANLje4/YaJ1T9ULv1uJ9nqSMhrsovPAMnlAn6qlIPsJrOxKEB2cehjkmJw8Tgr6ia2BnqLQo2V9A9lQilFq8jkjcwuPFWuP5ERgQVtMf1c0rlJ+FmavyYtlXTLjQquPxdPbRGs3zqmvLl0dMDrt2FFRqpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498961; c=relaxed/simple;
	bh=9K/pcAJIAmNaWqCWy4cG3ZYxLZ/lu/7uNK022qUCius=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N3bNDc8r/0l9iLAZSaoo3MfgmGU2oppjWN7NzAj/xsQFLNNGBCgJhI9NyVhTuYX7BZGzn5kanog7XRqSmMlFhdbNwYWz0ZgxrWUkMQxYb5l0WavpLdCX8NlIsdju9VvhU1drdmovkrNuXGuDLe8X0vQ+W7Ue+NAxc2NM3U7SuPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SM8ztUie; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SM8ztUie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xfXtIfWkcf4xqLvnSN5itUWF/K16TMTPz0JBNVG+WgY=;
	b=SM8ztUieaFjRupq9VrY3Mr+q0evnkNbYFXjL5MVf00zn1r+29krI8X4EjYDNik7MYtNg6c
	WQ3yDLNd++HzRJCgd1F8CJuJsQ2CN4pVJztf8rEFVu3iTHPK8fMGf/x8gGNvRmx1yDUJto
	/sw7sqJj00tZ4Q/7puH0Hje3dwZ9mYw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-6BpUaV_fOEO8LMYSqWcAgw-1; Fri,
 03 Oct 2025 09:42:34 -0400
X-MC-Unique: 6BpUaV_fOEO8LMYSqWcAgw-1
X-Mimecast-MFC-AGG-ID: 6BpUaV_fOEO8LMYSqWcAgw_1759498953
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 971C819560B0;
	Fri,  3 Oct 2025 13:42:32 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0B7C19560B8;
	Fri,  3 Oct 2025 13:42:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 0/7] iomap: zero range folio batch support
Date: Fri,  3 Oct 2025 09:46:34 -0400
Message-ID: <20251003134642.604736-1-bfoster@redhat.com>
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

Only minor changes in v5 to the XFS errortag patch. I've kept the R-b
tags because the fundamental logic is the same, but the errortag
mechanism has been reworked and so that one needed a rebase (which turns
out much simpler). A second look certainly couldn't hurt, but otherwise
the associated fstest still works as expected.

Note that the force zeroing fstests test has since been merged as
xfs/131. Otherwise I still have some followup patches to this work re:
the ext4 on iomap work, but it would be nice to move this along before
getting too far ahead with that.

Brian

--- Original cover letter ---

Hi all,

Here's a first real v1 of folio batch support for iomap. This initially
only targets zero range, the use case being zeroing of dirty folios over
unwritten mappings. There is potential to support other operations in
the future: iomap seek data/hole has similar raciness issues as zero
range, the prospect of using this for buffered write has been raised for
granular locking purposes, etc.

The one major caveat with this zero range implementation is that it
doesn't look at iomap_folio_state to determine whether to zero a
sub-folio portion of the folio. Instead it just relies on whether the
folio was dirty or not. This means that spurious zeroing of unwritten
ranges is possible if a folio is dirty but the target range includes a
subrange that is not.

The reasoning is that this is essentially a complexity tradeoff. The
current use cases for iomap_zero_range() are limited mostly to partial
block zeroing scenarios. It's relatively harmless to zero an unwritten
block (i.e. not a correctness issue), and this is something that
filesystems have done in the past without much notice or issue. The
advantage is less code and this makes it a little easier to use a
filemap lookup function for the batch rather than open coding more logic
in iomap. That said, this can probably be enhanced to look at ifs in the
future if the use case expands and/or other operations justify it.

WRT testing, I've tested with and without a local hack to redirect
fallocate zero range calls to iomap_zero_range() in XFS. This helps test
beyond the partial block/folio use case, i.e. to cover boundary
conditions like full folio batch handling, etc. I recently added patch 7
in spirit of that, which turns this logic into an XFS errortag. Further
comments on that are inline with patch 7.

Thoughts, reviews, flames appreciated.

Brian

v5:
- Rebased across XFS errortag mechanism rework.
v4: https://lore.kernel.org/linux-fsdevel/20250807144711.564137-1-bfoster@redhat.com/
- Update commit log description in patch 3.
- Added remaining R-b tags.
v3: https://lore.kernel.org/linux-fsdevel/20250714204122.349582-1-bfoster@redhat.com/
- Update commit log description in patch 2.
- Improve comments in patch 7.
v2: https://lore.kernel.org/linux-fsdevel/20250714132059.288129-1-bfoster@redhat.com/
- Move filemap patch to top. Add some comments and drop export.
- Drop unnecessary BUG_ON()s from iomap_write_begin() instead of moving.
- Added folio mapping check to batch codepath, improved comments.
v1: https://lore.kernel.org/linux-fsdevel/20250605173357.579720-1-bfoster@redhat.com/
- Dropped most prep patches from previous version (merged separately).
- Reworked dirty folio lookup to use find_get_entry() loop (new patch
  for filemap helper).
- Misc. bug fixes, code cleanups, comments, etc.
- Added (RFC) prospective patch for wider zero range test coverage.
RFCv2: https://lore.kernel.org/linux-fsdevel/20241213150528.1003662-1-bfoster@redhat.com/
- Port onto incremental advance, drop patch 1 from RFCv1.
- Moved batch into iomap_iter, dynamically allocate and drop flag.
- Tweak XFS patch to always trim zero range on EOF boundary.
RFCv1: https://lore.kernel.org/linux-fsdevel/20241119154656.774395-1-bfoster@redhat.com/

Brian Foster (7):
  filemap: add helper to look up dirty folios in a range
  iomap: remove pos+len BUG_ON() to after folio lookup
  iomap: optional zero range dirty folio processing
  xfs: always trim mapping to requested range for zero range
  xfs: fill dirty folios on zero range of unwritten mappings
  iomap: remove old partial eof zeroing optimization
  xfs: error tag to force zeroing on debug kernels

 fs/iomap/buffered-io.c       | 117 +++++++++++++++++++++++++----------
 fs/iomap/iter.c              |   6 ++
 fs/xfs/libxfs/xfs_errortag.h |   6 +-
 fs/xfs/xfs_file.c            |  29 ++++++---
 fs/xfs/xfs_iomap.c           |  38 +++++++++---
 include/linux/iomap.h        |   4 ++
 include/linux/pagemap.h      |   2 +
 mm/filemap.c                 |  58 +++++++++++++++++
 8 files changed, 210 insertions(+), 50 deletions(-)

-- 
2.51.0

