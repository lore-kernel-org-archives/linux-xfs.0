Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EA913A25F
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723054640; cv=none; b=PEw0c9SdeW/E7YWY3VSi8KhfabycjhjBh3xM8I5ale8q6WdQzl7uWjSdsq+P7qOJkmcjLkWeSjVnTiqn7C2Uexa/3tG4zvpjXyWHZoPzcxbK8WiErEFkz6dPbI6mnMH37SFlR9yrBn89ZwwsFT08ApGG/nAknntHCHGj4mDduZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723054640; c=relaxed/simple;
	bh=1HgW+0iNpLCm1AN+8+qtnphHnx93gOt0ZixjxZz/R8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TQ+4aLqvjC7YTZq6gLfJfXdlnKxwwtVaCM2MfZiQMpO4VzOMCz5uH/GnkziIOKqIJi78I8X38cEkUCivR8IgWvZwJGcB31mXfVN/FLFQDDa4eHPbKnC2dEOAmXc8EhFU+3Txlh693z2P6OwQQwNCHv0RJqJ0cNpof3SqOQaPSvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hMiMb7/L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hMiMb7/L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723054637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ld86UgGoDRrXTic/1WMocxmWx+fBwk/acKL0tlfZWLo=;
	b=hMiMb7/Ljq/FC+48gjumaEe/pK4XGPNI/z6A6Lgn8Irq43iGgSCUy3JbAYHLGNr8P40tFW
	mLjL1YklV8SrDzW04RkRSj0aUyE1VNTJ2BtQ5YqnTJXBlEluzogNTZGCJWWHAZqKm15ctY
	RdaC3EfGgMq4x/Z2QnYTObpIoKs55qc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-q_SYui4-PD6QARIeXIHlrQ-1; Wed,
 07 Aug 2024 14:17:14 -0400
X-MC-Unique: q_SYui4-PD6QARIeXIHlrQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7660D1945106;
	Wed,  7 Aug 2024 18:17:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.32.103])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B04619560AE;
	Wed,  7 Aug 2024 18:17:12 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	cem@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2] xfs_db: release ip resource before returning from get_next_unlinked()
Date: Wed,  7 Aug 2024 13:15:54 -0500
Message-ID: <20240807181553.243646-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Fix potential memory leak in function get_next_unlinked(). Call
libxfs_irele(ip) before exiting.

Details:
Error: RESOURCE_LEAK (CWE-772):
xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
#   74|   	libxfs_buf_relse(ino_bp);
#   75|
#   76|-> 	return ret;
#   77|   bad:
#   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
v2: cover the error case.
---
 db/iunlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3..bd973600 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -72,9 +72,12 @@ get_next_unlinked(
 	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
 	ret = be32_to_cpu(dip->di_next_unlinked);
 	libxfs_buf_relse(ino_bp);
+	libxfs_irele(ip);
 
 	return ret;
 bad:
+	libxfs_buf_relse(ino_bp);
+	libxfs_irele(ip);
 	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
 	return NULLAGINO;
 }
-- 
2.45.2

