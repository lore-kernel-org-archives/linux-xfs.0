Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B611DF724
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393159; cv=none; b=e5L6uDkyUuDVljb5/iVQclkczsOpUcILaNeyTCyQhziKITNY6FPYslOoQH2x0LtHgjroAe/dYFsHVzethxA9wHD1fepljwJn8/nrVoeerIFCb1whanXnOp0l/9zpsittDhdEoQVfgLeIZ5GDxLah8fvZTdmy4pgPQOEWX4vsFic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393159; c=relaxed/simple;
	bh=kFGKMzVr0OwYGGRIXktIxKRVZoIrbCtYUa24f8UIj/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AYwJqM3ozTjcNjzw5agkYlq8oiORkSrwXE+BfCVsxaOinqZ2YE4gvOjaKLM/I+Obf2myw9iv5AXmao1oOzMPFUq6VD/5mHeqYbT5xSZjGlui+LzYi0Njz9HwiF3nvLL0fLTR61Ej9wkwdTBgyQRvIWex7Dk8QK2euisO9H8G48U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HAHhyndZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAHhyndZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728393155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PPlPkPkaO/Q+BSELOYcpjfKOGvQ4rjLnT5rJ6odqxRc=;
	b=HAHhyndZnEAT26K20FAKraWOZHrzFP1uihbvQGWF5REsQLHXFf0u9Sr3rjrpsX48kG1Ufa
	QGJAfZJEroZPnR0EspRjkaGRDOq68hf0dHjtThIrHMmNIYSwXR3E2D5ed/e4G4oZwXWPaq
	2E1ewKdo7AXdvJBOWkU9hhHDa2O1urw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-1qsiyY92NcipsAcWMLL67g-1; Tue,
 08 Oct 2024 09:12:32 -0400
X-MC-Unique: 1qsiyY92NcipsAcWMLL67g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFA181955EE8;
	Tue,  8 Oct 2024 13:12:31 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E499C19560AA;
	Tue,  8 Oct 2024 13:12:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [RFC 0/4] xfs: prototype dynamic AG size grow for image mode
Date: Tue,  8 Oct 2024 09:13:44 -0400
Message-ID: <20241008131348.81013-1-bfoster@redhat.com>
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

This is a followup to the discussion here [1] on some ideas on how to
better deal with the growfs agcount scalability problem that cloud use
cases tend to run into. This series prototypes the concept of using an
agcount=1 mkfs format to facilitate more dynamic growfs behavior. More
specifically, we can grow the AG size of the filesystem up until a
second AG is added, so therefore we can use the target growfs size to
set a more suitable AG size at growfs time.

As per the previous discussion, there are multiple different ways this
can go, in xfsprogs and the kernel. For example, a size hint could be
provided to mkfs to avoid growfs time changes, a feature bit could be
used to manage functionality, AG size changes could be separated into a
different ioctl to lift the heuristic into userspace, etc. The purpose
here is simply to implement some of the core mechanism as conveniently
as possible and to explore whether it is a workable and potentially
useful improvement.

Patches 1-3 are prep/cleanup patches and not worth digging too much
into. Patch 4 hacks AG size growth into the typical growfs path and uses
a simple heuristic to provide fairly conservative behavior in the case
of unexpectedly small grows. See the commit logs and code comments for
more details and discussion points. Finally, note that this has only
seen light and targeted testing. Thoughts?

Brian

[1] https://lore.kernel.org/linux-xfs/20240812135652.250798-1-bfoster@redhat.com/

Brian Foster (4):
  xfs: factor out sb_agblocks usage in growfs
  xfs: transaction support for sb_agblocks updates
  xfs: factor out a helper to calculate post-growfs agcount
  xfs: support dynamic AG size growing on single AG filesystems

 fs/xfs/libxfs/xfs_shared.h |   1 +
 fs/xfs/xfs_fsops.c         | 137 ++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_trans.c         |  15 ++++
 fs/xfs/xfs_trans.h         |   1 +
 4 files changed, 137 insertions(+), 17 deletions(-)

-- 
2.46.2

