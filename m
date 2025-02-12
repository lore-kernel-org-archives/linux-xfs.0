Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1222720E018
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368495; cv=none; b=bm3Z+oI/9+buOSw9ag27TVfpCkF2fqZWIP0HTtc62/Fo9Y0J5jILRblRdmH6VAOG48PU8lY/JLqFPtt3d0rjlwvZWNHL5aCGPbJoRd2zsIVUMBUyaryv70+mvBHXn80XgE44Xl4aU54xDrGJbqW5PMxgC11MjlKzx6FT3U6Fs2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368495; c=relaxed/simple;
	bh=lbMKMc9fHMiaHQg/178Fq8gbxvG1/EP+db4iki35h5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GyuHFjoTYL1+sg2MJK9XxCpOvykkExNCQv+qfMiFDxxjdbN3/sFV0tfVpOWdsgez6lH7W284dYl5KQ4t2XJkiAyBJDfcyp471FUiHYIoMnE0hrooL1cBSbghKLQPLy+LhCi1wTMe7efKoC+mP7Coqhn7aI/Ll3dT7DM+0ZO+gkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jz9cuCky; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jz9cuCky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739368493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgAXZZwgoELKscXhbq8nIWtE5X5J86hzsHmax2iMyIc=;
	b=Jz9cuCkyJdbZV6jZ0CYxOgnm7PNPxUddrr00VnE3WqHa3jsfJZFht6PgqysdgqGX1/BOs3
	EyAGSAHoTRIBcQsZzM+13u2/1nieDvmquHV0TP3F08OQxy2IPW7UALXJclZmpoPwZ8J/LB
	Af6iklO3vBhWdJu1cM5EOpP1hsHLBbs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-xeUDCqVZOZqurvfWdZr3bQ-1; Wed,
 12 Feb 2025 08:54:49 -0500
X-MC-Unique: xeUDCqVZOZqurvfWdZr3bQ-1
X-Mimecast-MFC-AGG-ID: xeUDCqVZOZqurvfWdZr3bQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D21791800980;
	Wed, 12 Feb 2025 13:54:48 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 992B030001AB;
	Wed, 12 Feb 2025 13:54:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 02/10] iomap: advance the iter on direct I/O
Date: Wed, 12 Feb 2025 08:57:04 -0500
Message-ID: <20250212135712.506987-3-bfoster@redhat.com>
In-Reply-To: <20250212135712.506987-1-bfoster@redhat.com>
References: <20250212135712.506987-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Update iomap direct I/O to advance the iter directly rather than via
iter.processed. Since unique subhelpers exist for various mapping
types, advance in the commonly called iomap_dio_iter() function.
Update the switch statement branches to fall out, advance by the
number of bytes processed and return either success or failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/direct-io.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b521eb15759e..cb0b0b0f07b3 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -515,22 +515,29 @@ static loff_t iomap_dio_inline_iter(const struct iomap_iter *iomi,
 	return copied;
 }
 
-static loff_t iomap_dio_iter(const struct iomap_iter *iter,
+static int iomap_dio_iter(struct iomap_iter *iter,
 		struct iomap_dio *dio)
 {
+	loff_t len;
+
 	switch (iter->iomap.type) {
 	case IOMAP_HOLE:
 		if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
 			return -EIO;
-		return iomap_dio_hole_iter(iter, dio);
+		len = iomap_dio_hole_iter(iter, dio);
+		break;
 	case IOMAP_UNWRITTEN:
 		if (!(dio->flags & IOMAP_DIO_WRITE))
-			return iomap_dio_hole_iter(iter, dio);
-		return iomap_dio_bio_iter(iter, dio);
+			len = iomap_dio_hole_iter(iter, dio);
+		else
+			len = iomap_dio_bio_iter(iter, dio);
+		break;
 	case IOMAP_MAPPED:
-		return iomap_dio_bio_iter(iter, dio);
+		len = iomap_dio_bio_iter(iter, dio);
+		break;
 	case IOMAP_INLINE:
-		return iomap_dio_inline_iter(iter, dio);
+		len = iomap_dio_inline_iter(iter, dio);
+		break;
 	case IOMAP_DELALLOC:
 		/*
 		 * DIO is not serialised against mmap() access at all, and so
@@ -545,6 +552,10 @@ static loff_t iomap_dio_iter(const struct iomap_iter *iter,
 		WARN_ON_ONCE(1);
 		return -EIO;
 	}
+
+	if (len < 0)
+		return len;
+	return iomap_iter_advance(iter, &len);
 }
 
 /*
-- 
2.48.1

