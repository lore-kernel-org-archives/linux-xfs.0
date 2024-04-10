Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB17F15EFC8
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 14:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712758082; cv=none; b=qCnftZGqDTLmHWVBQ+M//AuXdr7Kngi71jMKxBvTBZGPG9ObkToAbQuzUwUsKWPhtG1wTxjROJQQch5r+s4h9tr7WZjJs2c2DUjUbwWlP3+HCPhoNHN/HoSR3VZdV1nr/KyUl0pDJ8CB6DmTsEDXizyy2nd0D9gEdtNdpiObHoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712758082; c=relaxed/simple;
	bh=LzBg+SBioBo8xCGEGC5RqX/Hf1BAhLQ11wPnqRPpltg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QtYHqA66X4RNMQ2Bx7lsO2P4aeZpa4EgSx5uwF7OufmWVNGwDys55ZZWIeqv15ZGmvoFNqRrHG4xbvqmP5vfTVOSgxPLS5cbrFXfLf0GNQ0L/4/JtAjKXtMtQejknqddGc+8xn1Bk3eXb0IipxTjHNGEHXKSK8tgdpCj+zdKsOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CG05Vjol; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CG05Vjol"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712758079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CF9Dg9gDKyV6J5ZiZHWOatvVjqSUi1XEkmSy9m3PTAE=;
	b=CG05VjolU4Q9g+wlwy3cnmlWUmfi/G9DJtXxI7W7Nkpy9KCIZfYjfANp47tr79SlOU3iVd
	Y+z8ZurM9IW1Wwpn7Qv1j5G2hM2t9l8cUAzbp34qX/4EEh+NGTLNk9XZ53E9mueqle+R5R
	CTzFzyOJsAKA2LBeaS1Qv01g+yQeTN4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-ziqFBKLuPnuVZbwwEbvAwQ-1; Wed,
 10 Apr 2024 10:07:58 -0400
X-MC-Unique: ziqFBKLuPnuVZbwwEbvAwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD7E03C108D8;
	Wed, 10 Apr 2024 14:07:57 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF4DB1C060A6;
	Wed, 10 Apr 2024 14:07:57 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH RFC 0/3] xfs: nodataio mount option to skip data I/O
Date: Wed, 10 Apr 2024 10:09:53 -0400
Message-ID: <20240410140956.1186563-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Hi all,

bcachefs has a nodataio mount option that is used for isolated metadata
performance testing purposes. When enabled, it performs all metadata I/O
as normal and shortcuts data I/O by directly invoking bio completion.
Kent had asked for something similar for fs comparison purposes some
time ago and I put together a quick hack based around an iomap flag and
mount option for XFS.

I don't recall if I ever posted the initial version and Kent recently
asked about whether we'd want to consider merging something like this. I
think there are at least a couple things that probably need addressing
before that is a viable option.

One is that the mount option is kind of hacky in and of itself. Beyond
that, this mechanism provides a means for stale data exposure because
writes with nodataio mode enabled will operate as if writes were
completed normally (including unwritten extent conversion). Therefore, a
remount to !nodataio mode means we read off whatever was last written to
storage.

Kent mentioned that Eric (or somebody?) had floated the idea of a mkfs
time feature flag or some such to control nodataio mode. That would
avoid mount api changes in general and also disallow use of such
filesystems in a non-nodataio mode, so to me seems like the direction
bcachefs should go with its variant of this regardless.

Personally, I don't have much of an opinion on whether something like
this lands upstream or just remains as a local test hack for isolated
performance testing. The code is simple enough as it is and not really
worth the additional polishing for the latter, but I offered to at least
rebase and post for discussion. Thoughts, reviews, flames appreciated.

Brian

Brian Foster (3):
  iomap: factor out a bio submission helper
  iomap: add nosubmit flag to skip data I/O on iomap mapping
  xfs: add nodataio mount option to skip all data I/O

 fs/iomap/buffered-io.c | 37 ++++++++++++++++++++++++++++---------
 fs/xfs/xfs_iomap.c     |  3 +++
 fs/xfs/xfs_mount.h     |  2 ++
 fs/xfs/xfs_super.c     |  6 +++++-
 include/linux/iomap.h  |  1 +
 5 files changed, 39 insertions(+), 10 deletions(-)

-- 
2.44.0

