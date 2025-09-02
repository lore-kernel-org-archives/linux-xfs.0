Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC4231B11F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756825445; cv=none; b=B+1LG8PTmoYVpzeCRHmJvW2AeNRB4EieUyv1QWjqNnLW5KsZMbWXBV8NoY1J7qlPGINSdvMdVaNGiU205ej6RTQkTaUriebQqlU9vrAPs8fEE988zm0SpCBmPvuRPMgVCRWNt6rwkpUbOh3f1YIud2KB2YaXBtCwMLmQ8QDfFZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756825445; c=relaxed/simple;
	bh=o5p4D7iznk9qsrXsVnL7b5qBJ/DveyfWVcgqkpxQlT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CnEsyRGly/nVIL0o/L0JSz8+5NxAkI19dL90Tsq72X6cfpv5+8OSHln2yF53NtYg8gp23ml75/Q0iUfGXmoqUbqpeySrqravWwnqHvLKYdg9O/a9uHx0PpDV1jJupMBnQFi8L8jzdH3bCPePzxFwPZJWFRS9euuKGon04DMMMCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Voqi/Gs+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Voqi/Gs+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756825440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vACa1TsQUFc/du4UTAppL9owMQoQL+CDFDwa9C6qm8=;
	b=Voqi/Gs+SqFzfIOmI67jRfbp8FLkuUwoVBcOfKUoY2kpXRvsvOMC8SvXEu2bXqPR7xEihk
	aI5h50FGOxQFeED9bBjDqnbdHMPJOqurK2SO61YyeiKFHz2gCh/wg4WLLUNUwBztZsQL58
	NicmiQyZuzg28cpH1ij8SU9OY8fGjVA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-vC0bRm2TMYOCq45lP9cUtg-1; Tue,
 02 Sep 2025 11:03:55 -0400
X-MC-Unique: vC0bRm2TMYOCq45lP9cUtg-1
X-Mimecast-MFC-AGG-ID: vC0bRm2TMYOCq45lP9cUtg_1756825434
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80C0518002C8;
	Tue,  2 Sep 2025 15:03:54 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.143])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 51CD3180044F;
	Tue,  2 Sep 2025 15:03:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org
Subject: [PATCH RFC 1/2] iomap: prioritize iter.status error over ->iomap_end()
Date: Tue,  2 Sep 2025 11:07:54 -0400
Message-ID: <20250902150755.289469-2-bfoster@redhat.com>
In-Reply-To: <20250902150755.289469-1-bfoster@redhat.com>
References: <20250902150755.289469-1-bfoster@redhat.com>
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

