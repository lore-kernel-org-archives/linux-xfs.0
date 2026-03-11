Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737D9175A8F
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246308; cv=none; b=qvZeh3wa7YoBrVN6lXbZ2g3LQIRlWH5vemq81kwHojIMhTiWaMdp15MNHvMLkijonBKY7r6F8qLwLP4mebY/Z2sKooKwIUdt7ip9/TpFvGwgdpCLOzNT/SoLM1jgR+jEsWfM56xQhCuMDpPwoTCysY7UL6KmtSCIYJZoQZ4ZSkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246308; c=relaxed/simple;
	bh=JjKyb+Sk9x5NFvi7VI5T6gHMswvIzGpjCKmaEwB/OsA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sLdKFtVdVdDnEX8l5HtE+998bZMYTWx0d4nsMKm+Wrt++C4a+k8wQbz09uIGtogTu/j2+Ss22XF97bPbwyYGjIl013nkaR0vPF6rGamnLsNKMByh0ewd2AzdvOgrnlUMjsvpxhT2UXTt5vusrEKcHXDiYwQNQ3JZN4eJ2TXRHr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jr5Ygam1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jr5Ygam1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773246306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uzZXyF9YB+rmmDl+MJP20K14iQ4asCSQdi1lvYx2ybU=;
	b=Jr5Ygam1srKwuU8Ei8RyA+rdxqlhbmCSoHu2Nu5LX/4JjkFTae72A47mLBwDPC/rCi+C0a
	CDINiAt8CXx4Bvw/KeuX47lSTYKKEMtndV8HucHkDM3rz+e8U3U4Y4iBHgAz/WdZqYslry
	OLvnbwrcZvCfD0/xOuTM/WH8OrRChVY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-calZ8TFUOZia71NmvqkT4Q-1; Wed,
 11 Mar 2026 12:25:04 -0400
X-MC-Unique: calZ8TFUOZia71NmvqkT4Q-1
X-Mimecast-MFC-AGG-ID: calZ8TFUOZia71NmvqkT4Q_1773246303
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A59D0195605F;
	Wed, 11 Mar 2026 16:25:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F9D018002A6;
	Wed, 11 Mar 2026 16:25:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/8] iomap, xfs: improve zero range flushing and lookup
Date: Wed, 11 Mar 2026 12:24:54 -0400
Message-ID: <20260311162502.192375-1-bfoster@redhat.com>
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

No significant changes in v4. A few whitespace fixes throughout and I've
added some R-b tags from v3 review. Thanks.

Brian

v4:
- Minor whitespace cleanups.
v3: https://lore.kernel.org/linux-fsdevel/20260309134506.167663-1-bfoster@redhat.com/
- Inserted new patches 1-2 to fix up zoned mode zeroing.
- Appended patch 8 to correctly report COW mappings backed by data fork
  holes.
- Various minor fixups to logic, whitespace, comments.
v2: https://lore.kernel.org/linux-fsdevel/20260129155028.141110-1-bfoster@redhat.com/
- Patch 1 from v1 merged separately.
- Fixed up iomap_fill_dirty_folios() call in patch 5.
v1: https://lore.kernel.org/linux-fsdevel/20251016190303.53881-1-bfoster@redhat.com/

Brian Foster (8):
  xfs: fix iomap hole map reporting for zoned zero range
  xfs: flush dirty pagecache over hole in zoned mode zero range
  iomap, xfs: lift zero range hole mapping flush into xfs
  xfs: flush eof folio before insert range size update
  xfs: look up cow fork extent earlier for buffered iomap_begin
  xfs: only flush when COW fork blocks overlap data fork holes
  xfs: replace zero range flush with folio batch
  xfs: report cow mappings with dirty pagecache for iomap zero range

 fs/iomap/buffered-io.c |   6 +-
 fs/xfs/xfs_file.c      |  17 +++++
 fs/xfs/xfs_iomap.c     | 146 +++++++++++++++++++++++++++++++----------
 3 files changed, 130 insertions(+), 39 deletions(-)

-- 
2.52.0

