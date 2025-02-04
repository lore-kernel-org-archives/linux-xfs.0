Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E988321C9E8
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675710; cv=none; b=C5zoKUse3EHm4SObcDaXoCVd6olOl57y+zURQXLoYrMPempLYL0IcQTUx4sidIDHy+SaPVUDclatJMtePnOTZ1+orirOeqTzv7l353cmH8+Ael2YHNoCAt4InAp9ndx+piMqcww3TSjXskhbVdBkpMy8/jEvtLmIV6+Lur9zMiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675710; c=relaxed/simple;
	bh=eGKh3KRdk/3ZUziIGm6WiUbMlPAzZie3wJs0Y4+LSTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bw5pZ34R6HpZcRx5UfaaV/tIJTordIOArQwiNQ+hs4Sn3zR6GcsX6O0sKvHet/xgE4NSIBcYIdk4Yp4A4JWDuo7YP0Jtj/vj8m+KtW+QMFIIXS4dNUvHdqK0YbAalXEqGfDTl0S4qyCTf7Vfiqiq+/3G/ZRORO2ICfbbtf7ZTgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VS0In4bQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VS0In4bQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1TvzX3FujkmxAYmtzltYeDjBVhH5eSRJvLeBANazao=;
	b=VS0In4bQOkY7kmbZgKgxCOcl9ahYJw0IaG9YqU42wdp3fFS6za0NbNS/IuisH5/3aVE2qR
	zft1VhzWS0odvqD4fDwCIvpn8OfLpJ+dBtOXLj6tDbYAepu7u0iYZi2ba/mPxKtaqZNlf1
	qz1E5ziwA8mok8wBQ0rDkfjxbwfyfbs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-Nsq2x1EHPAq1e2vC1nu8sA-1; Tue,
 04 Feb 2025 08:28:25 -0500
X-MC-Unique: Nsq2x1EHPAq1e2vC1nu8sA-1
X-Mimecast-MFC-AGG-ID: Nsq2x1EHPAq1e2vC1nu8sA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68E011955DCC;
	Tue,  4 Feb 2025 13:28:23 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99C7319560AD;
	Tue,  4 Feb 2025 13:28:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 04/10] iomap: lift error code check out of iomap_iter_advance()
Date: Tue,  4 Feb 2025 08:30:38 -0500
Message-ID: <20250204133044.80551-5-bfoster@redhat.com>
In-Reply-To: <20250204133044.80551-1-bfoster@redhat.com>
References: <20250204133044.80551-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The error code is only used to check whether iomap_iter() should
terminate due to an error returned in iter.processed. Lift the check
out of iomap_iter_advance() in preparation to make it more generic.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/iter.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index a2ae99fe6431..fcc8d75dd22f 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -30,8 +30,6 @@ static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 	int ret = 1;
 
-	if (count < 0)
-		return count;
 	if (WARN_ON_ONCE(count > iomap_length(iter)))
 		return -EIO;
 	iter->pos += count;
@@ -86,6 +84,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			return ret;
 	}
 
+	if (iter->processed < 0) {
+		iomap_iter_reset_iomap(iter);
+		return iter->processed;
+	}
+
 	/* advance and clear state from the previous iteration */
 	ret = iomap_iter_advance(iter, iter->processed);
 	iomap_iter_reset_iomap(iter);
-- 
2.48.1

