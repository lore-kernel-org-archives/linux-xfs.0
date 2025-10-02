Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D826B742
	for <linux-xfs@vger.kernel.org>; Thu,  2 Oct 2025 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759425404; cv=none; b=YZgNlAAWcd2/yCtjPbH9IBdtxhfYAF+9IglthjSshEE54ximAoZ0lfRQr1kKf8bMAWkv7onLSjeVrDYUOhwkHBQZ+AvfvxJnJsUmlKzL9+t56FkbYO1yToBZ9tkzCAgt5IDVpZWeW8jrNtz5sObkX7M1K4jxPYuIX6Zu1obOijg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759425404; c=relaxed/simple;
	bh=MhbcOwX2MxS51mmnD4KeIrKi3jxNGwv7djuoxh2v8yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJ9SPnclARbcg9zdbnOqqCMy5PHfxubgacZJza41W2Pww+WuCFqOBELkZxCinKAemyj3RW6sMKgigD+gh6CMcbJ0cDJj2h2GWIbFuvaV01TXyEO7g2gJjYVirYBmJQfP/ZsVM7NuU0JN5FmLZD6mkTvPY6KtvdpTq8LmqYmKOdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VqJMVpFG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VqJMVpFG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759425402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=roK87h7SJk0xMszRssGEGW3y5zhgvRYMHOpqvKw92wA=;
	b=VqJMVpFGz95KhNOdP7siPvqfllAmD9UDodGnXEQc0nlZQfFX64qiYh9cvOmOOJRt53uKsw
	G/AJWWG4Kb0GOA4jL4E3Gc+soFKs4OAB9WCw1ZL+ldnozw10/waaECvMWa+jDAkHeiBZra
	YOW/K5d3HpLMXW2Tkoh6XDhyY7Ms12A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-470-jrwbawWkPbqUHy4IhGhxZQ-1; Thu,
 02 Oct 2025 13:16:30 -0400
X-MC-Unique: jrwbawWkPbqUHy4IhGhxZQ-1
X-Mimecast-MFC-AGG-ID: jrwbawWkPbqUHy4IhGhxZQ_1759425389
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D5FD195608B;
	Thu,  2 Oct 2025 17:16:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 30E021800452;
	Thu,  2 Oct 2025 17:16:28 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 1/2] iomap: prioritize iter.status error over ->iomap_end()
Date: Thu,  2 Oct 2025 13:20:37 -0400
Message-ID: <20251002172038.477207-2-bfoster@redhat.com>
In-Reply-To: <20251002172038.477207-1-bfoster@redhat.com>
References: <20251002172038.477207-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Jan Kara reports that commit bc264fea0f6f subtly changed error
handling behavior in iomap_iter() in the case where both iter.status
and ->iomap_end() return error codes. Previously, iter.status had
priority and would return to the caller regardless of the
->iomap_end() result. After the change, an ->iomap_end() error
returns immediately.

This had the unexpected side effect of enabling a DIO fallback to
buffered write on ext4 because ->iomap_end() could return -ENOTBLK
and overload an -EINVAL error from the core iomap direct I/O code.

This has been fixed independently in ext4, but nonetheless the
change in iomap was unintentional. Since other filesystems may use
this in similar ways, restore long standing behavior and always
return the value of iter.status if it happens to contain an error
code.

Fixes: bc264fea0f6f ("iomap: support incremental iomap_iter advances")
Diagnosed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 fs/iomap/iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index cef77ca0c20b..7cc4599b9c9b 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -80,7 +80,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 				iomap_length_trim(iter, iter->iter_start_pos,
 						  olen),
 				advanced, iter->flags, &iter->iomap);
-		if (ret < 0 && !advanced)
+		if (ret < 0 && !advanced && !iter->status)
 			return ret;
 	}
 
-- 
2.51.0

