Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436094611C9
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786713767; cv=none; b=F2LvyKGSB+8L2MWZIMe/8p5ChWQccRPD41k1n71pXKfjqbJEJGqR0Gf+L17FEuh1Wt/M6OXfttb3DC1sml6r1gsAwAud891yvIX0RhcP/YoYI39zctzcdOTOnAmelKmoImaqZFUmvMbxEHOdpb0T0iRATfNfwGyTbfgMf0USX8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786713767; c=relaxed/simple;
	bh=hb9fgApqEeYmJz2uVHLpQR+HJ45nkZk1zglZQWU93s4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nez+Q6QPRRKD1bt6DQpNjQA9tA8usGq7jFb/BYlgHT5mguK6Gg6iOQbQZYxATU2RUlwfNddBDN+XPHNulUApjasuSVQAiYD5Li83Z7oj5WEvi8UnZwfBI3itZARcFGMYedpLk6wlpGyxa/Dt+YVVwo+7Rw0jZ/Ys3JmEU4l94nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iGJUXtCd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGJUXtCd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786713765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZeYayW/24G3TxKQblfV7CrY1EZzEA+AVjLJtZ63NpnU=;
	b=iGJUXtCdWzgHkOpCfLY4W9IgPZHjpiKsC6LxG5+3w36cdMqc8hLi+sV76WdaTghnaOatIY
	RhH0PzbHqeYbDZ0/50T2MpEVjz5nEmppc4FU/WTQs06enB6312bOSKaLCKQMRx89RRKcHr
	L0pFBBroHQzs4IpgFwnOeQ02fR9dIDA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-OReqUZi3MiSAkSGRSFfv0A-1; Fri,
 14 Aug 2026 09:22:41 -0400
X-MC-Unique: OReqUZi3MiSAkSGRSFfv0A-1
X-Mimecast-MFC-AGG-ID: OReqUZi3MiSAkSGRSFfv0A_1786713761
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3049180034F;
	Fri, 14 Aug 2026 13:22:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.105])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57173195608A;
	Fri, 14 Aug 2026 13:22:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: [PATCH v2 0/3] xfs: fix a couple sparse chunk alloc problems
Date: Fri, 14 Aug 2026 09:22:36 -0400
Message-ID: <20260814132239.271492-1-bfoster@redhat.com>
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

Here's v2 of the series to fix the sparse chunk alloc shutdown. The
original report is available here[1]. After some discussion on v1, this
takes a slightly different approach to treat this as an allocator flaw.
The solution is essentially to add the additional min_free block
requirement to minleft for allocs where minleft != 0. See the commit log
for patch 3 for further detail.

Patch 1 is the same DEBUG mode bug fix from v1. Patch 2 refactors the
agfl min free helper for use in patch 3. Patch 3 makes the actual logic
fix.

This survives some fstests runs without regression. For some reason the
sparse inode reproducer is failing to work properly on the current
baseline (can't create the requisite fs state) so I can't reconfirm
that, but I don't expect anything would have changed there.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Reworked fix logic into allocator instead of sparse inode alloc
  specific.
- Dropped Fixes: tag since this is no longer directly correlated to
  sparse inodes.
v1: https://lore.kernel.org/linux-xfs/20260731163337.152522-1-bfoster@redhat.com/

[1] https://lore.kernel.org/linux-xfs/20260717130429.1838767-1-matt@readmodwrite.com/

Brian Foster (3):
  xfs: set minleft correctly for sparse chunk errortag allocation
  xfs: support additional levels in the agfl minimum calculation
  xfs: incorporate increased AGFL min requirement for minleft allocs

 fs/xfs/libxfs/xfs_alloc.c  | 60 ++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc.h  |  2 ++
 fs/xfs/libxfs/xfs_bmap.c   |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c | 10 +++----
 4 files changed, 58 insertions(+), 16 deletions(-)

-- 
2.55.0

