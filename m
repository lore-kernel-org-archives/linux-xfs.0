Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B7C15FA73
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381236; cv=none; b=MlttqHzuq7QtLLPo1tdlDmb80gBARLdk6TERntwFVX7PBqiBlEr5aWK0gYdHSdnKlWqqZ+Fi0jwC+cJpGUvwV8Z46lx2lkZoAKZv7oK8+diOEPoB2Sf5t00WRhKh49BPv3eIEM8X42Gd6x+N7GD8erT1v2IR3jjVdgB1eNQKf/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381236; c=relaxed/simple;
	bh=XYMuT9GJrVKXvr/NqfPnXmIHzJIajSiZCb3ATD8A59E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhhRLrMuWODKGrn+FZJBajriMmJemuQ5VQbd3qk4NZ+gdMA6FPV14DfyypR+gT5wy/bV6jsGZifYOqPPCrr9T+OgWtZKO21NaZ9poLIoG+/pbD4lPvcZA2pH0BpsNg8UyLI5MqKrMuPn3B4EokdrL6wkTUGns4xJcDKKNLb87+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2Lzmmv3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2Lzmmv3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718381234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUlYbVOQDqfN6smUHD74NPUgX6Wbz3CUTP7zc3W/Xn0=;
	b=a2Lzmmv3gAz6Cmb6+DH5AAO7N53kg42VlUN8PbvSEdRIsk/JXsmSA+C7UO2G6m8JyXmSzk
	Uqxyei2ParuAD7XiSwdWc8Lkk7UiasYC2LdTvrWAKNztNKdlaWZIAhgFRVdJxuX+pWdXFO
	1DKx0Rfmmct9hZ/p6UguFzPfFAKTIN8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-grIl4KdLPze5o9irBeXRpA-1; Fri,
 14 Jun 2024 12:07:12 -0400
X-MC-Unique: grIl4KdLPze5o9irBeXRpA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E654419560B1;
	Fri, 14 Jun 2024 16:07:10 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 558B319560BF;
	Fri, 14 Jun 2024 16:07:09 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/4] xfs_db: fix unitialized automatic struct ifake to 0.
Date: Fri, 14 Jun 2024 11:00:14 -0500
Message-ID: <20240614160643.1879156-3-bodonnel@redhat.com>
In-Reply-To: <20240614160643.1879156-1-bodonnel@redhat.com>
References: <20240614160643.1879156-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Ensure automatic struct ifake is properly initialized.

Coverity-id: 1596600, 1596597

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/bmap_inflate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index 33b0c954..219f9bbf 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -340,7 +340,7 @@ build_new_datafork(
 	const struct xfs_bmbt_irec	*irec,
 	xfs_extnum_t			nextents)
 {
-	struct xbtree_ifakeroot		ifake;
+	struct xbtree_ifakeroot		ifake = {};
 	struct xfs_btree_cur		*bmap_cur;
 	int				error;
 
@@ -394,7 +394,7 @@ estimate_size(
 		.leaf_slack		= 1,
 		.node_slack		= 1,
 	};
-	struct xbtree_ifakeroot		ifake;
+	struct xbtree_ifakeroot		ifake = {};
 	struct xfs_btree_cur		*bmap_cur;
 	int				error;
 
-- 
2.45.2

