Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750501D14FB
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031133; cv=none; b=FzVH2z6hr8X6OUa0w+rddZZkkqvmnzVXCY26a/ZW4S3hy2m9UnI1iXEEpArxaXhlCVg8VJ9L/3KvNkIF13O/74iXQLHdHbFigx/879+VKcuaLMT7F1xeIxKBCkBZMiplK1m5TgaR5rlkEflZZloa0odb3dnd4M9SpInYYTxBoGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031133; c=relaxed/simple;
	bh=uXa3GNCk4+aFvMxdlZDkyJ47Ip4E24kVOh9sGLv24X8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=btXfSwGv+8/J9Exnsb2k79jZsqacrJ+xY2TgE1/Mck6XIqxahfctXwm6PmRq9K5fUoeOtyRSoi6pGvOY5zCOzdgqcNYsm/vgz1a+3IVZfMQSZHpEOcmjGqfjeNWIHg5Z+lf6c/vQrXSslNiBQmcNYpYNtA7Pfl1dyHuuHh8+EEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YWy4Nnns; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWy4Nnns"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732031129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D58nFfd1UxCC7UJee48pdA41F8/AUZLtav09tMWCaOA=;
	b=YWy4Nnnsl8U8wV4KEo/kCx8hLx6xzEYaaa7H+GI2pbCSsTFU0936+cVtglZExvLXkf7qX4
	NTzin1/PBGNMlo/Hz7UQ54zbEhIYMoICCiVLU6tNy6CB/YQpZYNywvoOc1JkOIBDRB0RE/
	f7+hyVHZJ0UsA5T4i0FpV8N6iW9Hc/0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-VjQUdmsJNiqIK03a2mPqNg-1; Tue,
 19 Nov 2024 10:45:24 -0500
X-MC-Unique: VjQUdmsJNiqIK03a2mPqNg-1
X-Mimecast-MFC-AGG-ID: VjQUdmsJNiqIK03a2mPqNg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DE8B1955EE8;
	Tue, 19 Nov 2024 15:45:22 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C69851956054;
	Tue, 19 Nov 2024 15:45:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFC 0/4] iomap: zero range folio batch processing prototype
Date: Tue, 19 Nov 2024 10:46:52 -0500
Message-ID: <20241119154656.774395-1-bfoster@redhat.com>
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

Here's a first pass prototype of dirty folio batch processing for zero
range. The idea here is that the fs can avoid pagecache flushing or
wonky ordering/racing issues by passing in a batch of dirty folios that
might exist over unwritten mappings at lookup time.

This is only lightly tested so far, but works well enough to demonstrate
the idea. The biggest open question in my mind is how to better define
the interface. For now I just stuffed the folio_batch in the struct
iomap, but I don't really like it there due to confusion between iomap
and srcmap and because it bloats the structure.

I thought about using ->private along with a custom ->get_folio(), but I
don't think that really fits the idea of a built-in mechanism. It might
be more appropriate to attach to the iter, but that currently isn't
accessible to ->iomap_begin(). I suppose we could define an
iomap_to_iter() or some such helper that the fill helper could use to
populate the batch, but maybe there are other thoughts/ideas?

Brian

Brian Foster (4):
  iomap: allow passing a folio into write begin path
  iomap: optional zero range dirty folio processing
  xfs: always trim mapping to requested range for zero range
  xfs: fill dirty folios on zero range of unwritten mappings

 fs/iomap/buffered-io.c | 93 ++++++++++++++++++++++++++++++++++++++----
 fs/iomap/iter.c        |  2 +
 fs/xfs/xfs_iomap.c     | 28 ++++++++-----
 include/linux/iomap.h  |  5 +++
 4 files changed, 109 insertions(+), 19 deletions(-)

-- 
2.47.0

