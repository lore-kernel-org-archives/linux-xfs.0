Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0D5464B
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731700829; cv=none; b=newAZ1ALOv6HjuO2Iovc2+mW3S7m2GWEKNmx+MSt68myx4PAxzD0PsWjqznKdAYMHRnjxa3DXPVlY3uXpIXWuD+sIlNTmU9HCRFqatu8ooSVGPqt0brqZ+6zOCPg1MJ/zRWiTBYFxrr6PHyTwrhgQRr8JrBmP5LMaaH1BB/yFfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731700829; c=relaxed/simple;
	bh=08Aa6vvPQS4QfNhVj2ez31vfeIrNw+g2CEKRYFqpECk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IKwmRRaOKgLy4wV3Wlw8HLpaIBrkdOJ40ba2kXa2q2+Z5BL7Caj5veVZiiLKnX6l11nMT8l1ZBPZUIfUg0C9Tf5bXH4vIp4v4/Viz9eNVExvjrTmlZmm6Fr6y0YfsbK2iaqjgsfFV/UyfYeammOwk9AAFbrVtyD0c+1K33YYhvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MO3/j0R+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MO3/j0R+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731700825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nAPUPGWq9EiDqg2+E5uyrXvP2R1jRrs8FLWMOsY6ij8=;
	b=MO3/j0R+PFVnGTHzyJVcAxOgPgyGOg6suVg8xglvtQnvyWhmWWGas+1eg4qhJINaPHbRXd
	b0TxzNVDmBtH49Ysvp2DO6fGUPtRaN7BtB7rZFCWMVC+EWPX4v6XnCK8tmSGycNMKgaaAl
	ybnkbxZJPAMViNDPG5LI8e8aCdp9wYs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-3nizc3uTM96RlwaQp6fXmQ-1; Fri,
 15 Nov 2024 15:00:23 -0500
X-MC-Unique: 3nizc3uTM96RlwaQp6fXmQ-1
X-Mimecast-MFC-AGG-ID: 3nizc3uTM96RlwaQp6fXmQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 317CD19560B4;
	Fri, 15 Nov 2024 20:00:22 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E088B1953880;
	Fri, 15 Nov 2024 20:00:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v4 0/3] iomap: zero range flush fixes
Date: Fri, 15 Nov 2024 15:01:52 -0500
Message-ID: <20241115200155.593665-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi all,

Here's v4 of the zero range flush improvements. No real major changes
here, mostly minor whitespace, naming issues, etc.

Brian

v4:
- Whitespace and variable naming fixes.
- Split off patch 4 to a separate post.
v3: https://lore.kernel.org/linux-fsdevel/20241108124246.198489-1-bfoster@redhat.com/
- Added new patch 1 to always reset per-iter state in iomap_iter.
- Dropped iomap_iter_init() helper.
- Misc. cleanups.
- Appended patch 4 to warn on zeroing beyond EOF.
v2: https://lore.kernel.org/linux-fsdevel/20241031140449.439576-1-bfoster@redhat.com/
- Added patch 1 to lift zeroed mapping handling code into caller.
- Split unaligned start range handling at the top level.
- Retain existing conditional flush behavior (vs. unconditional flush)
  for the remaining range.
v1: https://lore.kernel.org/linux-fsdevel/20241023143029.11275-1-bfoster@redhat.com/

Brian Foster (3):
  iomap: reset per-iter state on non-error iter advances
  iomap: lift zeroed mapping handling into iomap_zero_range()
  iomap: elide flush from partial eof zero range

 fs/iomap/buffered-io.c | 88 +++++++++++++++++++++---------------------
 fs/iomap/iter.c        | 11 +++---
 2 files changed, 50 insertions(+), 49 deletions(-)

-- 
2.47.0

