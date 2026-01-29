Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417F32ED39
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 15:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769701835; cv=none; b=igcqBlxRa8wGBl21rNX0FTlFvib3exusgJYiLvVeu1t1JXQgWV6vxecdk9PSQEsATuxvR/pPQpmCFdXlTArdAEvrNMMk/cYj8YLdmfqn2d9xqZHM8+IPDlKgHHZwDk7n5fTLsaKTq9mzWs9QoCaXOpFBstzkiAt83PghpDa+/kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769701835; c=relaxed/simple;
	bh=dVoci7UurIKaLWVhEEQyOA/oRtbZVi8H/yVXGSLOoME=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZTpg2EFRr4IjmUxoHekELHnZJepLMM7zji4Of0w/IDP/taSybyhbQ7vS20vIRgUguWm3Zqu9tCB2iVqKXZnLanNysW2PkB1C3ogJlDrg/BtYPK45fLt77pZB+FrcVE21D0tc+JmXhgAlfoXW6r1kXtA7Nwi4o3SrBdNjQu0hAjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RkrZCMVE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RkrZCMVE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769701833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f6i3WlIu8fBaSjICdJuR/n+CyzTL3A1o0ivoFGDjDtQ=;
	b=RkrZCMVEOEelTFDQk+Qa0xDBITTmkJ52UkFufg6BInRNd8cTLctdltS0J0VCUO5oIR59Ci
	XfUY/8wSxvrl+CuPMs3eGxFc+neXxzp0kTL7fRCiMvMmj3S4oqxPdY73+6/Y4bNVuUEgw/
	Ek+gRMsA7r2Pq7j8KNYiNXXg7RErdMA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-4ZKjX25YN3GuGvp1pn5uyA-1; Thu,
 29 Jan 2026 10:50:30 -0500
X-MC-Unique: 4ZKjX25YN3GuGvp1pn5uyA-1
X-Mimecast-MFC-AGG-ID: 4ZKjX25YN3GuGvp1pn5uyA_1769701829
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41AEA1956060;
	Thu, 29 Jan 2026 15:50:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.81.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2F901800109;
	Thu, 29 Jan 2026 15:50:28 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/5] iomap, xfs: improve zero range flushing and lookup
Date: Thu, 29 Jan 2026 10:50:23 -0500
Message-ID: <20260129155028.141110-1-bfoster@redhat.com>
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

Here's v2 of the iomap zero range flush cleanup patches. Patch 1 in v1
has already been merged separately, so that's dropped off. Otherwise no
major changes from v1. The remaining patches here lift the flush into
XFS, fix up the insert range issue that the flush implicitly suppressed,
streamlines the .iomap_begin() logic a bit, and finally replaces the
just lifted flush with proper use of the folio batch mechanism. The end
result is that the flush remains in iomap zero range purely as a
fallback for callers who do not provide a folio batch for pagecache
dirty unwritten mappings.

WRT some of the discussion on v1.. I looked into changing how COW blocks
over data fork holes are reported in XFS as a first step, but I
eventually ran into complexity that would essentially duplicate some of
the hacks I'm trying to clean up. For example, we'd have to determine
whether to report as a hole or "data" mapping based on pagecache state,
and this series adds some of that by the end by explicitly doing the
dirty folio lookup in this scenario. I'll plan to revisit this on top of
this series as a standalone XFS improvement, but haven't got there yet.

The other thing that is a little more annoying was failure of the idea
to essentially prep the shift where patch 2 adds an EOF folio flush [1].
This ordering leads to potential pagecache inconsistency because the
i_size update can zero and repopulate pagecache. I'm open to other ideas
here, but otherwise haven't been able to think of anything more
clever/simple (including futzing around for suggestions with AI). All in
all I still think this is more clear having the flush isolated in insert
range where it is actually required than having a flush in iomap
indirectly suppress the problem.

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20251105001445.GW196370@frogsfrogsfrogs/

v2:
- Patch 1 from v1 merged separately.
- Fixed up iomap_fill_dirty_folios() call in patch 5.
v1: https://lore.kernel.org/linux-fsdevel/20251016190303.53881-1-bfoster@redhat.com/

Brian Foster (5):
  iomap, xfs: lift zero range hole mapping flush into xfs
  xfs: flush eof folio before insert range size update
  xfs: look up cow fork extent earlier for buffered iomap_begin
  xfs: only flush when COW fork blocks overlap data fork holes
  xfs: replace zero range flush with folio batch

 fs/iomap/buffered-io.c |  6 +--
 fs/xfs/xfs_file.c      | 17 +++++++++
 fs/xfs/xfs_iomap.c     | 87 ++++++++++++++++++++++++++++++------------
 3 files changed, 81 insertions(+), 29 deletions(-)

-- 
2.52.0

