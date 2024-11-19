Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2111D0DC0
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031133; cv=none; b=al8e6M3oMG5fEulemWTaTMiwAwHc8/YJprGNLp0cq9K5gi5TNvMZahzDdvo/gRaSPMzbANdGuFOTLE4hMtVeUqE6LS5E58KDEuI0eB60SloJRF9O2D2t65qcgAcBJJEP03uq4gxXd+jBojcLRagDzGNFjvCno0nTTe3Spzf6UWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031133; c=relaxed/simple;
	bh=Up3cclIyE+AvTp4pGY/iLJVrtvPIKk/vFgFUeo+opMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W7F2rIHNbPU/0Yp7T62J17OC+dS6iQSuImj8NM3uDjhf/GonziwH2b5BZT/amlajwP49j+HogCmN3B8Qp1baJbcDEiMYKZAr2eG9b7R1c1jL9Yj+a7eabI8PCvV1LYZR3TPh2HTYkNV4+wBgD4C2uS2TqQgV50K3WjVQ5qdRTIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEkiUWsV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEkiUWsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732031130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8f8HKbKWh0kuU3b7VdbwercA9aW0MwtWzpz5jhuYWvU=;
	b=MEkiUWsVXFwLWoj2dnxY7DkTricRPXO+8nW0DFjWFapd/aDolG6hrJzSEKF1ka6f267naT
	mrwNjqrkmWrUTZffTviruoH+3z/0X3IuZe5qjFOuSNOPrExHRyqY/VgdPPNd05nUbDyR+L
	WGIoQCq0T9WXu0JZDBRz/fVM7/TY2O4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-J0OgBZk7OrqsTVbKWd7sEw-1; Tue,
 19 Nov 2024 10:45:27 -0500
X-MC-Unique: J0OgBZk7OrqsTVbKWd7sEw-1
X-Mimecast-MFC-AGG-ID: J0OgBZk7OrqsTVbKWd7sEw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3236D19560B5;
	Tue, 19 Nov 2024 15:45:26 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6BE411956054;
	Tue, 19 Nov 2024 15:45:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFC 4/4] xfs: fill dirty folios on zero range of unwritten mappings
Date: Tue, 19 Nov 2024 10:46:56 -0500
Message-ID: <20241119154656.774395-5-bfoster@redhat.com>
In-Reply-To: <20241119154656.774395-1-bfoster@redhat.com>
References: <20241119154656.774395-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Use the iomap folio batch mechanism to identify which folios to zero
on zero range of unwritten mappings. Trim the resulting mapping if
the batch is filled (unlikely) and set the HAS_FOLIOS flag to inform
iomap that pagecache has been checked for dirty folios.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ed42a28973bb..d84b7abf540c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1037,6 +1037,15 @@ xfs_buffered_write_iomap_begin(
 				goto convert_delay;
 			if (end_fsb > eof_fsb)
 				end_fsb = eof_fsb;
+		} else if (imap.br_state == XFS_EXT_UNWRITTEN) {
+			u64 end;
+
+			xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
+			end = iomap_fill_dirty_folios(VFS_I(ip), iomap,
+					XFS_FSB_TO_B(mp, imap.br_startoff),
+					XFS_FSB_TO_B(mp, imap.br_blockcount));
+			end_fsb = min_t(xfs_fileoff_t, end_fsb, XFS_B_TO_FSB(mp, end));
+			iomap_flags |= IOMAP_F_HAS_FOLIOS;
 		}
 		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	}
-- 
2.47.0

